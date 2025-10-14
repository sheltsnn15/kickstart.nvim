-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Neo-tree simplified + safer trash + QoL
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree', silent = true },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    sources = { 'filesystem', 'buffers', 'git_status' },
    default_component_configs = {
      indent = { with_markers = true, indent_size = 2, padding = 1 },
      name = { use_git_status_colors = true },
      git_status = { symbols = { added = 'A', modified = 'M', deleted = 'D', renamed = 'R' } },
      diagnostics = { symbols = { hint = 'H', info = 'I', warn = 'W', error = 'E' } },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = false },
      use_libuv_file_watcher = true,
      group_empty_dirs = true,
      filtered_items = {
        visible = false, -- truly hide; press 'H' to toggle
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        -- Put the unambiguous ones here so they never appear:
        never_show = {
          '.DS_Store',
          'Thumbs.db',
          'desktop.ini',
          '.AppleDouble',
        },
        -- Prefer patterns for the long lists:
        hide_by_pattern = {
          -- Build / deps
          'node_modules',
          'target',
          'build',
          'dist',
          'out',
          '.next',
          '.nuxt',
          '.cache',
          '.parcel-cache',
          '.svelte-kit',
          '.gradle',
          '.cargo',
          '_build',
          'deps',
          'bin',
          'vendor',
          'bower_components',
          '.yarn',
          '.pnpm-store',
          -- Bytecode/object
          '*.o',
          '*.a',
          '*.so',
          '*.class',
          '*.pyc',
          '*.pyo',
          '*.pyd',
          '*.jar',
          '*.war',
          '*.ear',
          '*.tsbuildinfo',
          '*.phar',
          '*.gem',
          -- Temp / backup / logs
          '*.swp',
          '*.bak',
          '*~',
          '*.tmp',
          '*.log',
          'logs',
          -- Media & archives
          '*.mp3',
          '*.mp4',
          '*.jpg',
          '*.jpeg',
          '*.png',
          '*.gif',
          '*.svg',
          '*.ico',
          '*.zip',
          '*.tar.gz',
          '*.rar',
          '*.7z',
          -- IDE
          '.idea',
          '.vscode',
          -- Python caches
          '__pycache__',
          '_pycache_',
          -- Office / docs (your list, moved to patterns)
          '*.doc',
          '*.docx',
          '*.docm',
          '*.dot',
          '*.dotx',
          '*.dotm',
          '*.xls',
          '*.xlsx',
          '*.xlsm',
          '*.xlt',
          '*.xltx',
          '*.xltm',
          '*.xlam',
          '*.ppt',
          '*.pptx',
          '*.pptm',
          '*.pot',
          '*.potx',
          '*.potm',
          '*.pps',
          '*.ppsx',
          '*.ppsm',
          '*.accdb',
          '*.accde',
          '*.accdt',
          '*.accdr',
          '*.pub',
          '*.vsd',
          '*.vsdx',
          '*.mpp',
          '*.mpt',
          '*.one',
          '*.odt',
          '*.ott',
          '*.oth',
          '*.ods',
          '*.ots',
          '*.odp',
          '*.otp',
          '*.odg',
          '*.otg',
          '*.odb',
          '*.odf',
          '*.odm',
          '*.stw',
          '*.pages',
          '*.numbers',
          '*.key',
          '*.wps',
          '*.wpd',
          '*.sxw',
          '*.sxc',
          '*.sxi',
          '*.sxd',
          '*.pdf',
          '*.xps',
          '*.epub',
          '*.mobi',
        },
      },

      -- Cross-platform "trash" wrapper
      commands = (function()
        local function trash_cmd()
          if vim.fn.executable 'trash-put' == 1 then
            return function(p)
              return { 'trash-put', p }
            end
          elseif vim.fn.executable 'gio' == 1 then
            return function(p)
              return { 'gio', 'trash', p }
            end
          elseif vim.fn.executable 'trash' == 1 then -- npm trash-cli
            return function(p)
              return { 'trash', p }
            end
          elseif vim.loop.os_uname().sysname == 'Darwin' then
            -- macOS AppleScript move to Trash
            return function(p)
              return {
                'osascript',
                '-e',
                [[tell application "Finder" to move (POSIX file "]] .. p .. [[") to trash]],
              }
            end
          else
            return nil
          end
        end

        local mktrash = trash_cmd()
        local function do_trash(path)
          local inputs = require 'neo-tree.ui.inputs'
          if not mktrash then
            inputs.confirm("No system 'trash' found. Permanently delete?\n(Install 'trash-put' / 'gio' / 'trash-cli' to use trash.)", function(ok)
              if ok then
                vim.fn.delete(path, 'rf')
              end
            end)
            return
          end
          local cmd = mktrash(vim.fn.fnameescape(path))
          local ok = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify('Trash failed: ' .. ok, vim.log.levels.ERROR)
          end
        end

        return {
          delete = function(state)
            local inputs = require 'neo-tree.ui.inputs'
            local node = state.tree:get_node()
            if not node then
              return
            end
            local path = node.path
            inputs.confirm('Move to trash?\n' .. path, function(yes)
              if not yes then
                return
              end
              do_trash(path)
              require('neo-tree.sources.manager').refresh(state.name)
            end)
          end,

          delete_visual = function(state, selected_nodes)
            local inputs = require 'neo-tree.ui.inputs'
            inputs.confirm('Move ' .. #selected_nodes .. ' items to trash?', function(yes)
              if not yes then
                return
              end
              for _, n in ipairs(selected_nodes) do
                do_trash(n.path)
              end
              require('neo-tree.sources.manager').refresh(state.name)
            end)
          end,
        }
      end)(),

      window = {
        position = 'right',
        width = 34,
        mappings = {
          ['<CR>'] = 'open',
          ['d'] = 'delete',
          ['D'] = 'delete_visual',
          ['R'] = 'refresh',
          ['H'] = 'toggle_hidden',
        },
      },
    },
  },
}
