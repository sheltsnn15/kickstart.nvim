return {
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
}
