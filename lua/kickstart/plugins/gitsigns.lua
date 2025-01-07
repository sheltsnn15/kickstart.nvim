-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- Visual mode
        map('v', '<leader>gss', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [S]tage Git hunk' })
        map('v', '<leader>gsr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [R]eset Git hunk' })

        -- Normal mode
        map('n', '<leader>gss', gitsigns.stage_hunk, { desc = 'Git [S]tage hunk' })
        map('n', '<leader>gsr', gitsigns.reset_hunk, { desc = 'Git [R]eset hunk' })
        map('n', '<leader>gsS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
        map('n', '<leader>gsu', gitsigns.undo_stage_hunk, { desc = 'Git [U]ndo stage hunk' })
        map('n', '<leader>gsR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
        map('n', '<leader>gsp', gitsigns.preview_hunk, { desc = 'Git [P]review hunk' })
        map('n', '<leader>gsb', gitsigns.blame_line, { desc = 'Git [B]lame line' })
        map('n', '<leader>gsd', gitsigns.diffthis, { desc = 'Git [D]iff against index' })
        map('n', '<leader>gsD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Git [D]iff against last commit' })

        -- Toggles
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
