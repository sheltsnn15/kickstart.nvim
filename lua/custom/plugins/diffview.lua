-- diffview.lua
-- plugins/diffview.lua
return {
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

    -- Define key mappings
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
}
