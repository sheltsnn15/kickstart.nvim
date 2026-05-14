return {
  -- ============================================================
  -- nvim-jdtls plugin registration and dependencies
  -- ============================================================

  {
    'mfussenegger/nvim-jdtls',

    ft = 'java',

    dependencies = {
      -- Core LSP support
      'neovim/nvim-lspconfig',

      -- Mason package management
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Java debugging support
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'jay-babu/mason-nvim-dap.nvim',
    },

    config = function()
      -- [[ Java LSP ]]
      --
      -- Main JDTLS configuration is handled inside:
      --
      --   ftplugin/java.lua
      --
      -- This keeps Java-specific startup logic isolated to Java buffers
      -- instead of loading globally during Neovim startup.
    end,
  },
}
