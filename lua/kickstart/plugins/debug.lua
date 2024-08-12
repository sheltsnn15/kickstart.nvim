-- debug.lua
-- Shows how to use the DAP plugin to debug your code.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    {
      'mfussenegger/nvim-dap-python',
      keys = {
        {
          '<leader>dPt',
          function()
            require('dap-python').test_method()
          end,
          desc = 'Debug Method',
          ft = 'python',
        },
        {
          '<leader>dPc',
          function()
            require('dap-python').test_class()
          end,
          desc = 'Debug Class',
          ft = 'python',
        },
      },
      config = function()
        local path = require('mason-registry').get_package('debugpy'):get_install_path()
        require('dap-python').setup(path .. '/venv/bin/python')
      end,
    },
    {
      'leoluz/nvim-dap-go',
      keys = {
        {
          '<leader>dGt',
          function()
            require('dap-go').debug_test()
          end,
          desc = 'Debug Go Test',
          ft = 'go',
        },
      },
      config = function()
        require('dap-go').setup {
          delve = {
            detached = vim.fn.has 'win32' == 0,
          },
        }
      end,
    },
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>',      dap.continue,          desc = 'Debug: Start/Continue' },
      { '<F1>',      dap.step_into,         desc = 'Debug: Step Into' },
      { '<F2>',      dap.step_over,         desc = 'Debug: Step Over' },
      { '<F3>',      dap.step_out,          desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',                -- Go
        'debugpy',              -- Python
        'bash-debug-adapter',   -- Bash
        'chrome-debug-adapter', -- Chrome
        'codelldb',             -- C/C++/Rust
        'bzl',                  -- Bazel (BUILD files)
      },
    }

    -- Dap UI setup
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

    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Configuring additional debuggers

    -- Configuring Bash
    dap.adapters.bash = {
      type = 'executable',
      command = 'bash-debug-adapter',
      name = 'bashdb',
    }
    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = 'Launch file',
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bashdb_dir',
        trace = true,
        file = '${file}',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pathCat = 'cat',
        pathBash = '/bin/bash',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        args = {},
        env = {},
        terminalKind = 'integrated',
      },
    }

    -- Configuring Chrome
    dap.adapters.chrome = {
      type = 'executable',
      command = 'chrome-debug-adapter',
    }
    dap.configurations.javascript = {
      {
        type = 'chrome',
        request = 'launch',
        name = 'Launch Chrome',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
      },
    }

    dap.configurations.typescript = {
      {
        type = 'chrome',
        request = 'launch',
        name = 'Launch Chrome',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
      },
    }

    -- Configuring CodeLLDB
    dap.adapters.lldb = {
      type = 'executable',
      command = 'lldb-vscode',
      name = 'lldb',
    }
    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        runInTerminal = false,
      },
    }

    dap.configurations.cpp = dap.configurations.rust
    dap.configurations.c = dap.configurations.cpp

    -- Configuring Bazel (BUILD files)
    dap.adapters.bzl = {
      type = 'executable',
      command = 'bazel',
      args = { 'run', '@bazel_tools//tools/ide/vim:vim_dap_adapter' },
    }
    dap.configurations.bazel = {
      {
        type = 'bzl',
        request = 'launch',
        name = 'Launch Bazel BUILD file',
        program = '${file}',
      },
    }
  end,
}
