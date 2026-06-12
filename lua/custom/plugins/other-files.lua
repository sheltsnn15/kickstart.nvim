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
  'https://github.com/hat0uma/csvview.nvim',
}

require('csvview').setup {
  parser = {
    comments = { '#', '//' },
  },
  view = {
    display_mode = 'border',
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'csv',
  callback = function() vim.cmd 'CsvViewEnable' end,
})
