-- plugins/git-extras.lua
return {
  -- Diffview plugin configuration
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          merge_tool = {
            layout = 'diff3_mixed',
            disable_diagnostics = true,
          },
        },
      }

      -- Define Diffview key mappings
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Basic mappings for opening, closing, and file history
      map('n', '<leader>gdo', ':DiffviewOpen<CR>', { desc = '[O]pen [D]iffview' })
      map('n', '<leader>gdc', ':DiffviewClose<CR>', { desc = '[C]lose [D]iffview' })
      map('n', '<leader>gdh', ':DiffviewFileHistory<CR>', { desc = '[D]iffview File [H]istory' })
      map('n', '<leader>gdf', ':DiffviewToggleFiles<CR>', { desc = 'Toggle [D]iffview [F]iles Panel' })
      map('n', '<leader>gdr', ':DiffviewRefresh<CR>', { desc = '[R]efresh [D]iffview' })
    end,
  },

  -- Gitignore plugin configuration
  {
    'wintermute-cell/gitignore.nvim',
    config = function()
      -- Ensure the plugin is loaded
      require 'gitignore'

      -- Define Gitignore key mappings
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<leader>gi', ':Gitignore<CR>', { desc = 'Create [G]it[I]gnore File' })
    end,
  },

  -- Octo plugin, edit and review GitHub issues and pull requests
  {
    'ldelossa/gh.nvim',
    dependencies = {
      {
        'ldelossa/litee.nvim',
        config = function()
          require('litee.lib').setup()
        end,
      },
    },
    config = function()
      -- Setup Litee and gh.nvim
      require('litee.lib').setup()
      require('litee.gh').setup {
        jump_mode = 'invoking',
        map_resize_keys = false,
        disable_keymaps = false,
        icon_set = 'default',
        git_buffer_completion = true,
        keymaps = {
          open = '<CR>',
          expand = 'zo',
          collapse = 'zc',
          goto_issue = 'gd',
          details = 'd',
          submit_comment = '<C-s>',
          actions = '<C-a>',
          resolve_thread = '<C-r>',
          goto_web = 'gx',
        },
      }

      -- Helper function for key mappings
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<leader>ghcc', ':GHCloseCommit<CR>', { desc = '[G]it[H]ub [C]lose [C]ommit' })
      map('n', '<leader>ghce', ':GHExpandCommit<CR>', { desc = '[G]it[H]ub [E]xpand [C]ommit' })
      map('n', '<leader>ghco', ':GHOpenToCommit<CR>', { desc = '[G]it[H]ub [O]pen [C]ommit' })
      map('n', '<leader>ghcp', ':GHPopOutCommit<CR>', { desc = '[G]it[H]ub [P]op Out [C]ommit' })
      map('n', '<leader>ghcz', ':GHCollapseCommit<CR>', { desc = '[G]it[H]ub Collapse [C]ommit' })
      map('n', '<leader>ghip', ':GHPreviewIssue<CR>', { desc = '[G]it[H]ub [P]review [I]ssue' })
      map('n', '<leader>ghlt', ':LTPanel<CR>', { desc = '[G]it[H]ub [T]oggle Panel' })
      map('n', '<leader>ghpc', ':GHClosePR<CR>', { desc = '[G]it[H]ub [C]lose [P]R' })
      map('n', '<leader>ghpd', ':GHPRDetails<CR>', { desc = '[G]it[H]ub [P]R [D]etails' })
      map('n', '<leader>ghpe', ':GHExpandPR<CR>', { desc = '[G]it[H]ub [E]xpand [P]R' })
      map('n', '<leader>ghpo', ':GHOpenPR<CR>', { desc = '[G]it[H]ub [O]pen [P]R' })
      map('n', '<leader>ghpp', ':GHPopOutPR<CR>', { desc = '[G]it[H]ub [P]opOut [P]R' })
      map('n', '<leader>ghpr', ':GHRefreshPR<CR>', { desc = '[G]it[H]ub [R]efresh [P]R' })
      map('n', '<leader>ghpt', ':GHOpenToPR<CR>', { desc = '[G]it[H]ub Open [T]o [P]R' })
      map('n', '<leader>ghpz', ':GHCollapsePR<CR>', { desc = '[G]it[H]ub Collapse [P]R' })
      map('n', '<leader>ghrb', ':GHStartReview<CR>', { desc = '[G]it[H]ub [B]egin [R]eview' })
      map('n', '<leader>ghrc', ':GHCloseReview<CR>', { desc = '[G]it[H]ub [C]lose [R]eview' })
      map('n', '<leader>ghrd', ':GHDeleteReview<CR>', { desc = '[G]it[H]ub [D]elete [R]eview' })
      map('n', '<leader>ghre', ':GHExpandReview<CR>', { desc = '[G]it[H]ub [E]xpand [R]eview' })
      map('n', '<leader>ghrs', ':GHSubmitReview<CR>', { desc = '[G]it[H]ub [S]ubmit [R]eview' })
      map('n', '<leader>ghrz', ':GHCollapseReview<CR>', { desc = '[G]it[H]ub Collapse [R]eview' })
      map('n', '<leader>ghtc', ':GHCreateThread<CR>', { desc = '[G]it[H]ub [C]reate [T]hread' })
      map('n', '<leader>ghtn', ':GHNextThread<CR>', { desc = '[G]it[H]ub [N]ext [T]hread' })
      map('n', '<leader>ghtt', ':GHToggleThread<CR>', { desc = '[G]it[H]ub [T]oggle [T]hread' })
    end,
  },
}
