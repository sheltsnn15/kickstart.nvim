-- plugins/git-extras.lua
return {
  -- Diffview plugin configuration
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
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

      map('n', '<leader>go', ':DiffviewOpen<CR>', { desc = '[O]pen Diffview' })
      map('n', '<leader>gc', ':DiffviewClose<CR>', { desc = '[C]lose Diffview' })
      map('n', '<leader>gh', ':DiffviewFileHistory<CR>', { desc = 'File [H]istory' })
      map('n', '<leader>gf', ':DiffviewToggleFiles<CR>', { desc = 'Toggle [F]iles Panel' })
      map('n', '<leader>gr', ':DiffviewRefresh<CR>', { desc = '[R]efresh Diffview' })
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

      map('n', '<leader>gi', ':Gitignore<CR>', { desc = 'Create Git[I]gnore File' })
    end,
  },
  -- Git-conflict plugin configuration
  {
    'akinsho/git-conflict.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }, -- Optional dependency
    config = function()
      require('git-conflict').setup {
        default_mappings = false, -- Disable default mappings
        disable_diagnostics = true,
        highlights = {
          incoming = 'DiffText',
          current = 'DiffAdd',
        },
      }

      -- Define Git-conflict key mappings under <leader>g
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map('n', '<leader>gx', ':GitConflictNextConflict<CR>', { desc = 'Next conflict' })
      map('n', '<leader>gX', ':GitConflictPrevConflict<CR>', { desc = 'Previous conflict' })

      -- Actions
      map('n', '<leader>gco', ':GitConflictChooseOurs<CR>', { desc = 'Choose [O]urs' })
      map('n', '<leader>gci', ':GitConflictChooseTheirs<CR>', { desc = 'Choose [I]ncoming' })
      map('n', '<leader>gcb', ':GitConflictChooseBoth<CR>', { desc = 'Choose [B]oth' })
      map('n', '<leader>gcn', ':GitConflictChooseNone<CR>', { desc = 'Choose [N]one' })

      -- List conflicts in Telescope
      map('n', '<leader>gl', function()
        vim.cmd 'GitConflictListQf'
        require('telescope.builtin').quickfix()
      end, { desc = 'List conflicts with Telescope' })
    end,
  },
}
