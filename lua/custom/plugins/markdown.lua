return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      -- Conditionally choose build command
      -- Assuming some logic or condition to choose between yarn/npm and the default install
      local use_yarn_or_npm = true -- Example condition, adjust according to your needs
      if use_yarn_or_npm then
        vim.fn.system 'cd app && npm install' -- Or replace with the equivalent Lua vim.cmd call
      else
        vim.fn['mkdp#util#install']()
      end
    end,
    init = function()
      -- General settings, using true or false for boolean values
      vim.g.mkdp_auto_start = false
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_refresh_slow = false
      vim.g.mkdp_command_for_global = false
      vim.g.mkdp_open_to_the_world = false
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = 'firefox'
      vim.g.mkdp_echo_preview_url = false
      vim.g.mkdp_browserfunc = ''

      -- Preview options, corrected boolean values
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

      -- Style configurations
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_combine_preview = false
      vim.g.mkdp_combine_preview_auto_refresh = true
      -- Dynamic image path setup
      vim.api.nvim_create_autocmd('BufReadPre', {
        pattern = '*.md',
        callback = function()
          -- Define 'sep' in the outer scope so it can be used throughout the callback
          local sep = package.config:sub(1, 1) -- System's file separator (e.g., '/' for Unix)

          -- Function to find the "notes" directory from the current file path
          local function find_notes_dir(path)
            local parts = {}
            for part in string.gmatch(path, '[^' .. sep .. ']+') do
              table.insert(parts, part)
              if part == 'Notes' then
                print("Found 'notes' directory in path: " .. table.concat(parts, sep)) -- Debug print
                break
              end
            end
            return table.concat(parts, sep)
          end

          local current_path = vim.fn.expand '%:p' -- Get the full path of the current file
          local notes_dir = find_notes_dir(current_path)
          if notes_dir ~= '' then
            local images_path = notes_dir .. sep .. 'assets' .. sep .. 'imgs'
            vim.g.mkdp_images_path = images_path
          end
        end,
      })
    end,
  },
  -- Install the markdown-toc.nvim plugin
  {
    'hedyhli/markdown-toc.nvim',
    ft = 'markdown', -- Lazy load on markdown filetype
    cmd = { 'Mtoc' }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Enable auto-update of the ToC on buffer save
      auto_update = {
        enabled = true,
        events = { 'BufWritePre' },
        pattern = '*.{md,mdown,mkd,mkdn,markdown,mdwn}',
      },
      -- Headings configuration
      headings = {
        before_toc = false, -- Do not include headings before the ToC
        exclude = { 'CHANGELOG', 'License' }, -- Exclude specific headings
      },
      -- ToC list configuration
      toc_list = {
        markers = '*', -- Use '*' for list items
        cycle_markers = false, -- Disable marker cycling
        indent_size = function()
          return vim.bo.shiftwidth -- Set indent size based on shiftwidth
        end,
        item_format_string = '${indent}${marker} [${name}](#${link})', -- Format for ToC items
        item_formatter = function(item, fmtstr)
          -- Customize the link format
          local s = fmtstr:gsub([[${(%w-)}]], function(key)
            return item[key] or ('${' .. key .. '}')
          end)
          return s
        end,
      },
      -- Fences configuration
      fences = {
        enabled = true, -- Enable fences
        start_text = 'mtoc-start', -- Start text for fences
        end_text = 'mtoc-end', -- End text for fences
      },
    },
    config = function(_, opts)
      -- Setup the plugin with the given options
      require('mtoc').setup(opts)
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- Use latest release
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Completion
      'hrsh7th/nvim-cmp',
      -- Pickers
      'nvim-telescope/telescope.nvim',
      -- Syntax highlighting
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      workspaces = {
        {
          name = 'ESSH',
          path = '~/winhome/Documents/Project/ESSH/notes/',
        },
        {
          name = 'AQMS',
          path = '~/winhome/Documents/Project/AQMS/notes/',
        },
        {
          name = 'My Notes',
          path = '~/winhome/Documents/Megasync/My Stuff/Obsidian_Notes/',
        },
      },
      notes_subdir = 'notes',
      log_level = vim.log.levels.INFO,
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ['<leader>ch'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
      new_notes_location = 'notes_subdir',
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
      preferred_link_style = 'wiki',
      picker = {
        name = 'telescope.nvim',
        mappings = {
          new = '<C-x>',
          insert_link = '<C-l>',
        },
      },
      sort_by = 'modified',
      sort_reversed = true,
      open_notes_in = 'current',
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
          ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
          ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        },
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
        external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
        block_ids = { hl_group = 'ObsidianBlockID' },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = '#f78c6c' },
          ObsidianDone = { bold = true, fg = '#89ddff' },
          ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
          ObsidianTilde = { bold = true, fg = '#ff5370' },
          ObsidianBullet = { bold = true, fg = '#89ddff' },
          ObsidianRefText = { underline = true, fg = '#c792ea' },
          ObsidianExtLinkIcon = { fg = '#c792ea' },
          ObsidianTag = { italic = true, fg = '#89ddff' },
          ObsidianBlockID = { italic = true, fg = '#89ddff' },
          ObsidianHighlightText = { bg = '#75662e' },
        },
      },
      attachments = {
        img_folder = 'assets/imgs',
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            link_path = vault_relative_path
          else
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format('![%s](%s)', display_name, link_path)
        end,
      },
    },
  },
  {
    'lukas-reineke/headlines.nvim',
    opts = function()
      local opts = {}
      for _, ft in ipairs { 'markdown', 'norg', 'rmd', 'org' } do
        opts[ft] = {
          headline_highlights = {},
          -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
          bullets = {},
        }
        for i = 1, 6 do
          local hl = 'Headline' .. i
          vim.api.nvim_set_hl(0, hl, { link = 'Headline', default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    config = function(_, opts)
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require('headlines').setup(opts)
        require('headlines').refresh()
      end)
    end,
  },
}
