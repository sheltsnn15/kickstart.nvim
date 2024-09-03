-- plugins.lua
return {
  -- Plugin for seamless navigation between tmux panes and Neovim splits
  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Define key bindings
      map('n', '<C-h>', [[:TmuxNavigateLeft<cr>]], { desc = 'Navigate to left pane/split' })
      map('n', '<C-j>', [[:TmuxNavigateDown<cr>]], { desc = 'Navigate down to pane/split' })
      map('n', '<C-k>', [[:TmuxNavigateUp<cr>]], { desc = 'Navigate up to pane/split' })
      map('n', '<C-l>', [[:TmuxNavigateRight<cr>]], { desc = 'Navigate to right pane/split' })
      map('n', '<C-\\>', [[:TmuxNavigatePrevious<cr>]], { desc = 'Navigate to previous pane/split' })
    end,
  },

  -- Plugin for running tests in Neovim through tmux
  {
    'vim-test/vim-test',
    config = function()
      vim.g['test#strategy'] = 'vimux'

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Define key bindings
      map('n', '<leader>vn', [[:TestNearest<cr>]], { desc = 'Run nearest test' })
      map('n', '<leader>vf', [[:TestFile<cr>]], { desc = 'Run tests in current file' })
      map('n', '<leader>vs', [[:TestSuite<cr>]], { desc = 'Run complete test suite' })
      map('n', '<leader>vl', [[:TestLast<cr>]], { desc = 'Run last test again' })
      map('n', '<leader>vv', [[:TestVisit<cr>]], { desc = 'Visit test file' })
    end,
  },

  -- Plugin for interacting with tmux from within Neovim
  {
    'benmills/vimux',
    config = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Define key bindings
      map('n', '<leader>vp', [[:VimuxPromptCommand<cr>]], { desc = 'Prompt for a tmux command' })
      map('n', '<leader>vl', [[:VimuxRunLastCommandAgain<cr>]], { desc = 'Run last tmux command again' })
      map('n', '<leader>vi', [[:VimuxInspectRunner<cr>]], { desc = 'Inspect tmux runner pane' })
    end,
  },

  -- You can add more plugins here...
}
