return {
  {
    -- Add 'quicker.nvim'
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    opts = {
      -- Local options for quickfix buffer
      opts = {
        buflisted = false,
        number = false,
        relativenumber = false,
        signcolumn = 'auto',
        winfixheight = true,
        wrap = false,
      },
      -- Enable default options
      use_default_opts = true,
      -- Keymaps for quickfix buffer
      keys = {
        {
          '>',
          function()
            require('quicker').expand { before = 2, after = 2, add_to_existing = true }
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
      -- Callback for additional quickfix logic
      on_qf = function(bufnr)
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>r',
          "<cmd>lua require('quicker').refresh()<CR>",
          { desc = 'Refresh quickfix', noremap = true, silent = true }
        )
      end,
      -- Edit options for quickfix
      edit = {
        enabled = true,
        autosave = 'unmodified',
      },
      -- Cursor behavior
      constrain_cursor = true,
      -- Highlighting settings
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
      -- Borders for quickfix items
      borders = {
        vert = '┃',
        strong_header = '━',
        strong_cross = '╋',
        strong_end = '┫',
        soft_header = '╌',
        soft_cross = '╂',
        soft_end = '┨',
      },
      -- Trimming leading whitespace
      trim_leading_whitespace = 'common',
      -- Filename column width
      max_filename_width = function()
        return math.floor(math.min(95, vim.o.columns / 2))
      end,
      -- Header length for quickfix
      header_length = function(type, start_col)
        return vim.o.columns - start_col
      end,
    },
  },
}
