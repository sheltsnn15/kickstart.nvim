-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- Core debugging plugin
  'mfussenegger/nvim-dap',

  -- Dependencies
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific debuggers
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'mxsdev/nvim-dap-vscode-js',
    'microsoft/vscode-js-debug',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'

    -- Helper: try mason-registry, fall back to stdpath
    local function mason_path(pkg_name, rel)
      local ok_mason, registry = pcall(require, 'mason-registry')
      if ok_mason then
        local ok_pkg, pkg = pcall(registry.get_package, pkg_name)
        if ok_pkg and pkg and type(pkg) == 'table' and pkg.get_install_path then
          local root = pkg:get_install_path()
          return rel and (root .. rel) or root
        end
      end
      -- fallback to the conventional Mason install dir
      local root = vim.fn.stdpath 'data' .. '/mason/packages/' .. pkg_name
      return rel and (root .. rel) or root
    end

    -- Optional external terminal
    dap.defaults.fallback.external_terminal = { command = 'xterm', args = { '-e' } }

    -- ===== codelldb =====
    do
      local adapter = mason_path('codelldb', '/extension/adapter/codelldb')
      if vim.loop.fs_stat(adapter) then
        dap.adapters.codelldb = {
          type = 'server',
          host = '127.0.0.1',
          port = '${port}',
          executable = { command = adapter, args = { '--port', '${port}' } },
        }
      else
        -- final fallback: rely on PATH
        dap.adapters.codelldb = {
          type = 'server',
          host = '127.0.0.1',
          port = '${port}',
          executable = { command = 'codelldb', args = { '--port', '${port}' } },
        }
      end
    end

    -- ===== js-debug (pwa-node / pwa-chrome) =====
    do
      local server_js = mason_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js')
      if vim.loop.fs_stat(server_js) then
        dap.adapters['pwa-node'] = {
          type = 'server',
          host = '127.0.0.1',
          port = '${port}',
          executable = { command = 'node', args = { server_js, '${port}' } },
        }
        dap.adapters['pwa-chrome'] = dap.adapters['pwa-node']
      else
        -- final fallback: conventional stdpath
        local default_js = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'
        dap.adapters['pwa-node'] = {
          type = 'server',
          host = '127.0.0.1',
          port = '${port}',
          executable = { command = 'node', args = { default_js, '${port}' } },
        }
        dap.adapters['pwa-chrome'] = dap.adapters['pwa-node']
      end
    end

    -- Load .vscode/launch.json if present
    pcall(function()
      require('dap.ext.vscode').load_launchjs(nil, {
        ['pwa-node'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        ['node'] = { 'typescript', 'javascript' },
        ['lldb'] = { 'c', 'cpp', 'rust' },
        ['codelldb'] = { 'c', 'cpp', 'rust' },
        ['python'] = { 'python' },
        ['go'] = { 'go' },
      })
    end)

    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Go
        'debugpy', -- Python
        'bash-debug-adapter', -- Bash
        'js-debug-adapter', -- Javascript
        'codelldb', -- C/C++/Rust
        'bzl', -- Bazel (BUILD files)
      },
    }

    -- DAP UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- Auto-open/close UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- === MUST-DO: Python uses your project venv automatically ===
    local function find_python()
      local v = os.getenv 'VIRTUAL_ENV' or vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
      if v and v ~= '' then
        local py = v .. (v:sub(-1) == '/' and '' or '/') .. 'bin/python'
        if vim.loop.fs_stat(py) then
          return py
        end
      end
      return 'python'
    end
    require('dap-python').setup(find_python())

    -- === MUST-DO: Go DAP ===
    require('dap-go').setup {
      delve = { initialize_timeout_sec = 20 },
    }

    -- === C/C++/Rust configurations (use codelldb adapter defined above) ===
    for _, lang in ipairs { 'c', 'cpp', 'rust' } do
      dap.configurations[lang] = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
    end

    -- === JavaScript / TypeScript / React / Next.js ===
    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Run Node File',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Node (inspect)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Debug CRA/Vite App',
          url = 'http://localhost:3001',
          webRoot = '${workspaceFolder}/src',
          userDataDir = vim.fn.stdpath 'data' .. '/chrome-user-data',
          skipFiles = { '**/node_modules/**', '**/@vite/**', '**/src/client/**' },
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach to Chrome',
          port = 9222,
          webRoot = '${workspaceFolder}/src',
        },
      }
    end
  end,
}
