--------------------------------------------------------------------------------
-- ftplugin/java.lua
--
-- Automatically loads when you open a *.java file. This sets up jdtls for
-- advanced Java features, debugging, code lenses for tests, etc.
--------------------------------------------------------------------------------

local jdtls = require 'jdtls'

-- Determine the project root
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

-- Define paths
local home = vim.fn.stdpath 'data'
local jdtls_path = home .. '/mason/packages/jdtls'
local java_debug_path = home .. '/mason/packages/java-debug-adapter'
local java_test_path = home .. '/mason/packages/java-test'

-- Locate the JDTLS launcher JAR
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

-- Define the workspace directory
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.local/share/eclipse/' .. project_name

-- Configure JDTLS
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
    '-configuration',
    jdtls_path .. '/config_linux',
    '-data',
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = {
        parameterNames = { enabled = 'all' },
      },
    },
  },
  init_options = {
    bundles = {
      vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
      unpack(vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar', 1), '\n')),
    },
  },
}

-- Start or attach JDTLS
jdtls.start_or_attach(config)
