--------------------------------------------------------------------------------
-- ftplugin/java.lua
--
-- Automatically loads when you open a *.java file. This sets up jdtls for
-- advanced Java features, debugging, code lenses for tests, etc.
--------------------------------------------------------------------------------

local jdtls = require 'jdtls'

-- Figure out the project root (Maven, Gradle, or .git)
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

-- Paths for your jdtls & debug/test bundles installed via Mason
local home = vim.fn.getenv 'HOME'
local mason_registry = require 'mason-registry'

local jdtls_pkg = mason_registry.get_package 'jdtls'
local jdtls_path = jdtls_pkg:get_install_path()

-- The launcher .jar
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

-- Configure jdtls
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    launcher_jar,
    -- NOTE: For Windows or macOS, use config_win or config_mac instead:
    '-configuration',
    jdtls_path .. '/config_linux',

    -- Each project will have a unique workspace directory
    '-data',
    root_dir .. '/.jdtls-workspace',
  },

  root_dir = root_dir,

  -- Extend LSP capabilities
  capabilities = require('blink.cmp').get_lsp_capabilities(),

  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = {
        parameterNames = { enabled = 'all' },
      },
      -- You can rely on Conform for formatting, or let JDTLS do it:
      -- format = {
      --   enabled = true,
      --   settings = { url = home .. "/.config/nvim/google-java-format.xml" },
      -- },
    },
  },

  init_options = {
    -- java-debug + java-test bundles
    bundles = {
      vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
      unpack(vim.split(vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', 1), '\n')),
    },
  },
}

jdtls.start_or_attach(config)

local jdtls = require 'jdtls'

-- ... your jdtls.start_or_attach(config) code here ...

-- Create user commands
vim.api.nvim_create_user_command('JdtOrganizeImports', function()
  jdtls.organize_imports()
end, {
  desc = 'Organize Java imports using nvim-jdtls',
})

vim.api.nvim_create_user_command('JdtExtractVariable', function()
  jdtls.extract_variable()
end, {
  desc = 'Extract a variable using nvim-jdtls',
})

vim.api.nvim_create_user_command('JdtExtractConstant', function()
  jdtls.extract_constant()
end, {
  desc = 'Extract a constant using nvim-jdtls',
})

-- Extracting a method is usually done with a visual selection.
-- We'll allow passing the selected range. So we add `range = true`.
vim.api.nvim_create_user_command('JdtExtractMethod', function()
  jdtls.extract_method(true)
end, {
  desc = 'Extract method from visually selected code using nvim-jdtls',
  range = true, -- or use 0- if you want it to handle entire buffer
})

--------------------------------------------------------------------------------
-- Usage Examples:
--
--  :JdtOrganizeImports
--  :JdtExtractVariable
--  :JdtExtractConstant
--
--  For extracting a method, highlight code in visual mode, then:
--  :JdtExtractMethod
--------------------------------------------------------------------------------

-- 6. Set up DAP for Java
jdtls.setup_dap { hotcodereplace = 'auto' }
