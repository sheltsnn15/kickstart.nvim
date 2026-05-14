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
      --
      -- background-index:
      --   Builds a persistent symbol index in the background.
      --
      -- clang-tidy:
      --   Enables additional linting and static analysis.
      --
      -- header-insertion=iwyu:
      --   Automatically inserts recommended includes.
      --
      -- completion-style=detailed:
      --   More verbose completion information.
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
      --
      -- Falls back to git root if no explicit build files exist.
      root_dir = function(fname)
        return util.root_pattern('makefile', 'configure.ac', 'configure.in', 'config.h.in', 'meson.build', 'meson_options.txt', 'build.ninja')(fname)
          or util.root_pattern('compile_commands.json', 'compile_flags.txt')(fname)
          or vim.fs.dirname(vim.fs.find('.git', {
            path = fname,
            upward = true,
          })[1])
      end,

      -- Automatically detect out-of-tree build directories containing
      -- compile_commands.json and point clangd at them.
      --
      -- Without this, clangd often fails to resolve includes properly
      -- in CMake or Ninja projects.
      on_new_config = function(new_config, new_root_dir)
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

      on_attach = function(client, _)
        -- Disable formatting so formatting is handled by Conform instead.
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
  --
  -- nvim-metals provides integration with the Metals language server.
  -- This handles:
  --
  -- - Scala navigation and diagnostics
  -- - sbt integration
  -- - code actions and semantic analysis
  -- - inferred type hints and implicit resolution

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

  -- Automatically attach Metals when opening Scala, sbt, or Java files.
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
  --
  -- cmake-tools.nvim provides:
  --
  -- - project configuration
  -- - build/run integration
  -- - test execution
  -- - compile_commands generation
  --
  -- Especially useful for C and C++ projects using CMake.

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

    -- Default build directory used by generated build systems.
    cmake_build_directory = 'build',

    -- Default build type for generated projects.
    cmake_build_type = 'Debug',

    -- Export compile_commands.json automatically for clangd.
    cmake_generate_options = {
      '-D',
      'CMAKE_EXPORT_COMPILE_COMMANDS=1',
    },

    cmake_build_options = {},

    -- Configure integrated terminal behavior.
    cmake_console_size = 10,
    cmake_console_position = 'belowright',
    cmake_show_console = 'always',
  }
end
