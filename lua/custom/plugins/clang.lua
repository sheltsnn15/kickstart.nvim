return {
  -- clangd_extensions.nvim
  {
    'p00f/clangd_extensions.nvim',
    config = function()
      require('clangd_extensions').setup {
        server = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        extensions = {
          autoSetHints = true,
          inlay_hints = {
            highlight = 'Comment',
          },
        },
      }
    end,
  },

  -- nvim-metals
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt', 'java' },
    config = function()
      local metals_config = require('metals').bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
      }

      metals_config.init_options.statusBarProvider = 'on'

      metals_config.on_attach = function(client, bufnr)
        -- Custom on_attach logic if needed
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt', 'java' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
      })
    end,
  },

  -- cmake-tools.nvim
  -- cmake-tools.nvim
  {
    'Civitasv/cmake-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local ok, cmake_tools = pcall(require, 'cmake-tools')
      if not ok then
        vim.notify('CMake Tools plugin not found', vim.log.levels.ERROR)
        return
      end

      cmake_tools.setup {
        cmake_command = 'cmake',
        cmake_build_directory = 'build',
        cmake_build_type = 'Debug',
        cmake_generate_options = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
        cmake_build_options = {},
        cmake_console_size = 10,
        cmake_console_position = 'belowright',
        cmake_show_console = 'always',
      }
    end,
  },
}
