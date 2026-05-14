-- ============================================================
-- Quickfix
-- Improved quickfix UI, editing, and navigation
-- ============================================================

vim.pack.add {
  'https://github.com/stevearc/quicker.nvim',
}

require('quicker').setup {
  -- Local options for quickfix buffers
  opts = {
    buflisted = false,
    number = false,
    relativenumber = false,
    signcolumn = 'auto',
    winfixheight = true,
    wrap = false,
  },

  -- Apply default quickfix improvements
  use_default_opts = true,

  -- Quickfix buffer keymaps
  keys = {
    {
      '>',
      function()
        require('quicker').expand {
          before = 2,
          after = 2,
          add_to_existing = true,
        }
      end,

      desc = 'Expand quickfix context',
    },

    {
      '<',
      function()
        require('quicker').collapse()
      end,

      desc = 'Collapse quickfix context',
    },
  },

  -- Additional quickfix buffer setup
  on_qf = function(bufnr)
    vim.keymap.set(
      'n',
      '<leader>r',
      function()
        require('quicker').refresh()
      end,
      {
        buffer = bufnr,
        desc = 'Refresh quickfix',
      }
    )
  end,

  edit = {
    -- Allow editing quickfix entries directly
    enabled = true,

    -- Automatically save modified buffers after edits
    autosave = 'unmodified',
  },

  -- Keep cursor aligned to the content column
  constrain_cursor = true,

  -- Syntax and semantic highlighting
  highlight = {
    treesitter = true,
    lsp = true,
    load_buffers = true,
  },

  -- Diagnostic icons
  type_icons = {
    E = '󰅚 ',
    W = '󰀪 ',
    I = ' ',
    N = ' ',
    H = ' ',
  },

  -- Quickfix window borders
  borders = {
    vert = '┃',
    strong_header = '━',
    strong_cross = '╋',
    strong_end = '┫',
    soft_header = '╌',
    soft_cross = '╂',
    soft_end = '┨',
  },

  -- Trim shared indentation from entries
  trim_leading_whitespace = 'common',

  -- Dynamic filename column width
  max_filename_width = function()
    return math.floor(math.min(95, vim.o.columns / 2))
  end,

  -- Dynamic header width
  header_length = function(_, start_col)
    return vim.o.columns - start_col
  end,
}
