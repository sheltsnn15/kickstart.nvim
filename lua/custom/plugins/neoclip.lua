-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      local neoclip = require 'neoclip'
      neoclip.setup {
        history = 1000,
        enable_persistent_history = false,
        length_limit = 1048576,
        continuous_sync = false,
        db_path = vim.fn.stdpath 'data' .. '/databases/neoclip.sqlite3',
        preview = true,
        default_register = '"',
        enable_macro_history = true,
        keys = {
          telescope = {
            i = {
              select = '<cr>',
              paste = '<c-p>',
              paste_behind = '<c-k>',
              replay = '<c-q>',
              delete = '<c-d>',
              edit = '<c-e>',
            },
            n = {
              select = '<cr>',
              paste = 'p',
              paste_behind = 'P',
              replay = 'q',
              delete = 'd',
              edit = 'e',
            },
          },
        },
      }

      -- Keymaps for Neoclip
      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, opts)
      end

      -- Keymap definitions
      map('n', '<leader>sy', function()
        require('telescope').extensions.neoclip.default()
      end, { desc = '[S]earch [Y]ank history' })
    end,
  },

  -- OSC52 copy + built-in PowerShell paste
  {
    'ojroques/nvim-osc52',
    config = function()
      local osc52 = require 'osc52'
      osc52.setup { max_length = 0, silent = true, trim = false }

      -- COPY: send yanks to terminal via OSC52 (WezTerm forwards to Windows clipboard)
      local function osc52_copy(lines, _)
        osc52.copy(table.concat(lines, '\n'))
      end

      -- PASTE: use built-in PowerShell Get-Clipboard (no extra tools)
      local pwsh = 'powershell.exe -NoProfile -Command Get-Clipboard'
      -- If you prefer the full path, uncomment the next line:
      -- pwsh = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command Get-Clipboard'

      vim.g.clipboard = {
        name = 'osc52+powershell',
        copy = { ['+'] = osc52_copy, ['*'] = osc52_copy },
        paste = { ['+'] = pwsh, ['*'] = pwsh },
      }
    end,
  },
}
