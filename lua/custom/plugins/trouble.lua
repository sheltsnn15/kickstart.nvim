-- plugins/trouble.lua
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Safely load the 'trouble' module
    local status_ok, trouble = pcall(require, 'trouble')
    if not status_ok then
      return
    end

    -- Setup trouble with default options (customize if needed)
    trouble.setup {
      auto_open = false, -- Automatically open Trouble when there are diagnostics
      auto_close = true, -- Automatically close Trouble when there are no diagnostics
      use_diagnostic_signs = true, -- Use the signs defined by your LSP
    }

    -- Define key mappings
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = opts.buffer or false
      opts.noremap = true
      opts.silent = true
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Keybindings for Trouble using Lua functions
    -- Specify the default mode "diagnostics" for <leader>tt
    map('n', '<leader>tt', function()
      trouble.toggle 'diagnostics'
    end, { desc = '[T]oggle [T]rouble' })
    map('n', '<leader>tw', function()
      trouble.toggle 'workspace_diagnostics'
    end, { desc = '[T]oggle [W]orkspace Diagnostics' })
    map('n', '<leader>td', function()
      trouble.toggle 'document_diagnostics'
    end, { desc = '[T]oggle [D]ocument Diagnostics' })
    map('n', '<leader>tl', function()
      trouble.toggle 'loclist'
    end, { desc = '[T]oggle Location List' })
    map('n', '<leader>tq', function()
      trouble.toggle 'quickfix'
    end, { desc = '[T]oggle Quickfix List' })
    map('n', '<leader>tr', function()
      trouble.toggle 'lsp_references'
    end, { desc = '[T]oggle LSP [R]eferences' })
  end,
}
