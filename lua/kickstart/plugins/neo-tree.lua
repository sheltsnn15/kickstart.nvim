-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Neo-tree simplified config with trash support

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree', silent = true },
  },
  opts = {
    filesystem = {
      -- hijack_netrw_behavior = 'open_default', -- or "open_current"
      commands = {
        delete = function(state)
          local inputs = require 'neo-tree.ui.inputs'
          local path = state.tree:get_node().path
          local msg = 'Move ' .. path .. ' to trash?'

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            vim.fn.system('trash-put ' .. vim.fn.fnameescape(path))
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,

        delete_visual = function(state, selected_nodes)
          local inputs = require 'neo-tree.ui.inputs'
          local msg = 'Move ' .. #selected_nodes .. ' items to trash?'

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system('trash-put ' .. vim.fn.fnameescape(node.path))
            end
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
      },
      window = {
        position = 'right',
        mappings = {
          ['d'] = 'delete',
        },
      },
    },
  },
}
