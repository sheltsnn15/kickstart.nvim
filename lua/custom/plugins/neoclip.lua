-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Neoclip plugin for clipboard management with persistent history
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      { 'kkharji/sqlite.lua', module = 'sqlite' }, -- Database backend for persistence
      { 'nvim-telescope/telescope.nvim' }, -- UI for browsing clipboard history
    },
    config = function()
      local neoclip = require 'neoclip'
      neoclip.setup {
        history = 1000, -- Max number of clipboard entries
        enable_persistent_history = false, -- Don't persist between sessions
        length_limit = 1048576, -- Max content length (1MB)
        continuous_sync = false, -- Don't sync continuously
        db_path = vim.fn.stdpath 'data' .. '/databases/neoclip.sqlite3', -- Database location
        preview = true, -- Show previews in telescope
        default_register = '"', -- Default register to use
        enable_macro_history = true, -- Track macro recordings
        keys = {
          telescope = {
            i = { -- Insert mode mappings in telescope
              select = '<cr>', -- Select and paste
              paste = '<c-p>', -- Paste selected entry
              paste_behind = '<c-k>', -- Paste before cursor
              replay = '<c-q>', -- Replay macro
              delete = '<c-d>', -- Delete entry
              edit = '<c-e>', -- Edit entry
            },
            n = { -- Normal mode mappings in telescope
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

      -- Helper function for key mappings
      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, opts)
      end

      -- Keymap to search yank history with telescope
      map('n', '<leader>sy', function()
        require('telescope').extensions.neoclip.default()
      end, { desc = '[S]earch [Y]ank history' })
    end,
  },

  -- OSC52 plugin for cross-terminal clipboard support
  {
    'ojroques/nvim-osc52',
    config = function()
      local osc52 = require 'osc52'
      osc52.setup {
        max_length = 0, -- No limit on content length
        silent = true, -- Don't show confirmation messages
        trim = false, -- Don't trim whitespace
      }

      -- Detect environment for clipboard integration
      local is_wsl = (vim.fn.has 'wsl' == 1)
      local is_win = (vim.fn.has 'win32' == 1) or (vim.fn.has 'win64' == 1)
      local on_wayland = (vim.env.WAYLAND_DISPLAY ~= nil)
      local on_x11 = (vim.env.DISPLAY ~= nil)

      -- OSC52 copy function
      local function osc52_copy(lines, _)
        osc52.copy(table.concat(lines, '\n'))
      end

      -- Determine paste command based on environment
      local paste_cmd
      if is_win or is_wsl then
        paste_cmd = 'powershell.exe -NoProfile -Command Get-Clipboard'
      elseif on_wayland and vim.fn.executable 'wl-paste' == 1 then
        paste_cmd = 'wl-paste -n'
      elseif on_x11 and vim.fn.executable 'xclip' == 1 then
        paste_cmd = 'xclip -selection clipboard -o'
      else
        paste_cmd = nil -- No system clipboard available
      end

      -- Configure system clipboard integration
      if paste_cmd then
        -- Full clipboard support: OSC52 for copy, system command for paste
        vim.g.clipboard = {
          name = 'osc52+system',
          copy = { ['+'] = osc52_copy, ['*'] = osc52_copy },
          paste = { ['+'] = paste_cmd, ['*'] = paste_cmd },
        }
      else
        -- OSC52-only: can copy to terminal but not paste from system
        vim.g.clipboard = {
          name = 'osc52-only',
          copy = { ['+'] = osc52_copy, ['*'] = osc52_copy },
          paste = { ['+'] = 'printf ""', ['*'] = 'printf ""' }, -- Empty paste as fallback
        }
      end
    end,
  },
}
