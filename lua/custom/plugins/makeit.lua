return {
  {
    'Civitasv/cmake-tools.nvim',
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          require('lazy').load { plugins = { 'cmake-tools.nvim' } }
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
  { -- This plugin
    'Zeioth/makeit.nvim',
    cmd = { 'MakeitOpen', 'MakeitToggleResults', 'MakeitRedo' },
    dependencies = { 'stevearc/overseer.nvim' },
    opts = {},
  },
  { -- The task runner we use
    'stevearc/overseer.nvim',
    commit = '400e762648b70397d0d315e5acaf0ff3597f2d8b',
    cmd = { 'MakeitOpen', 'MakeitToggleResults', 'MakeitRedo' },
    opts = {
      task_list = {
        direction = 'bottom',
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
