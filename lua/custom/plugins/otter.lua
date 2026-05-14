-- ============================================================
-- Embedded Code Block LSP
-- LSP support for fenced code blocks in Markdown and Quarto
-- ============================================================

vim.pack.add {
  'https://github.com/jmbuhr/otter.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

require('otter').setup {
  lsp = {
    diagnostic_update_events = { 'BufWritePost' },

    root_dir = function(_, bufnr)
      return vim.fs.root(bufnr or 0, {
        '.git',
        '_quarto.yml',
        'package.json',
      }) or vim.fn.getcwd(0)
    end,
  },

  buffers = {
    -- Keep temporary otter buffers in memory only
    write_to_disk = false,
  },

  strip_wrapping_quote_characters = {
    "'",
    '"',
    '`',
  },

  handle_leading_whitespace = true,

  extensions = {},

  debug = false,

  verbose = {
    no_code_found = false,
  },
}

-- Automatically activate Otter for markdown-style documents
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = {
    '*.md',
    '*.qmd',
  },

  callback = function() require('otter').activate() end,
})
