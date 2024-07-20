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
