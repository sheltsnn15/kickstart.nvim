-- ============================================================
-- Clipboard History
-- Telescope-powered yank and macro history
-- ============================================================

vim.pack.add {
  'https://github.com/AckslD/nvim-neoclip.lua',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/kkharji/sqlite.lua',
}

require('neoclip').setup {
  history = 1000,

  enable_persistent_history = true,

  db_path = vim.fn.stdpath 'data' .. '/databases/neoclip.sqlite3',

  preview = true,

  default_register = '"',

  default_registers = {
    '"',
    '+',
    '*',
  },

  enable_macro_history = true,

  content_spec_column = false,

  filter = function(data)
    if data.event == 'yank' and type(data.regcontents) == 'table' then
      local text = table.concat(data.regcontents, '\n')

      -- Ignore binary-like content
      if text:find '%z' then return false end
    end

    return true
  end,
}

pcall(require('telescope').load_extension, 'neoclip')

-- ============================================================
-- Clipboard Keymaps
-- ============================================================

vim.keymap.set('n', '<leader>sy', function() require('telescope').extensions.neoclip.default() end, {
  desc = '[S]earch [Y]ank history',
})

vim.keymap.set('n', '<leader>sm', function() require('telescope').extensions.neoclip.macro() end, {
  desc = '[S]earch [M]acro history',
})

-- ============================================================
-- OSC52 Clipboard
-- Built into modern Neovim versions
-- Useful for SSH and tmux sessions
-- ============================================================

if vim.env.SSH_CONNECTION or vim.env.TMUX then vim.g.clipboard = 'osc52' end
