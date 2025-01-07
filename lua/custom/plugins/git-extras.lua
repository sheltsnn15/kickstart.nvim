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
}
