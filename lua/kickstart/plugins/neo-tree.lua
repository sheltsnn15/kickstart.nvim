-- Neo-tree file explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range '*',
  },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.pack.add(plugins)

vim.keymap.set('n', '\\', function()
  require('neo-tree.command').execute {
    toggle = true,
    source = 'filesystem',
    dir = vim.uv.cwd(),
    reveal = true,
  }
end, {
  desc = 'Toggle Neo-tree',
  silent = true,
})

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
    'trouble',
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
        require('neo-tree.command').execute {
          action = 'close',
        }
      end,
    },
  },

  -- Neo-tree's built-in trash command uses the appropriate
  -- system mechanism. On Windows this uses PowerShell/Recycle Bin.
  trash = {
    command = nil,
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

    window = {
      position = 'right',
      width = 34,

      mappings = {
        ['\\'] = 'close_window',
        ['<CR>'] = 'open',
        ['<space>'] = 'toggle_node',

        -- d = move to Windows Recycle Bin / system trash
        ['d'] = 'trash',

        -- undo the most recent trash operation
        ['u'] = 'undo',

        -- restore an item from the trash when supported
        ['U'] = 'restore_from_trash',

        ['R'] = 'refresh',
        ['H'] = 'toggle_hidden',
      },
    },
  },
}
