return {
  -- clangd_extensions.nvim
  {
    'p00f/clangd_extensions.nvim',
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- clangd wants utf-16 offsets for correct ranges
      capabilities.offsetEncoding = { 'utf-16' }

      local util = require 'lspconfig.util'

      require('clangd_extensions').setup {
        server = {
          capabilities = capabilities,
          -- match your old flags
          cmd = {
            'clangd',
            '--background-index',
            '--suggest-missing-includes',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
          },
          root_dir = function(fname)
            return util.root_pattern('makefile', 'configure.ac', 'configure.in', 'config.h.in', 'meson.build', 'meson_options.txt', 'build.ninja')(fname)
              or util.root_pattern('compile_commands.json', 'compile_flags.txt')(fname)
              or util.find_git_ancestor(fname)
          end,
          on_new_config = function(new_config, new_root_dir)
            -- detect out-of-tree compile_commands
            local candidates = {
              'build',
              'build/Debug',
              'build/Release',
              'out',
              'cmake-build-debug',
              'cmake-build-release',
            }
            for _, rel in ipairs(candidates) do
              local dir = new_root_dir .. '/' .. rel
              local cc = dir .. '/compile_commands.json'
              if vim.uv.fs_stat(cc) then
                new_config.cmd = vim.tbl_extend('force', new_config.cmd or { 'clangd' }, {
                  '--compile-commands-dir=' .. dir,
                })
                break
              end
            end
          end,
          on_attach = function(client, bufnr)
            -- keep formatting with Conform (or your formatter) not clangd
            client.server_capabilities.documentFormattingProvider = false

            -- (nice extra) switch between .h/.cpp quickly
            vim.keymap.set('n', 'gs', '<cmd>ClangdSwitchSourceHeader<CR>', {
              buffer = bufnr,
              desc = 'Switch source/header',
            })
          end,
        },
        extensions = {
          autoSetHints = true,
          inlay_hints = { highlight = 'Comment' },
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
