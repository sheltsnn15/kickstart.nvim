-- ============================================================
-- SECTION: Java LSP
-- JDTLS configuration, workspace setup, debugging integration
-- ============================================================

do
  local ok, jdtls = pcall(require, 'jdtls')

  if not ok then return end

  -- [[ Project Root Detection ]]
  --
  -- Detect the project root using common Java build system markers.
  --
  -- Supported:
  --
  -- - Maven
  -- - Gradle
  -- - Git repositories

  local root_markers = {
    '.git',
    'mvnw',
    'gradlew',
    'pom.xml',
    'build.gradle',
  }

  local root_dir = require('jdtls.setup').find_root(root_markers)

  if root_dir == '' then return end

  -- [[ Mason Paths ]]
  --
  -- Resolve installed Mason package locations for:
  --
  -- - JDTLS
  -- - Java debugger
  -- - Java testing extensions

  local data = vim.fn.stdpath 'data'

  local jdtls_path = data .. '/mason/packages/jdtls'
  local java_debug = data .. '/mason/packages/java-debug-adapter'
  local java_test = data .. '/mason/packages/java-test'

  -- [[ JDTLS Launcher ]]
  --
  -- Locate the Eclipse launcher JAR dynamically because the
  -- version number changes between updates.

  local launchers = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar', true, true)

  if #launchers == 0 then
    vim.notify('jdtls launcher JAR not found', vim.log.levels.ERROR)

    return
  end

  local launcher_jar = launchers[1]

  -- [[ OS-Specific Configuration ]]
  --
  -- JDTLS requires different configuration folders depending
  -- on the operating system.

  local sys = vim.loop.os_uname().sysname

  local os_cfg = (sys == 'Darwin') and 'config_mac' or (sys:match 'Windows' and 'config_win' or 'config_linux')

  -- [[ Workspace Directory ]]
  --
  -- Create a dedicated JDTLS workspace per project.
  --
  -- This stores:
  --
  -- - indexes
  -- - caches
  -- - project metadata

  local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')

  local workspace_dir = data .. '/jdtls-workspace/' .. project_name

  -- [[ Debug / Test Bundles ]]
  --
  -- Extend JDTLS with:
  --
  -- - Java debugging support
  -- - Java test runner support

  local bundles = {}

  if vim.fn.isdirectory(java_debug) == 1 then
    vim.list_extend(bundles, vim.fn.glob(java_debug .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true))
  end

  if vim.fn.isdirectory(java_test) == 1 then vim.list_extend(bundles, vim.fn.glob(java_test .. '/extension/server/*.jar', true, true)) end

  -- [[ Completion Capabilities ]]
  --
  -- Integrate blink.cmp completion capabilities into JDTLS.

  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- [[ JDTLS Configuration ]]

  local config = {
    cmd = {
      'java',

      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',

      '-Dlog.protocol=true',
      '-Dlog.level=WARN',

      '-Xms1g',

      '--add-modules=ALL-SYSTEM',

      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',

      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',

      '-jar',
      launcher_jar,

      '-configuration',
      jdtls_path .. '/' .. os_cfg,

      '-data',
      workspace_dir,
    },

    root_dir = root_dir,

    capabilities = capabilities,

    settings = {
      java = {
        -- Automatically download dependency sources.
        eclipse = {
          downloadSources = true,
        },

        maven = {
          downloadSources = true,
        },

        -- Enable CodeLens support.
        implementationsCodeLens = {
          enabled = true,
        },

        referencesCodeLens = {
          enabled = true,
        },

        -- Inline parameter name hints.
        inlayHints = {
          parameterNames = {
            enabled = 'all',
          },
        },

        -- Disable formatting.
        --
        -- Formatting should be handled externally
        -- through Conform or dedicated formatters.
        format = {
          enabled = false,
        },
      },
    },

    init_options = {
      bundles = bundles,
    },

    on_attach = function(client, bufnr)
      -- Disable LSP formatting support.
      client.server_capabilities.documentFormattingProvider = false

      -- [[ CodeLens Auto Refresh ]]
      --
      -- Refresh CodeLens automatically when:
      --
      -- - entering buffers
      -- - leaving insert mode
      -- - holding the cursor

      if client.server_capabilities.codeLensProvider then
        local grp = vim.api.nvim_create_augroup('jdtls-codelens', { clear = false })

        vim.api.nvim_create_autocmd({
          'BufEnter',
          'InsertLeave',
          'CursorHold',
        }, {
          buffer = bufnr,
          group = grp,

          callback = function()
            vim.lsp.codelens.enable(true, {
              bufnr = bufnr,
            })
          end,
        })
      end

      -- [[ Organize Imports ]]
      --
      -- Automatically organize imports before saving.

      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,

        callback = function() pcall(jdtls.organize_imports) end,

        desc = 'JDTLS organize imports',
      })
    end,
  }

  -- [[ Java Debugging ]]
  --
  -- Enable automatic hot code replacement while debugging.

  pcall(jdtls.setup_dap, {
    hotcodereplace = 'auto',
  })

  -- Start or attach to the existing JDTLS instance.
  jdtls.start_or_attach(config)
end
