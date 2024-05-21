return {
  -- Plugin for seamless navigation between tmux panes and Neovim splits
  'christoomey/vim-tmux-navigator',
  config = function()
    vim.g.tmux_navigator_no_mappings = 1

    -- Key bindings for navigating between tmux panes and Neovim splits
    vim.api.nvim_set_keymap('n', '<C-h>', [[:TmuxNavigateLeft<cr>]], { noremap = true, desc = 'Navigate to left pane/split' })
    vim.api.nvim_set_keymap('n', '<C-j>', [[:TmuxNavigateDown<cr>]], { noremap = true, desc = 'Navigate down to pane/split' })
    vim.api.nvim_set_keymap('n', '<C-k>', [[:TmuxNavigateUp<cr>]], { noremap = true, desc = 'Navigate up to pane/split' })
    vim.api.nvim_set_keymap('n', '<C-l>', [[:TmuxNavigateRight<cr>]], { noremap = true, desc = 'Navigate to right pane/split' })
    -- Key binding to navigate back to the previous pane/split
    vim.api.nvim_set_keymap('n', '<C-\\>', [[:TmuxNavigatePrevious<cr>]], { noremap = true, desc = 'Navigate to previous pane/split' })
  end,

  -- Plugin for running tests in Neovim through tmux
  'vim-test/vim-test',
  config = function()
    -- Configure vim-test to use vimux for running tests
    vim.g['test#strategy'] = 'vimux'

    -- Key bindings for running tests
    vim.api.nvim_set_keymap('n', '<leader>tn', [[:TestNearest<cr>]], { noremap = true, desc = 'Run nearest test' })
    vim.api.nvim_set_keymap('n', '<leader>tf', [[:TestFile<cr>]], { noremap = true, desc = 'Run tests in current file' })
    vim.api.nvim_set_keymap('n', '<leader>ts', [[:TestSuite<cr>]], { noremap = true, desc = 'Run complete test suite' })
    vim.api.nvim_set_keymap('n', '<leader>tl', [[:TestLast<cr>]], { noremap = true, desc = 'Run last test again' })
    vim.api.nvim_set_keymap('n', '<leader>tv', [[:TestVisit<cr>]], { noremap = true, desc = 'Visit test file' })
  end,

  -- Plugin for interacting with tmux from within Neovim
  'benmills/vimux',
  config = function()
    -- Key bindings for vimux commands
    vim.api.nvim_set_keymap('n', '<leader>vp', [[:VimuxPromptCommand<cr>]], { noremap = true, desc = 'Prompt for a tmux command' })
    vim.api.nvim_set_keymap('n', '<leader>vl', [[:VimuxRunLastCommandAgain<cr>]], { noremap = true, desc = 'Run last tmux command again' })
    vim.api.nvim_set_keymap('n', '<leader>vi', [[:VimuxInspectRunner<cr>]], { noremap = true, desc = 'Inspect tmux runner pane' })
  end,
}
