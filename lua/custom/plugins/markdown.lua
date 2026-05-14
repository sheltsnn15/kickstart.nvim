-- ============================================================
-- Markdown Preview
-- Browser-based Markdown preview with live reload
-- ============================================================

vim.pack.add {
  'https://github.com/iamcco/markdown-preview.nvim',
}

-- Install preview dependencies manually:
-- cd ~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app
-- npm install

vim.g.mkdp_auto_start = false
vim.g.mkdp_auto_close = true
vim.g.mkdp_theme = 'dark'
vim.g.mkdp_browser = '/usr/bin/firefox'

-- Configure image path support for notes directories
vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*.md',

  callback = function()
    local sep = package.config:sub(1, 1)

    local function find_notes_dir(path)
      local parts = {}

      for part in string.gmatch(path, '[^' .. sep .. ']+') do
        table.insert(parts, part)

        if part:lower() == 'notes' then break end
      end

      return table.concat(parts, sep)
    end

    local current_path = vim.fn.expand '%:p'
    local notes_dir = find_notes_dir(current_path)

    if notes_dir ~= '' then vim.g.mkdp_images_path = notes_dir .. sep .. 'assets' .. sep .. 'imgs' end
  end,
})

-- ============================================================
-- Markdown Rendering
-- Better in-buffer Markdown rendering and styling
-- ============================================================

vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {
  heading = {
    enabled = true,
    sign = true,
    position = 'overlay',

    icons = {
      '󰲡 ',
      '󰲣 ',
      '󰲥 ',
      '󰲧 ',
      '󰲩 ',
      '󰲫 ',
    },

    width = 'full',
  },

  code = {
    enabled = true,
    style = 'full',
    border = 'thin',
  },

  bullet = {
    enabled = true,

    icons = {
      '●',
      '○',
      '◆',
      '◇',
    },
  },

  checkbox = {
    enabled = true,

    unchecked = {
      icon = '󰄱 ',
    },

    checked = {
      icon = '󰱒 ',
    },
  },

  quote = {
    enabled = true,
    icon = '▋',
  },

  pipe_table = {
    enabled = true,
    preset = 'none',
    style = 'full',
  },

  latex = {
    enabled = true,
  },
}

-- ============================================================
-- Obsidian
-- Markdown knowledge base and note management
-- ============================================================

vim.pack.add {
  'https://github.com/epwalsh/obsidian.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

require('obsidian').setup {
  ui = {
    enable = false,
  },

  workspaces = {
    {
      name = 'dynamic',

      path = function() return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) end,

      overrides = {
        -- Do not force a notes/ directory structure
        notes_subdir = vim.NIL,

        -- Create notes beside the current file
        new_notes_location = 'current_dir',

        -- Disable templates
        templates = {
          folder = vim.NIL,
        },

        -- Keep markdown files clean
        disable_frontmatter = true,
      },
    },
  },
}
