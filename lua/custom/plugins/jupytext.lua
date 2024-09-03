-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'GCBallesteros/jupytext.nvim',
  config = function()
    require('jupytext').setup {
      style = 'hydrogen', -- or your preferred style
      output_extension = 'auto',
      force_ft = nil,
      custom_language_formatting = {},
    }

    -- Keybindings for jupytext.nvim
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = 0
      vim.keymap.set(mode, l, r, opts)
    end

    -- Define keybindings
    map('n', '<leader>jc', ':JupytextConvert<CR>', { desc = '[C]onvert Notebook' })
    map('n', '<leader>js', ':JupytextSync<CR>', { desc = '[S]ync Notebook' })
  end,
  lazy = false, -- Ensure the plugin loads immediately
}
