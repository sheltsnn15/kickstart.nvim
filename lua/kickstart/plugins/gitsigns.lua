-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.
-- Git signs / hunks
-- https://github.com/lewis6991/gitsigns.nvim

vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
}

require('gitsigns').setup {
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
    end, { desc = 'Jump to previous git change' })

    -- visual mode
    map('v', '<leader>gss', function()
      gitsigns.stage_hunk {
        vim.fn.line '.',
        vim.fn.line 'v',
      }
    end, 'Git stage hunk')

    map('v', '<leader>gsr', function()
      gitsigns.reset_hunk {
        vim.fn.line '.',
        vim.fn.line 'v',
      }
    end, 'Git reset hunk')

    -- actions
    map('n', '<leader>gss', gitsigns.stage_hunk, 'Git [s]tage hunk')
    map('n', '<leader>gsr', gitsigns.reset_hunk, 'Git [r]eset hunk')
    map('n', '<leader>gsS', gitsigns.stage_buffer, 'Git [S]tage buffer')
    map('n', '<leader>gsu', gitsigns.undo_stage_hunk, 'Git [u]ndo stage hunk')
    map('n', '<leader>gsR', gitsigns.reset_buffer, 'Git [R]eset buffer')

    map('n', '<leader>gsp', gitsigns.preview_hunk, 'Git [preview hunk')
    map('n', '<leader>gsi', gitsigns.preview_hunk_inline, 'Git preview hunk inline')

    map('n', '<leader>gsb', function()
      gitsigns.blame_line { full = true }
    end, 'Git blame line')

    map('n', '<leader>gsd', gitsigns.diffthis, 'Git diff against index')

    map('n', '<leader>gsD', function()
      gitsigns.diffthis '@'
    end, 'Git [D]iff against last commit')

    map('n', '<leader>gsq', gitsigns.setqflist, 'git hunk [q]uickfix list (all changes in this file)')

    map('n', '<leader>gsQ', function()
      gitsigns.setqflist 'all'
    end, 'git hunk [Q]uickfix list (all files in repo)')

    -- toggles
    map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, '[T]oggle git show [b]lame line')
    map('n', '<leader>gtw', gitsigns.toggle_word_diff, '[T]oggle git intra-line [w]ord diff')

    -- text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select [h]unk')
  end,
}
