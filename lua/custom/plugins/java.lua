-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- nvim-java plugin setup
  {
    'nvim-java/nvim-java',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      -- Setup nvim-java
      require('java').setup {
        -- Java specific configurations
        root_markers = {
          'settings.gradle',
          'pom.xml',
          'build.gradle',
          '.git',
        },
        java_test = { enable = true },
        java_debug_adapter = { enable = true },
        spring_boot_tools = { enable = true },
        jdk = { auto_install = true },
      }

      -- Setup jdtls with lspconfig
      require('lspconfig').jdtls.setup {
        cmd = { 'jdtls' },
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-21',
                  path = vim.fn.expand '~/.sdkman/candidates/java/21.0.5-zulu',
                  default = true,
                },
              },
            },
          },
        },
      }
    end,
  },
}
