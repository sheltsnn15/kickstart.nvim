-- ============================================================
-- Clipboard History
-- Telescope-powered yank and macro history
-- ============================================================

vim.pack.add {
  'https://github.com/AckslD/nvim-neoclip.lua',
  'https://github.com/nvim-telescope/telescope.nvim',
}

require('neoclip').setup {
  history = 1000,
  enable_persistent_history = false,
  default_register = { '"', '+', '*' },
  enable_macro_history = true,
  preview = true,
}

pcall(require('telescope').load_extension, 'neoclip')

vim.keymap.set('n', '<leader>sy', function()
  require('telescope').extensions.neoclip.default()
end, { desc = '[S]earch [Y]ank history' })

vim.keymap.set('n', '<leader>sm', function()
  require('telescope').extensions.neoclip.macro()
end, { desc = '[S]earch [M]acro history' })
