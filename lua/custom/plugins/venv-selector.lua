return {
  'linux-cultist/venv-selector.nvim',
  cmd = 'VenvSelect',
  opts = {
    dap_enabled = true, -- Set to true if you want DAP support
  },
  keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
  config = function()
    require('venv-selector').setup {
      -- Anaconda settings
      anaconda_base_path = '/home/shelton/miniconda3', -- Set the base path where Anaconda is installed
      anaconda_envs_path = '/home/shelton/miniconda3/envs', -- Set the path where Anaconda environments are stored
    }
  end,
}
