return {
  'lewis6991/hover.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Pickers
    'nvim-telescope/telescope.nvim',
    -- Syntax highlighting
    'nvim-treesitter/nvim-treesitter',
  },

  config = function()
    require('hover').setup {
      init = function()
        -- Require providers
        require 'hover.providers.lsp'
        -- Additional providers can be enabled as needed
      end,
      preview_opts = {
        border = 'single',
      },
      preview_window = false,
      title = true,
      mouse_providers = { 'LSP' },
      mouse_delay = 1000,
    }

    local leader_c = '<leader>c'
    -- Setup keymaps with new leader prefix
    vim.keymap.set('n', leader_c .. 'K', require('hover').hover, { desc = 'Hover info for symbol' })
    vim.keymap.set('n', leader_c .. 'gK', require('hover').hover_select, { desc = 'Select hover source' })
    vim.keymap.set('n', leader_c .. '<C-p>', function()
      require('hover').hover_switch 'previous'
    end, { desc = 'Previous hover source' })
    vim.keymap.set('n', leader_c .. '<C-n>', function()
      require('hover').hover_switch 'next'
    end, { desc = 'Next hover source' })
  end,
}
