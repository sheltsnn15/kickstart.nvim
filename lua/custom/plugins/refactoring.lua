-- plugins/refactoring.lua
return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'BufReadPre',
  config = function()
    require('refactoring').setup {
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
    }

    -- Define key mappings
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.noremap = true
      opts.silent = true
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Keybindings for Refactoring (using the Lua API directly)
    -- Extract Function
    map('v', '<leader>Re', function()
      require('refactoring').refactor 'Extract Function'
    end, { desc = '[R]efactor [E]xtract Function' })
    map('v', '<leader>Rf', function()
      require('refactoring').refactor 'Extract Function To File'
    end, { desc = '[R]efactor Extract Function to [F]ile' })

    -- Extract Variable
    map('v', '<leader>Rv', function()
      require('refactoring').refactor 'Extract Variable'
    end, { desc = '[R]efactor Extract [V]ariable' })

    -- Inline Variable
    map({ 'n', 'v' }, '<leader>Ri', function()
      require('refactoring').refactor 'Inline Variable'
    end, { desc = '[R]efactor [I]nline Variable' })

    -- Extract Block (Normal mode)
    map('n', '<leader>Rb', function()
      require('refactoring').refactor 'Extract Block'
    end, { desc = '[R]efactor Extract [B]lock' })
    map('n', '<leader>Rbf', function()
      require('refactoring').refactor 'Extract Block To File'
    end, { desc = '[R]efactor Extract Block to [F]ile' })

    -- Inline Function (Normal mode only)
    map('n', '<leader>RI', function()
      require('refactoring').refactor 'Inline Function'
    end, { desc = '[R]efactor [I]nline Function' })

    -- Prompt for refactor using Telescope
    map({ 'n', 'v' }, '<leader>Rr', function()
      require('telescope').extensions.refactoring.refactors()
    end, { desc = '[R]efactor Select with Telescope' })

    -- Debugging features
    map('n', '<leader>Rp', function()
      require('refactoring').debug.printf { below = false }
    end, { desc = '[R]efactor [P]rint Function' })
    map({ 'n', 'x' }, '<leader>RV', function()
      require('refactoring').debug.print_var()
    end, { desc = '[R]efactor Print [V]ariable' })
    map('n', '<leader>Rc', function()
      require('refactoring').debug.cleanup {}
    end, { desc = '[R]efactor [C]leanup Prints' })
  end,
}
