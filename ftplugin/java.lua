-- ~/.config/nvim/ftplugin/java.lua
local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

-- Find project root
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

-- Paths (Mason)
local data = vim.fn.stdpath 'data'
local jdtls_path = data .. '/mason/packages/jdtls'
local java_debug = data .. '/mason/packages/java-debug-adapter'
local java_test = data .. '/mason/packages/java-test'

-- JDTLS launcher jar (use list form of glob)
local launchers = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar', true, true)
if #launchers == 0 then
  vim.notify('jdtls launcher JAR not found', vim.log.levels.ERROR)
  return
end
local launcher_jar = launchers[1]

-- OS-specific config dir
local sys = vim.loop.os_uname().sysname
local os_cfg = (sys == 'Darwin') and 'config_mac' or (sys:match 'Windows' and 'config_win' or 'config_linux')

-- Workspace per project
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = data .. '/jdtls-workspace/' .. project_name

-- Bundles (debug & test)
local bundles = {}
if vim.fn.isdirectory(java_debug) == 1 then
  vim.list_extend(bundles, vim.fn.glob(java_debug .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true))
end
if vim.fn.isdirectory(java_test) == 1 then
  vim.list_extend(bundles, vim.fn.glob(java_test .. '/extension/server/*.jar', true, true))
end

-- Capabilities from blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Config
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
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = 'all' } },
      format = { enabled = false },
    },
  },
  init_options = { bundles = bundles },
  on_attach = function(client, bufnr)
    -- No keymaps; keep it automatic
    client.server_capabilities.documentFormattingProvider = false

    -- Auto refresh CodeLens
    if client.server_capabilities.codeLensProvider then
      local grp = vim.api.nvim_create_augroup('jdtls-codelens', { clear = false })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
        buffer = bufnr,
        group = grp,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end

    -- Auto organize imports on save (before the formatter runs)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        pcall(jdtls.organize_imports)
      end,
      desc = 'JDTLS organize imports',
    })
  end,
}

-- DAP: enable hot code replace automatically
pcall(jdtls.setup_dap, { hotcodereplace = 'auto' })
require('jdtls').start_or_attach(config)
