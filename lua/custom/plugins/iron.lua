-- iron_config.lua
return {
  {
    'Vigemus/iron.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local iron = require 'iron.core'
      local Job = require 'plenary.job'

      iron.setup {
        config = {
          repl_definition = {
            python = {
              command = { 'python3' },
            },
            micropython = {
              command = { 'mpfshell', '--repl' },
            },
            pio = {
              command = { 'pio', 'device', 'monitor' },
            },
          },
          preferred = {
            python = 'micropython',
            c = 'pio',
          },
          highlight = {
            italic = true,
          },
          ignore_blank_lines = true,
        },
      }

      -- Custom function to start the MicroPython REPL
      local function start_micropython_repl()
        iron.core.send_to_repl 'micropython'
      end

      -- Custom function to start the PlatformIO REPL
      local function start_pio_repl()
        iron.core.send_to_repl 'pio'
      end

      -- Custom function to send the current file to the REPL
      local function send_file_to_repl()
        local buf = vim.api.nvim_get_current_buf()
        local file_path = vim.api.nvim_buf_get_name(buf)
        iron.core.send_file(file_path)
      end

      -- Custom function to send the current line to the REPL
      local function send_line_to_repl()
        local line = vim.api.nvim_get_current_line()
        iron.core.send_line(line)
      end

      -- Custom function to send selected lines to the REPL
      local function send_visual_selection_to_repl()
        local start_line = vim.fn.line 'v'
        local end_line = vim.fn.line '.'
        iron.core.send_lines(start_line, end_line)
      end

      -- Custom function to build with PlatformIO
      local function platformio_build()
        Job:new({
          command = 'pio',
          args = { 'run' },
          on_exit = function(_, return_val)
            if return_val == 0 then
              vim.notify 'Build succeeded'
            else
              vim.notify('Build failed.', vim.log.levels.ERROR)
            end
          end,
        }):start()
      end

      -- Custom function to upload with PlatformIO
      local function platformio_upload()
        Job:new({
          command = 'pio',
          args = { 'run', '--target', 'upload' },
          on_exit = function(_, return_val)
            if return_val == 0 then
              vim.notify 'Upload succeeded'
            else
              vim.notify('Upload failed.', vim.log.levels.ERROR)
            end
          end,
        }):start()
      end

      -- Custom function to start the PlatformIO monitor
      local function platformio_monitor()
        Job:new({
          command = 'pio',
          args = { 'device', 'monitor' },
        }):start()
      end

      -- Keybindings for the custom functions
      vim.keymap.set('n', '<leader>im', ':lua start_micropython_repl()<CR>', { desc = 'Start [M]icroPython REPL' })
      vim.keymap.set('n', '<leader>ip', ':lua start_pio_repl()<CR>', { desc = 'Start [P]latformIO REPL' })
      vim.keymap.set('n', '<leader>if', ':lua send_file_to_repl()<CR>', { desc = 'Send Current [F]ile to REPL' })
      vim.keymap.set('n', '<leader>il', ':lua send_line_to_repl()<CR>', { desc = 'Send Current [L]ine to REPL' })
      vim.keymap.set('v', '<leader>iv', ':lua send_visual_selection_to_repl()<CR>', { desc = 'Send [V]isual Selection to REPL' })
      vim.keymap.set('n', '<leader>pb', ':lua platformio_build()<CR>', { desc = '[B]uild with PlatformIO' })
      vim.keymap.set('n', '<leader>pu', ':lua platformio_upload()<CR>', { desc = '[U]pload with PlatformIO' })
      vim.keymap.set('n', '<leader>pm', ':lua platformio_monitor()<CR>', { desc = '[M]onitor with PlatformIO' })
    end,
  },
}
