return {
  -- ============================================================
  -- SECTION: Diffview
  -- Git diff UI, history inspection, merge conflict workflows
  -- ============================================================

  {
    src = 'https://github.com/sindrets/diffview.nvim',

    dependencies = {
      'https://github.com/nvim-lua/plenary.nvim',
    },

    config = function()
      -- [[ Diffview ]]
      --
      -- Dedicated UI for:
      --
      -- - git diffs
      -- - file history
      -- - merge conflict resolution
      -- - review workflows

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

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- [[ Diffview Keymaps ]]

      map('n', '<leader>gdo', ':DiffviewOpen<CR>', {
        desc = '[O]pen [D]iffview',
      })

      map('n', '<leader>gdc', ':DiffviewClose<CR>', {
        desc = '[C]lose [D]iffview',
      })

      map('n', '<leader>gdh', ':DiffviewFileHistory<CR>', {
        desc = '[D]iffview File [H]istory',
      })

      map('n', '<leader>gdf', ':DiffviewToggleFiles<CR>', {
        desc = 'Toggle [D]iffview [F]iles Panel',
      })

      map('n', '<leader>gdr', ':DiffviewRefresh<CR>', {
        desc = '[R]efresh [D]iffview',
      })
    end,
  },

  -- ============================================================
  -- SECTION: Gitignore
  -- Generate project-specific .gitignore templates
  -- ============================================================

  {
    src = 'https://github.com/wintermute-cell/gitignore.nvim',

    config = function()
      -- [[ Gitignore Generator ]]
      --
      -- Quickly generate .gitignore files using templates for
      -- common languages, frameworks, and tooling setups.

      require 'gitignore'

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<leader>gi', ':Gitignore<CR>', {
        desc = 'Create [G]it[I]gnore File',
      })
    end,
  },
}
