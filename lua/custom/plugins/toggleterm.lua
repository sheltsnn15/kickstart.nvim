return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 15,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
    }

    local Terminal = require('toggleterm.terminal').Terminal

    local float_term = Terminal:new { direction = 'float', hidden = true }
    local vert_term = Terminal:new { direction = 'vertical', size = 40, hidden = true }

    -- Define a simple map() helper
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.noremap = true
      opts.silent = true
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Terminal Keybindings
    map('n', '<leader>tt', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = '[T]erminal Toggle (Horizontal)' })
    map('n', '<leader>tv', function()
      vert_term:toggle()
    end, { desc = '[T]erminal Toggle (Vertical)' })
    map('n', '<leader>tf', function()
      float_term:toggle()
    end, { desc = '[T]erminal Toggle (Float)' })
    map('n', '<leader>tn', '<cmd>ToggleTerm<CR>', { desc = '[T]erminal [N]ew (Default)' })
  end,
}
