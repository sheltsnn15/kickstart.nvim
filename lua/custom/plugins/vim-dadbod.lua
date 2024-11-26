return {
  {
    'tpope/vim-dadbod', -- Core plugin for database interaction
    dependencies = {
      'kristijanhusak/vim-dadbod-ui', -- UI for vim-dadbod
      'kristijanhusak/vim-dadbod-completion', -- Autocompletion for SQL queries
    },
    config = function()
      -- Enable Nerd Fonts for vim-dadbod-ui
      vim.g.db_ui_use_nerd_fonts = 1

      -- Set up completion for SQL buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          local cmp = require 'cmp'
          cmp.setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
        end,
      })
    end,
  },
}
