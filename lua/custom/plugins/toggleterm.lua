-- ============================================================
-- Terminal
-- Persistent integrated terminal management
-- ============================================================

vim.pack.add {
  'https://github.com/akinsho/toggleterm.nvim',
}

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

do
  local Terminal = require('toggleterm.terminal').Terminal

  -- Floating terminal
  local float_term = Terminal:new {
    direction = 'float',
    hidden = true,
  }

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      desc = desc,
    })
  end

  -- ============================================================
  -- Terminal Keymaps
  -- ============================================================

  map('n', '<leader>tf', function() float_term:toggle() end, '[T]erminal [F]loat')

  map('n', '<leader>tt', '<cmd>ToggleTerm<CR>', '[T]oggle [T]erminal')
end
