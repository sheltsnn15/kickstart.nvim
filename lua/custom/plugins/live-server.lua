-- ============================================================
-- Live Server
-- Simple local development server for HTML/CSS/JS projects
-- ============================================================

vim.pack.add {
  'https://forgejo.mueller.network/mirror/live-server.nvim',
}

vim.g.live_server = {
  -- Use a floating terminal window instead of a split
  custom = {
    '--port=8080',
  },

  serverPath = vim.fn.stdpath('data')
    .. '/site/pack/core/opt/live-server.nvim/node_modules/.bin/live-server',
}

-- Install live-server globally:
-- npm install -g live-server

-- Available commands:
-- :LiveServerStart
-- :LiveServerStop
