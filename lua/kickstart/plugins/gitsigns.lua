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
    end, { desc = 'Jump to previous git [c]hange' })

    -- Visual mode actions
    map('v', '<leader>gss', function()
      gitsigns.stage_hunk {
        vim.fn.line '.',
        vim.fn.line 'v',
      }
    end, { desc = 'Git [s]tage hunk' })

    map('v', '<leader>gsr', function()
      gitsigns.reset_hunk {
        vim.fn.line '.',
        vim.fn.line 'v',
      }
    end, { desc = 'Git [r]eset hunk' })

    -- Normal mode actions
    map('n', '<leader>gss', gitsigns.stage_hunk, {
      desc = 'Git [s]tage hunk',
    })

    map('n', '<leader>gsr', gitsigns.reset_hunk, {
      desc = 'Git [r]eset hunk',
    })

    map('n', '<leader>gsS', gitsigns.stage_buffer, {
      desc = 'Git [S]tage buffer',
    })

    map('n', '<leader>gsu', gitsigns.undo_stage_hunk, {
      desc = 'Git [u]ndo stage hunk',
    })

    map('n', '<leader>gsR', gitsigns.reset_buffer, {
      desc = 'Git [R]eset buffer',
    })

    map('n', '<leader>gsp', gitsigns.preview_hunk, {
      desc = 'Git [p]review hunk',
    })

    map('n', '<leader>gsi', gitsigns.preview_hunk_inline, {
      desc = 'Git preview hunk [i]nline',
    })

    map('n', '<leader>gsb', function()
      gitsigns.blame_line { full = true }
    end, {
      desc = 'Git [b]lame line',
    })

    map('n', '<leader>gsd', gitsigns.diffthis, {
      desc = 'Git [d]iff against index',
    })

    map('n', '<leader>gsD', function()
      gitsigns.diffthis '@'
    end, {
      desc = 'Git [D]iff against last commit',
    })

    map('n', '<leader>gsq', gitsigns.setqflist, {
      desc = 'Git hunk [q]uickfix list (all changes in this file)',
    })

    map('n', '<leader>gsQ', function()
      gitsigns.setqflist 'all'
    end, {
      desc = 'Git hunk [Q]uickfix list (all files in repo)',
    })

    -- Toggles
    map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, {
      desc = '[T]oggle git show [b]lame line',
    })

    map('n', '<leader>gtw', gitsigns.toggle_word_diff, {
      desc = '[T]oggle git intra-line [w]ord diff',
    })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, {
      desc = 'Select [h]unk',
    })
  end,
}
