-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' }, -- Still allows manual :Trouble usage
    event = { 'BufReadPost', 'BufNewFile' }, -- Preload trouble when buffers are opened
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- Require and setup Trouble
      require('trouble').setup {
        -- Add any custom setup if needed
      }

      -- Define Trouble key mappings with <leader>t prefix
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Trouble Keybindings
      map('n', '<leader>td', '<cmd>Trouble diagnostics toggle<CR>', { desc = '[D]iagnostics (Trouble)' })
      map('n', '<leader>tD', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Buffer [D]iagnostics (Trouble)' })
      map('n', '<leader>ts', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = '[S]ymbols (Trouble)' })
      map('n', '<leader>tl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = '[L]SP Definitions/References' })
      map('n', '<leader>tL', '<cmd>Trouble loclist toggle<CR>', { desc = '[L]ocation List (Trouble)' })
      map('n', '<leader>tq', '<cmd>Trouble qflist toggle<CR>', { desc = '[Q]uickfix List (Trouble)' })

      -- Telescope Integration with Trouble
      local trouble = require 'trouble.sources.telescope'
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          mappings = {
            i = { ['<C-t>'] = trouble.open },
            n = { ['<C-t>'] = trouble.open },
          },
        },
      }
    end,
  },
}
