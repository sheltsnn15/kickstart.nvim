return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
    'mfussenegger/nvim-dap-python',
  },
  opts = {
    -- Configuration options for the plugin
    auto_refresh = true, -- Enable auto-refresh to automatically refresh search
    search_venv_managers = true, -- Enable search for venv managers (e.g., Poetry, Pipenv)
    search_workspace = true, -- Enable search within the LSP workspace
    dap_enabled = true, -- Enable DAP support for debugging
    name = 'venv', -- Name of the venv directories to look for
    parents = 2, -- Number of parent directories to search up from the current file
    notify_user_on_activate = true, -- Notify when a venv is activated
    -- Paths for various venv managers
    poetry_path = '/home/shelton/.cache/pypoetry/virtualenvs',
    pipenv_path = '/home/shelton/.local/share/virtualenvs',
    pyenv_path = '/home/shelton/.pyenv/versions',
    anaconda_base_path = '/home/shelton/miniconda3',
    anaconda_envs_path = '/home/shelton/miniconda3/envs',
    espressif_path = '/home/shelton/.espressif/python_env',
  },
  event = 'VeryLazy', -- Optionally load the plugin lazily
  keys = {
    { '<leader>cs', '<cmd>VenvSelect<cr>', desc = '[S]elect VirtualEnv' }, -- Open VenvSelector
    { '<leader>cc', '<cmd>VenvSelectCached<cr>', desc = 'Select [C]ached VirtualEnv' }, -- Select cached venv
  },
  config = function()
    require('venv-selector').setup {
      -- Custom configuration options
      -- You can add or modify the options here
      -- Example:
      -- name = "venv",
      -- auto_refresh = true
    }
  end,
}
