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
      map('n', '<leader>vn', [[:TestNearest<cr>]], { desc = 'Run [N]earest Test' })
      map('n', '<leader>vf', [[:TestFile<cr>]], { desc = 'Run Tests in Current [F]ile' })
      map('n', '<leader>vt', [[:TestSuite<cr>]], { desc = 'Run Complete [T]est Suite' })
      map('n', '<leader>va', [[:TestLast<cr>]], { desc = 'Run Last Test [A]gain' })
      map('n', '<leader>vv', [[:TestVisit<cr>]], { desc = '[V]isit Test File' })
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

      -- Run the command in a new tmux window instead of a pane
      local function run_in_new_window(command)
        vim.cmd('silent !tmux new-window "' .. command .. '"')
      end

      -- Define key bindings
      map('n', '<leader>vp', [[:VimuxPromptCommand<cr>]], { desc = '[P]rompt for a Tmux Command' })
      map('n', '<leader>vl', [[:VimuxRunLastCommandAgain<cr>]], { desc = 'Run [L]ast Tmux Command Again' })
      map('n', '<leader>vi', [[:VimuxInspectRunner<cr>]], { desc = '[I]nspect Tmux Runner Pane' })
      map('n', '<leader>vw', function()
        run_in_new_window '~/.config/tmux/tmux-cht.sh'
      end, { desc = '[Q]uick Query (tmux-cht.sh)' })
      map('n', '<leader>vs', [[:VimuxRunCommand("tmux-resurrect save")<cr>]], { desc = '[S]ave tmux session' })
      map('n', '<leader>vr', [[:VimuxRunCommand("tmux-resurrect restore")<cr>]], { desc = '[R]estore tmux session' })
      map('n', '<leader>vh', [[:VimuxRunCommand("tmux split-window -h")<cr>]], { desc = 'Split Tmux Window [H]orizontally' })
      map('n', '<leader>vv', [[:VimuxRunCommand("tmux split-window -v")<cr>]], { desc = 'Split Tmux Window [V]ertically' })
    end,
  },

  -- You can add more plugins here...
}
