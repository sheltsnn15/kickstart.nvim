-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- File: ~/.config/nvim/lua/plugins/dadbod.lua
return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      -- Enable Nerd Fonts for vim-dadbod-ui
      vim.g.db_ui_use_nerd_fonts = 1

      -- Disable dadbod-ui's default mappings
      vim.g.db_ui_disable_mappings = 1

      -- Set up completion for SQL buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          local cmp = require 'cmp'
          cmp.setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
        end,
      })

      -- Optional: Set up default database connections
      -- vim.g.db = {
      --   dev = 'mysql://user:password@127.0.0.1/dev_database',
      --   prod = 'mysql://user:password@127.0.0.1/prod_database',
      --   sqlite = 'sqlite:///path/to/database.sqlite',
      --   postgres = 'postgres://user:password@127.0.0.1/postgres_database',
      -- }

      -- Define an on_attach-like function for dbui buffers
      local function on_attach(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Database UI Commands (all prefixed under <leader>o)
        map('n', '<leader>oo', ':DBUI<CR>', { desc = '[O]pen DBUI' })
        map('n', '<leader>ou', ':DBUIToggle<CR>', { desc = '[U]I Toggle' })
        map('n', '<leader>of', ':DBUIFindBuffer<CR>', { desc = '[F]ind Buffer' })
        map('n', '<leader>or', ':DBUIRenameBuffer<CR>', { desc = '[R]ename Buffer' })
        map('n', '<leader>ol', ':DBUILastQueryInfo<CR>', { desc = '[L]ast Query Info' })

        -- Additional useful DBUI commands
        map('n', '<leader>oc', ':DBUIChooseConnection<CR>', { desc = '[C]hoose Connection' })
        map('n', '<leader>oa', ':DBUIAddConnection<CR>', { desc = '[A]dd Connection' })
        map('n', '<leader>oA', ':DBUIAllConnections<CR>', { desc = '[A]ll Connections' })
        map('n', '<leader>oi', ':DBUILogIn<CR>', { desc = 'Log [I]n' })
        map('n', '<leader>oe', ':DBUIConfigureExplorer<CR>', { desc = '[E]xplorer Config' })
      end

      -- Attach the mappings when dbui buffer is opened
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbui',
        callback = function(event)
          on_attach(event.buf)
        end,
      })
    end,
  },
}
