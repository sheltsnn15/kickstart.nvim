-- Clipboard suite: Neoclip + OSC52 (hybrid, robust)
return {
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
      { 'kkharji/sqlite.lua', module = 'sqlite' }, -- optional, for persistence
    },
    lazy = true,
    event = 'VeryLazy',
    keys = {
      {
        '<leader>sy',
        function()
          require('telescope').extensions.neoclip.default()
        end,
        desc = '[S]earch [Y]ank history',
      },
      {
        '<leader>sm',
        function()
          require('telescope').extensions.neoclip.macro()
        end,
        desc = '[S]earch [M]acro history',
      },
    },
    config = function()
      local ok_sqlite, _ = pcall(require, 'sqlite')
      local neoclip = require 'neoclip'

      neoclip.setup {
        history = 1000,
        enable_persistent_history = ok_sqlite, -- only if sqlite is present
        db_path = vim.fn.stdpath 'data' .. '/databases/neoclip.sqlite3',
        length_limit = 1024 * 1024, -- 1MB
        continuous_sync = false,
        preview = true,
        default_register = '"',
        default_registers = { '"', '+', '*' },
        enable_macro_history = true,
        filter = function(data)
          -- skip obviously binary-ish blobs (lots of NULs) or very long single lines
          if data.event == 'yank' and type(data.regcontents) == 'table' then
            local s = table.concat(data.regcontents, '\n')
            if #s > 0 and s:find '%z' then
              return false
            end
            if #data.regcontents == 1 and #data.regcontents[1] > 2 * 1024 * 1024 then
              return false
            end
          end
          return true
        end,
        keys = {
          telescope = {
            i = {
              select = '<CR>',
              paste = '<C-p>',
              paste_behind = '<C-k>',
              replay = '<C-q>',
              delete = '<C-d>',
              edit = '<C-e>',
            },
            n = {
              select = '<CR>',
              paste = 'p',
              paste_behind = 'P',
              replay = 'q',
              delete = 'd',
              edit = 'e',
            },
          },
        },
      }

      -- load Telescope extension (after setup)
      pcall(require('telescope').load_extension, 'neoclip')
    end,
  },
  {
    'ojroques/nvim-osc52',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local osc52 = require 'osc52'
      osc52.setup {
        max_length = 0,
        silent = true,
        trim = false,
      }

      -- Env detection
      local is_wsl = (vim.fn.has 'wsl' == 1)
      local is_win = (vim.fn.has 'win32' == 1) or (vim.fn.has 'win64' == 1)
      local tmux = vim.env.TMUX ~= nil
      local ssh = (vim.env.SSH_CONNECTION ~= nil) or (vim.env.SSH_TTY ~= nil)
      local on_way = (vim.env.WAYLAND_DISPLAY ~= nil)
      local on_x11 = (vim.env.DISPLAY ~= nil)

      -- Prefer native copy/paste when “local”; fall back to OSC52 when remote/tmux/SSH.
      local have = function(bin)
        return vim.fn.executable(bin) == 1
      end

      -- Build copy funcs (shell strings or Lua funcs both OK).
      local function sys_copy_cmd()
        if is_win or is_wsl then
          -- Prefer win32yank if available (handles newlines/encoding nicely)
          if have 'win32yank.exe' then
            return { ['+'] = 'win32yank.exe -i --crlf', ['*'] = 'win32yank.exe -i --crlf' }
          end
          -- Fallback to clip.exe (WSL has it via /mnt/c/Windows/System32/clip.exe)
          return { ['+'] = 'clip.exe', ['*'] = 'clip.exe' }
        elseif on_way and have 'wl-copy' then
          return { ['+'] = 'wl-copy', ['*'] = 'wl-copy' }
        elseif on_x11 and have 'xclip' then
          return { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection primary' }
        elseif on_x11 and have 'xsel' then
          return { ['+'] = 'xsel --clipboard --input', ['*'] = 'xsel --primary --input' }
        end
      end

      local function sys_paste_func()
        if is_win or is_wsl then
          if have 'win32yank.exe' then
            return function()
              return vim.fn.systemlist 'win32yank.exe -o --lf'
            end
          end
          return function()
            return vim.fn.systemlist 'powershell.exe -NoProfile -Command Get-Clipboard'
          end
        elseif on_way and have 'wl-paste' then
          return function()
            return vim.fn.systemlist 'wl-paste -n'
          end
        elseif on_x11 and have 'xclip' then
          return function()
            return vim.fn.systemlist 'xclip -selection clipboard -o'
          end
        elseif on_x11 and have 'xsel' then
          return function()
            return vim.fn.systemlist 'xsel --clipboard --output'
          end
        end
      end

      -- Decide provider:
      local prefer_osc52 = tmux or ssh
      local sys_copy = sys_copy_cmd()
      local sys_paste = sys_paste_func()

      if not prefer_osc52 and sys_copy and sys_paste then
        -- Local session with proper tools: use system for both; keep OSC52 as a helper (see yank autocmd below)
        vim.g.clipboard = {
          name = 'system-clipboard',
          copy = sys_copy,
          paste = { ['+'] = sys_paste, ['*'] = sys_paste },
        }
      else
        -- Remote/tmux or no system tools: use OSC52 for copy, best-effort paste
        local function osc52_copy(lines, _)
          osc52.copy(table.concat(lines, '\n'))
        end
        local paste = sys_paste or function()
          return { '' }
        end -- OSC52 can’t paste; try system, else empty
        vim.g.clipboard = {
          name = 'osc52-hybrid',
          copy = { ['+'] = osc52_copy, ['*'] = osc52_copy },
          paste = { ['+'] = paste, ['*'] = paste },
        }
      end

      -- QoL: when copying locally with system tools, still emit OSC52 in tmux/SSH
      -- so your terminal’s clipboard gets it too (harmless when local).
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('ClipboardOSC52', { clear = true }),
        callback = function()
          if vim.v.event.operator == 'y' then
            -- Only mirror unnamed register yanks; respect explicit +/* when user wants that
            local reg = (vim.v.event.regname == '' or vim.v.event.regname == '"') and '"' or nil
            if reg then
              pcall(osc52.copy_register, reg)
            end
          end
        end,
      })

      -- Small helper to see what’s active
      vim.api.nvim_create_user_command('ClipboardProvider', function()
        local name = (vim.g.clipboard and vim.g.clipboard.name) or 'builtin'
        vim.notify('Clipboard provider: ' .. name)
      end, {})
    end,
  },
}
