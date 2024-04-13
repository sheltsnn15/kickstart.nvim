return {
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
        name = 'Year4',
        path = '/home/shelton/Documents/MTU/Year4/Notes',
      },
      {
        name = 'My Notes',
        path = '/home/shelton/Documents/Syncthing/Obsidian Notes/',
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
}
