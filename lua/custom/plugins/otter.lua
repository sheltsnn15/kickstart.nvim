return {
  'jmbuhr/otter.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
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
      write_to_disk = false, -- Set to true if you need actual files for linters
    },
    strip_wrapping_quote_characters = { "'", '"', '`' },
    handle_leading_whitespace = true,
    extensions = {},
    debug = false,
    verbose = {
      no_code_found = false,
    },
  },
  config = function(_, opts)
    require('otter').setup(opts)
    -- Automatically activate otter for markdown or quarto files:
    vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = { '*.md', '*.qmd' },
      callback = function()
        require('otter').activate()
      end,
    })
  end,
}
