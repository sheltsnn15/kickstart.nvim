-- ============================================================
-- Hex Editor
-- View and edit binary files using xxd
-- ============================================================

vim.pack.add {
  'https://github.com/RaafatTurki/hex.nvim',
}

require('hex').setup {
  dump_cmd = 'xxd -g 1 -u',
  assemble_cmd = 'xxd -r',
}

-- ============================================================
-- CSV Editing
-- Alignment and delimiter utilities for CSV files
-- ============================================================

vim.pack.add {
  'https://github.com/emmanueltouzery/decisive.nvim',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'csv',

  callback = function() require('decisive').setup {} end,
})
