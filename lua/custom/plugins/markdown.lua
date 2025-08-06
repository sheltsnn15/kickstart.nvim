return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      local use_yarn_or_npm = true
      if use_yarn_or_npm then
        vim.fn.system 'cd app && npm install'
      else
        vim.fn['mkdp#util#install']()
      end
    end,
    init = function()
      vim.g.mkdp_auto_start = false
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_refresh_slow = false
      vim.g.mkdp_command_for_global = false
      vim.g.mkdp_open_to_the_world = false
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = 'google-chrome'
      vim.g.mkdp_echo_preview_url = false
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = false,
        sync_scroll_type = 'middle',
        hide_yaml_meta = true,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = false,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_combine_preview = false
      vim.g.mkdp_combine_preview_auto_refresh = true
      vim.api.nvim_create_autocmd('BufReadPre', {
        pattern = '*.md',
        callback = function()
          local sep = package.config:sub(1, 1)
          local function find_notes_dir(path)
            local parts = {}
            for part in string.gmatch(path, '[^' .. sep .. ']+') do
              table.insert(parts, part)
              if part:lower() == 'notes' then
                break
              end
            end
            return table.concat(parts, sep)
          end

          local current_path = vim.fn.expand '%:p'
          local notes_dir = find_notes_dir(current_path)
          if notes_dir ~= '' then
            local images_path = notes_dir .. sep .. 'assets' .. sep .. 'imgs'
            vim.g.mkdp_images_path = images_path
          end
        end,
      })
    end,
  },
  {
    'toppair/peek.nvim',
    event = { 'VeryLazy' },
    build = 'deno task --quiet build:fast',
    config = function()
      local peek = require 'peek'

      peek.setup {
        auto_load = true,
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,
        app = 'webview',
        filetype = { 'markdown' },
      }

      vim.api.nvim_create_user_command('PeekOpen', function()
        if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown' then
          vim.fn.system 'i3-msg split horizontal'
          peek.open()
        end
      end, {})

      vim.api.nvim_create_user_command('PeekClose', function()
        if peek.is_open() then
          peek.close()
          vim.fn.system 'i3-msg move left'
        end
      end, {})
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ' },
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_prefix = false,
        above = '▄',
        below = '▀',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        disable_background = { 'diff' },
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      dash = {
        enabled = true,
        icon = '─',
        width = 'full',
        highlight = 'RenderMarkdownDash',
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
      },
      checkbox = {
        enabled = true,
        position = 'inline',
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
        },
      },
      latex = {
        enabled = true,
      },
      quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = false,
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        preset = 'none',
        style = 'full',
        cell = 'padded',
        alignment_indicator = '━',
        border = {
          '┌',
          '┬',
          '┐',
          '├',
          '┼',
          '┤',
          '└',
          '┴',
          '┘',
          '│',
          '─',
        },
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
      },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim', 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
      require('render-markdown').setup(opts)
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- Use the latest stable release
    lazy = true,
    ft = { 'markdown' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Optional dependencies for enhanced features:
      'saghen/blink.cmp', -- For completion
      'nvim-telescope/telescope.nvim', -- For search and quick-switch functionality
      'nvim-treesitter/nvim-treesitter', -- For syntax highlighting
    },
    opts = {
      ui = { enable = false },
      workspaces = {
        {
          name = 'dynamic',
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
          overrides = {
            notes_subdir = vim.NIL, -- Avoid creating a 'notes' subdirectory
            new_notes_location = 'current_dir',
            templates = {
              folder = vim.NIL,
            },
            disable_frontmatter = true,
          },
        },
      },
      -- Additional configuration options can be added here
    },
  },
  {
    'kiran94/edit-markdown-table.nvim',
    config = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = 'EditMarkdownTable',
  },
}
