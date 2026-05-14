-- ============================================================
-- SECTION: Code Runner
-- code_runner.nvim setup and language execution commands
-- ============================================================

do
  -- [[ Code Runner ]]
  --
  -- code_runner.nvim provides quick execution for small programs and
  -- scripts directly inside Neovim.
  --
  -- Useful for:
  --
  -- - competitive programming
  -- - scripting
  -- - quick testing
  -- - small standalone projects
  --
  -- NOTE:
  -- This is not meant to replace proper build systems like:
  --
  -- - CMake
  -- - Make
  -- - Cargo
  -- - Gradle
  --
  -- Keep it for lightweight execution workflows.

  vim.pack.add {
    'https://github.com/CRAG666/code_runner.nvim',
  }

  require('code_runner').setup {
    -- Use toggleterm integration for execution output.
    mode = 'toggleterm',

    term = {
      -- Open runner output in a floating terminal window.
      position = 'float',

      -- Floating terminal height.
      size = 15,
    },

    filetype = {
      -- C++
      --
      -- -Wall / -Wextra:
      --   Enable stronger compiler warnings.
      --
      -- -g:
      --   Include debug symbols for gdb/lldb debugging.
      cpp = {
        'g++ -Wall -Wextra -g $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt',
      },

      -- C
      c = {
        'gcc -Wall -Wextra -g $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt',
      },

      -- Python
      --
      -- -u:
      --   Force unbuffered stdout/stderr for immediate output.
      python = 'python3 -u',

      -- Shell scripts
      bash = 'bash',

      -- Lua
      lua = 'lua',

      -- Go
      --
      -- Uses the standard Go execution workflow.
      go = 'go run $fileName',

      -- Java
      --
      -- Compile first, then run generated class.
      java = {
        'javac $fileName && java -cp $dir $fileNameWithoutExt',
      },

      -- PHP
      php = 'php $fileName',
    },
  }
end
