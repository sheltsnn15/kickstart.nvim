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
    vim.g.mkdp_browser = 'chromium'
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
    vim.g.mkdp_images_path = 'assets/imgs'
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_combine_preview = false
    vim.g.mkdp_combine_preview_auto_refresh = true
  end,
}
