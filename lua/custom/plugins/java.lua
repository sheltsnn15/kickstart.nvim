-- ~/.config/nvim/lua/custom/plugins/java.lua
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      -- We leave this mostly empty, because the main jdtls config
      -- will live in ftplugin/java.lua
    end,
  },
}
