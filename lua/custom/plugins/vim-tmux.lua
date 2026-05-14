-- ============================================================
-- Tmux Navigation
-- Seamless navigation between tmux panes and Neovim splits
-- ============================================================

vim.pack.add {
  'https://github.com/christoomey/vim-tmux-navigator',
}

vim.g.tmux_navigator_no_mappings = 1

do
  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, {
      desc = desc,
    })
  end

  map('<C-h>', '<cmd>TmuxNavigateLeft<CR>', 'Navigate left')
  map('<C-j>', '<cmd>TmuxNavigateDown<CR>', 'Navigate down')
  map('<C-k>', '<cmd>TmuxNavigateUp<CR>', 'Navigate up')
  map('<C-l>', '<cmd>TmuxNavigateRight<CR>', 'Navigate right')
  map('<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', 'Previous pane')
end
