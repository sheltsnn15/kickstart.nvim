-- ============================================================
-- SECTION: C / C++
-- clangd_extensions.nvim, clangd configuration, compile_commands
-- ============================================================

do
  -- [[ C / C++ LSP Extensions ]]
  --
  -- clangd_extensions.nvim adds extra functionality on top of clangd,
  -- including inlay hints, AST helpers, memory usage info, and improved
  -- integration with modern C/C++ workflows.
  --
  -- NOTE: clangd expects UTF-16 offsets for correct diagnostics/ranges.

  vim.pack.add {
    'https://github.com/p00f/clangd_extensions.nvim',
  }

  local capabilities = vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(), {
    offsetEncoding = { 'utf-16' },
  })

  local util = require 'lspconfig.util'

  require('clangd_extensions').setup {
    server = {
      capabilities = capabilities,

      -- Configure clangd startup behavior.
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

      -- Detect project roots for common C/C++ build systems.
      root_dir = function(fname)
        return util.root_pattern('makefile', 'configure.ac', 'configure.in', 'config.h.in', 'meson.build', 'meson_options.txt', 'build.ninja')(fname)
          or util.root_pattern('compile_commands.json', 'compile_flags.txt')(fname)
          or vim.fs.dirname(vim.fs.find('.git', {
            path = fname,
            upward = true,
          })[1] or fname)
      end,

      -- Automatically detect out-of-tree build directories containing
      -- compile_commands.json and point clangd at them.
      on_new_config = function(new_config, new_root_dir)
        if not new_root_dir then return end

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
            new_config.cmd = vim.list_extend(new_config.cmd or { 'clangd' }, { '--compile-commands-dir=' .. dir })

            break
          end
        end
      end,

      on_attach = function(client, _)
        -- Disable formatting so formatting is handled elsewhere.
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
end

-- ============================================================
-- SECTION: Scala
-- nvim-metals setup and Scala workspace integration
-- ============================================================

do
  -- [[ Scala / Java LSP ]]

  vim.pack.add {
    'https://github.com/scalameta/nvim-metals',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  local metals_config = require('metals').bare_config()

  metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
  }

  metals_config.init_options.statusBarProvider = 'on'

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'scala', 'sbt', 'java' },

    callback = function() require('metals').initialize_or_attach(metals_config) end,
  })
end

-- ============================================================
-- SECTION: CMake
-- cmake-tools.nvim integration and build configuration
-- ============================================================

do
  -- [[ CMake Integration ]]

  vim.pack.add {
    'https://github.com/Civitasv/cmake-tools.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  local ok, cmake_tools = pcall(require, 'cmake-tools')

  if not ok then
    vim.notify('CMake Tools plugin not found', vim.log.levels.ERROR)
    return
  end

  cmake_tools.setup {
    cmake_command = 'cmake',

    -- Use absolute build path to avoid nil path concatenation bugs.
    cmake_build_directory = function()
      local cwd = vim.fn.getcwd()

      if not cwd or cwd == '' then cwd = vim.loop.cwd() end

      return cwd .. '/build'
    end,

    cmake_build_type = 'Debug',

    -- Export compile_commands.json automatically for clangd.
    cmake_generate_options = {
      '-DCMAKE_EXPORT_COMPILE_COMMANDS=1',
    },

    cmake_build_options = {},

    cmake_console_size = 10,
    cmake_console_position = 'belowright',
    cmake_show_console = 'always',
  }
end
