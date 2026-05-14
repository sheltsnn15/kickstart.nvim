-- Neo-tree simplified + safer trash + QoL
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Neo-tree file explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons')
end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', function()
  require('neo-tree.command').execute {
    toggle = true,
    source = 'filesystem',
    dir = vim.loop.cwd(),
    reveal = true,
  }
end, {
  desc = 'Toggle Neo-tree',
  silent = true,
})

-- safer trash wrapper
local function shorten(p)
  local rp = vim.fn.fnamemodify(p, ':.')
  return vim.fn.fnamemodify(rp, ':~')
end

local function pick_trash()
  if vim.fn.executable 'trash-put' == 1 then
    return function(p)
      return { 'trash-put', p }
    end
  elseif vim.fn.executable 'gio' == 1 then
    return function(p)
      return { 'gio', 'trash', p }
    end
  elseif vim.fn.executable 'trash' == 1 then
    return function(p)
      return { 'trash', p }
    end
  elseif vim.loop.os_uname().sysname == 'Darwin' then
    return function(p)
      return {
        'osascript',
        '-e',
        [[tell application "Finder" to move (POSIX file "]] .. p .. [[") to trash]],
      }
    end
  end
end

local trash_cmd = pick_trash()

local function do_trash(path)
  local inputs = require 'neo-tree.ui.inputs'

  if not trash_cmd then
    inputs.confirm(
      "No system trash utility found. Permanently delete?",
      function(ok)
        if ok then
          vim.fn.delete(path, 'rf')
        end
      end
    )
    return
  end

  local out = vim.fn.system(trash_cmd(path))

  if vim.v.shell_error ~= 0 then
    vim.notify('Trash failed: ' .. tostring(out), vim.log.levels.ERROR)
  end
end

require('neo-tree').setup {
  close_if_last_window = true,

  enable_git_status = true,
  enable_diagnostics = true,

  sources = {
    'filesystem',
    'buffers',
    'git_status',
  },

  open_files_do_not_replace_types = {
    'terminal',
    'Trouble',
    'qf',
    'help',
  },

  sort_case_insensitive = true,
  hijack_netrw_behavior = 'open_current',

  default_component_configs = {
    indent = {
      with_markers = true,
      indent_size = 2,
      padding = 1,
    },

    name = {
      use_git_status_colors = true,
    },

    git_status = {
      symbols = {
        added = 'A',
        modified = 'M',
        deleted = 'D',
        renamed = 'R',
      },
    },

    diagnostics = {
      symbols = {
        hint = 'H',
        info = 'I',
        warn = 'W',
        error = 'E',
      },
    },
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
    bind_to_cwd = true,

    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },

    use_libuv_file_watcher = true,
    group_empty_dirs = true,

    filtered_items = {
      visible = false,

      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,

      never_show = {
        '.DS_Store',
        'Thumbs.db',
        'desktop.ini',
        '.AppleDouble',
      },

      never_show_by_pattern = {
        'node_modules',
        'target',
        'build',
        'dist',
        '.next',
        '.cache',
        '__pycache__',
        '*.pyc',
        '*.o',
        '*.class',
        '*.log',
        '*.tmp',
        '*.swp',
        '*.zip',
        '*.tar.gz',
        '*.jpg',
        '*.png',
        '*.mp4',
        '*.pdf',
      },

      hide_by_pattern = {},
    },

    commands = {
      delete = function(state)
        local inputs = require 'neo-tree.ui.inputs'
        local node = state.tree:get_node()

        if not node then
          return
        end

        local path = node.path

        inputs.confirm('Move to trash? ' .. shorten(path), function(yes)
          if not yes then
            return
          end

          do_trash(path)
          require('neo-tree.sources.manager').refresh(state.name)
        end)
      end,
    },

    window = {
      position = 'right',
      width = 34,

      mappings = {
        ['\\'] = 'close_window',
        ['<CR>'] = 'open',
        ['<space>'] = 'toggle_node',
        ['d'] = 'delete',
        ['R'] = 'refresh',
        ['H'] = 'toggle_hidden',
      },
    },
  },
}
