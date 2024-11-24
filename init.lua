if vim.g.vscode then
  -- VSCode extension
  local api = require 'vscode.api'

  local default_optons = require 'vscode.default-options'
  local force_options = require 'vscode.force-options'
  local sync_options = require 'vscode.sync-options'
  local cursor = require 'vscode.cursor'
  local highlight = require 'vscode.highlight'
  local viewport = require 'vscode.viewport'

  default_optons.setup()
  force_options.setup()
  sync_options.setup()
  cursor.setup()
  highlight.setup()
  viewport.setup()

  local vscode = {
    -- actions
    action = api.action,
    call = api.call,
    eval = api.eval,
    eval_async = api.eval_async,
    -- hooks
    on = api.on,
    -- vscode settings
    has_config = api.has_config,
    get_config = api.get_config,
    update_config = api.update_config,
    -- notifications
    notify = api.notify,
    -- operatorfunc helper
    to_op = api.to_op,
    -- utilities
    with_insert = api.with_insert,
  }

  -- Clear search highlights in VSCode using Neovim's command
  vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

  -- Disable arrow keys in VSCode
  vim.keymap.set('n', '<left>', '<Cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<Cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<Cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<Cmd>echo "Use j to move!!"<CR>')

  -- VSCode-specific window focus (use VSCode window controls)
  vim.keymap.set('n', '<C-h>', '<Cmd>call VSCodeNotify("workbench.action.focusLeftGroup")<CR>', { desc = 'Focus left window' })
  vim.keymap.set('n', '<C-l>', '<Cmd>call VSCodeNotify("workbench.action.focusRightGroup")<CR>', { desc = 'Focus right window' })
  vim.keymap.set('n', '<C-j>', '<Cmd>call VSCodeNotify("workbench.action.focusBelowGroup")<CR>', { desc = 'Focus below window' })
  vim.keymap.set('n', '<C-k>', '<Cmd>call VSCodeNotify("workbench.action.focusAboveGroup")<CR>', { desc = 'Focus above window' })

  -- Use VSCode's quick open, buffer explorer, and search
  vim.keymap.set('n', '<leader>ff', '<Cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', { desc = '[F]ind [F]ile' })
  vim.keymap.set('n', '<leader>fb', '<Cmd>call VSCodeNotify("workbench.action.showAllEditors")<CR>', { desc = '[F]ind [B]uffer' })
  vim.keymap.set('n', '<leader>sg', '<Cmd>call VSCodeNotify("workbench.action.findInFiles")<CR>', { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sh', '<Cmd>call VSCodeNotify("workbench.action.showCommands")<CR>', { desc = '[S]earch [H]elp' })

  -- Use VSCode LSP for common language actions
  vim.keymap.set('n', 'gd', '<Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>', { desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', '<Cmd>call VSCodeNotify("references-view.findReferences")<CR>', { desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', '<leader>rn', '<Cmd>call VSCodeNotify("editor.action.rename")<CR>', { desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', '<Cmd>call VSCodeNotify("editor.action.quickFix")<CR>', { desc = '[C]ode [A]ction' })

  -- Yank to clipboard using VSCode's internal clipboard
  vim.keymap.set({ 'n', 'v' }, '<leader>y', '<Cmd>call VSCodeNotify("editor.action.clipboardCopyAction")<CR>', { desc = '[Y]ank to clipboard' })

  -- Use VSCode's command for making a file executable
  vim.keymap.set('n', '<leader>dx', '<Cmd>call VSCodeNotify("workbench.action.terminal.runActiveFile")<CR>', { desc = '[X] Make file executable' })

  -- Backward compatibility
  package.loaded['vscode-neovim'] = vscode

  return setmetatable(vscode, {
    __index = function(_, key)
      local msg = ([[The "vscode.%s" is missing. If you have a Lua module named "vscode", please rename it.]]):format(key)
      vscode.notify(msg, vim.log.levels.ERROR)
      return setmetatable({}, { __call = function() end })
    end,
  })
else
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = false

  -- [[ Setting options ]]
  -- See `:help vim.opt`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.opt.number = true

  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  vim.opt.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.opt.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.opt.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  -- vim.opt.clipboard = 'unnamedplus'

  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'yes'

  -- Decrease update time
  vim.opt.updatetime = 250

  -- Decrease mapped sequence wait time
  -- Displays which-key popup sooner
  vim.opt.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'

  -- Show which line your cursor is on
  vim.opt.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 10

  -- Set the width of a tab character to 4 spaces
  vim.opt.tabstop = 4

  -- Set the width of an indentation level to 4 spaces when using the '>>' and '<<' commands
  vim.opt.softtabstop = 4

  -- Set the number of spaces inserted for each indentation level
  vim.opt.shiftwidth = 4

  -- Convert tabs to spaces
  vim.opt.expandtab = true

  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.highlight.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- [[ Install `lazy.nvim` plugin manager ]]
  --    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
      error('Error cloning lazy.nvim:\n' .. out)
    end
  end ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)

  -- [[ Configure and install plugins ]]
  --
  --  To check the current status of your plugins, run
  --    :Lazy
  --
  --  You can press `?` in this menu for help. Use `:q` to close the window
  --
  --  To update plugins you can run
  --    :Lazy update
  --
  -- NOTE: Here is where you install your plugins.
  require('lazy').setup({
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to force a plugin to be loaded.
    --

    -- Here is a more advanced example where we pass configuration
    -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
    --    require('gitsigns').setup({ ... })
    --
    -- See `:help gitsigns` to understand what the configuration keys do
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    --
    -- which loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `config` key, the configuration only runs
    -- after the plugin has been loaded:
    --  config = function() ... end

    { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      opts = {
        icons = {
          -- set icon mappings to true if you have a Nerd Font
          mappings = vim.g.have_nerd_font,
          -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
          -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
          keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
          },
        },

        -- Document existing key chains
        spec = {
          { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle', mode = { 'n' } },
          { '<leader>r', group = '[R]efactor', mode = { 'n', 'v' } },
          { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
          { '<leader>j', group = '[J]upyter', mode = { 'n' } },
          { '<leader>m', group = 'Vi[m]ux/Test', mode = { 'n' } },
        },
      },
    },

    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    { -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
          -- You can put your default mappings / updates / etc. in here
          --  All the info you're looking for is in `:help telescope.setup()`
          --
          -- defaults = {
          --   mappings = {
          --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          --   },
          -- },
          -- pickers = {}
          defaults = { file_ignore_patterns = { 'node_modules', '__pycache__', '%.png', '%.jpeg', '%.pdf' } },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
            ['ast_grep'] = {
              command = {
                'sg',
                '--json=stream',
              }, -- must have --json=stream
              grep_open_files = false, -- search in opened files
              lang = nil, -- string value, specify language for ast-grep `nil` for default
            },
          },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },

    -- LSP Plugins
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
      -- Main LSP Configuration
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },

        -- Allows extra capabilities provided by nvim-cmp
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            -- NOTE: Remember that Lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            -- Find references for the word under your cursor.
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })

        -- Change diagnostic symbols in the sign column (gutter)
        if vim.g.have_nerd_font then
          local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
          local diagnostic_signs = {}
          for type, icon in pairs(signs) do
            diagnostic_signs[vim.diagnostic.severity[type]] = icon
          end
          vim.diagnostic.config { signs = { text = diagnostic_signs } }
        end

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

        --- Disables formatting capabilities for an LSP client.
        ---
        --- This function can be used to prevent specific LSP servers from handling
        --- document formatting and document range formatting, allowing other plugins
        --- or external formatters to take over these tasks.
        ---
        --- @param client table: The LSP client instance whose formatting capabilities are to be disabled.
        local function disable_lsp_formatting(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        local servers = {
          ansiblels = {},

          bashls = {},

          bufls = {},

          clangd = {
            root_dir = function(fname)
              return require('lspconfig.util').root_pattern(
                'makefile',
                'configure.ac',
                'configure.in',
                'config.h.in',
                'meson.build',
                'meson_options.txt',
                'build.ninja'
              )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require('lspconfig.util').find_git_ancestor(
                fname
              )
            end,
            capabilities = {
              offsetEncoding = { 'utf-16' },
            },
            cmd = {
              'clangd',
              '--background-index',
              '--suggest-missing-includes',
              '--clang-tidy',
              '--header-insertion=iwyu',
              '--completion-style=detailed',
              '--function-arg-placeholders',
              '--fallback-style=llvm',
            },
            init_options = {
              clangdFileStatus = true,
              usePlaceholders = true,
              completeUnimported = true,
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          cssls = {},

          docker_compose_language_service = {},

          dockerls = {},

          graphql = {},

          gopls = {
            settings = {
              gopls = {
                gofumpt = true,
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                codelenses = {
                  generate = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                },
                analyses = {
                  unusedparams = true,
                  nilness = true,
                  fieldalignment = true,
                  unusedwrite = true,
                },
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  constantValues = true,
                },
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          jsonls = {
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
            end,
            settings = {
              json = {
                format = { enable = true },
                validate = { enable = true },
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          jinja_lsp = {},

          lemminx = {
            cmd = { 'lemminx' },
            filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
          },

          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                workspace = {
                  library = { vim.env.VIMRUNTIME },
                  checkThirdParty = false,
                },
                diagnostics = {
                  globals = { 'vim' },
                },
                completion = {
                  callSnippet = 'Replace',
                },
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          marksman = {},

          -- meson = {},

          neocmake = {},

          pyright = {
            settings = {
              python = {
                analysis = {
                  autoImportCompletions = true,
                  typeCheckingMode = 'basic',
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
              },
              pyright = {
                disableOrganizeImports = true,
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          powershell_es = {
            bundle_path = vim.fn.stdpath 'data' .. '/mason/packages/powershell-editor-services',
            shell = 'pwsh', -- Use 'powershell' if you're on Windows and 'pwsh' is not available
          },

          ruff = {
            init_options = {
              settings = {
                lint = {
                  enable = true,
                  run = 'onsave',
                },
                format = {
                  enable = true,
                },
                organizeImports = true,
              },
            },
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          },

          svelte = {},

          taplo = {},

          texlab = {
            settings = {
              texlab = {
                auxDirectory = '.',
                bibtexFormatter = 'texlab',
                chktex = {
                  onEdit = false,
                  onOpenAndSave = false,
                },
                build = {
                  executable = 'latexmk',
                  args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                  onSave = true,
                },
                forwardSearch = {
                  executable = 'zathura',
                  args = { '--synctex-forward', '%l:1:%f', '%p' },
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          vtsls = {
            filetypes = {
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'typescript',
              'typescriptreact',
              'typescript.tsx',
            },
            settings = {
              javascript = {
                updateImportsOnFileMove = { enabled = 'always' },
              },
              typescript = {
                suggest = { completeFunctionCalls = true, autoImports = true },
                inlayHints = {
                  parameterNames = { enabled = 'literals' },
                  parameterTypes = { enabled = true },
                },
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },

          volar = {
            filetypes = { 'vue' },
          },

          vimls = {},

          yamlls = {
            capabilities = {
              textDocument = {
                foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true,
                },
              },
            },
            on_new_config = function(new_config)
              new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
            end,
            settings = {
              yaml = {
                keyOrdering = false,
                validate = true,
                schemaStore = {
                  enable = false,
                  url = '',
                },
              },
            },
            on_attach = function(client)
              disable_lsp_formatting(client)
            end,
          },
        }

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          -- Linters
          'ansible-lint',
          'shellcheck',
          'checkstyle',
          'cpplint',
          'cmakelint',
          'stylelint',
          'hadolint',
          'djlint',
          'golangci-lint',
          'nilaway',
          'htmlhint',
          'jsonlint',
          'eslint_d',
          'vale',
          'luacheck',
          'markdownlint',
          'checkmake',
          'vacuum',
          'buf',
          'ruff',
          'sqlfluff',
          'systemdlint',
          'vint',
          'yamllint',

          -- Formatters
          'shfmt',
          'clang-format',
          'prettierd',
          'prettier',
          'cmakelang',
          'golines',
          'goimports',
          'gofumpt',
          'latexindent',
          'stylua',
          'cbfmt',
          'doctoc',
          'ruff',
          'sqlfmt',
          'yamlfmt',
          'stylua', -- Used to format Lua code

          -- LSPs
          'jq-lsp',
          'emmet-language-server',
          'powershell-editor-services',
          'ansible-language-server',
          'arduino-language-server',
          'bash-language-server',
          'buf-language-server',
          'bzl',
          'clangd',
          'css-lsp',
          'docker-compose-language-service',
          'dockerfile-language-server',
          'gopls',
          'graphql-language-service-cli',
          'jdtls',
          'jinja-lsp',
          'json-lsp',
          'lemminx',
          'ltex-ls',
          'lua-language-server',
          'marksman',
          'mesonlsp',
          'neocmakelsp',
          'pyright',
          'ruff',
          'ruff-lsp',
          'sqls',
          'taplo',
          'templ',
          'texlab',
          'vim-language-server',
          'vtsls',
          'yaml-language-server',

          -- Debuggers
          'delve', -- Go
          'debugpy', -- Python
          'bash-debug-adapter', -- Bash
          'js-debug-adapter', -- Javascript
          'java-debug-adapter',
          'java-test',
          'codelldb', -- C/C++/Rust
          'bzl', -- Bazel (BUILD files
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              -- Ensure 'servers' and 'capabilities' are defined before this
              local server = servers[server_name] or {}
              -- Merge capabilities with the server's default capabilities
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              -- Setup the LSP server with the merged configuration
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },

    { -- Autoformat
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters_by_ft = {
          --
          -- You can use a sub-list to tell conform to run *until* a formatter
          -- is found.
          bash = { 'shfmt', 'beautysh', stop_after_first = false },
          c = { 'clang-format' },
          cpp = { 'clang-format' },
          css = { 'prettierd', 'prettier', stop_after_first = true },
          cmake = { 'cmakelang' },
          django = { 'djlint' },
          go = { 'golines', 'goimports', 'gofumpt', stop_after_first = false },
          graphql = { 'prettierd', 'prettier', stop_after_first = true },
          html = { 'prettierd', 'prettier', stop_after_first = true },
          java = { 'google-java-format', 'clang-format', stop_after_first = true },
          javascript = { 'prettierd', 'eslint_d', stop_after_first = true },
          javascriptreact = { 'prettierd', 'eslint_d', stop_after_first = true }, -- React JSX
          typescript = { 'prettierd', 'eslint_d', stop_after_first = true },
          typescriptreact = { 'prettierd', 'eslint_d', stop_after_first = true }, -- React TSX
          jinja = { 'djlint' },
          json = { 'jq', 'prettierd', 'prettier', stop_after_first = true },
          latex = { 'latexindent' },
          less = { 'prettierd', 'prettier', stop_after_first = true },
          lua = { 'stylua' },
          markdown = { 'markdownlint', 'cbfmt', 'doctoc', stop_after_first = false },
          proto = { 'buf' },
          python = { 'ruff' },
          php = { 'php_cs_fixer' }, -- Ensure php_cs_fixer is installed
          scss = { 'prettierd', 'prettier', stop_after_first = true },
          sh = { 'shfmt', 'beautysh', stop_after_first = false },
          sql = { 'sqlfmt' },
          yaml = { 'yamlfmt' },
          xml = { 'xmlformatter' },
          ipynb = { 'jupytext' }, -- Jupyter Notebooks
          vue = { 'prettierd', 'prettier', stop_after_first = true }, -- Vue.js files
          svelte = { 'prettierd', 'prettier', stop_after_first = true }, -- Svelte files
        },
      },
    },

    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
          'L3MON4D3/LuaSnip',
          build = (function()
            -- Build Step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            -- `friendly-snippets` contains a variety of premade snippets.
            --    See the README about individual language/framework/plugin snippets:
            --    https://github.com/rafamadriz/friendly-snippets
            {
              'rafamadriz/friendly-snippets',
              config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
              end,
            },
          },
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',

        -- If you want to add a bunch of pre-configured snippets,
        --    you can use this plugin to help you. It even has snippets
        --    for various frameworks/libraries/etc. but you will have to
        --    set up the ones that are useful for you.
        'rafamadriz/friendly-snippets',
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },

          -- For an understanding of why these mappings were
          -- chosen, you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          mapping = cmp.mapping.preset.insert {
            -- Select the [n]ext item
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Select the [p]revious item
            ['<C-p>'] = cmp.mapping.select_prev_item(),

            -- Scroll the documentation window [b]ack / [f]orward
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),

            -- Accept ([y]es) the completion.
            --  This will auto-import if your LSP supports it.
            --  This will expand snippets if the LSP sent a snippet.
            ['<C-y>'] = cmp.mapping.confirm { select = true },

            -- If you prefer more traditional completion keymaps,
            -- you can uncomment the following lines
            --['<CR>'] = cmp.mapping.confirm { select = true },
            --['<Tab>'] = cmp.mapping.select_next_item(),
            --['<S-Tab>'] = cmp.mapping.select_prev_item(),

            -- Manually trigger a completion from nvim-cmp.
            --  Generally you don't need this, because nvim-cmp will display
            --  completions whenever it has completion options available.
            ['<C-Space>'] = cmp.mapping.complete {},

            -- Think of <c-l> as moving to the right of your snippet expansion.
            --  So if you have a snippet that's like:
            --  function $name($args)
            --    $body
            --  end
            --
            -- <c-l> will move you to the right of each of the expansion locations.
            -- <c-h> is similar, except moving you backwards.
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
          },
          sources = {
            {
              name = 'lazydev',
              -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
              group_index = 0,
            },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
          },
        }
      end,
    },

    { -- You can easily change to a different colorscheme.
      -- Change the name of the colorscheme plugin below, and then
      -- change the command in the config to whatever the name of that colorscheme is.
      --
      -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
      'navarasu/onedark.nvim',
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        -- Load the colorscheme here
        vim.cmd.colorscheme 'onedark'

        require('onedark').setup {
          -- Enable the transparent background
          transparent = true,
        }

        -- You can configure highlights by doing something like:
        vim.cmd.hi 'Comment gui=none'
      end,
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end

        -- Smooth animations for cursor movements, scrolling, window resizing, etc.
        require('mini.animate').setup() -- Using default settings

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
      end,
    },
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
      -- Add the textobjects module
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
            [']b'] = '@block.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
            [']B'] = '@block.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
            ['[b'] = '@block.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
            ['[B'] = '@block.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>sn'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>sp'] = '@parameter.inner',
          },
        },
      },
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      dependencies = { 'nvim-treesitter' },
      config = function()
        require('treesitter-context').setup {
          enable = true, -- Enable this plugin
          max_lines = 0, -- No limit on the number of lines context can span
          trim_scope = 'outer', -- Discard outer context if max_lines is exceeded
          patterns = { -- Match patterns for TS nodes to display in context
            default = {
              'class',
              'function',
              'method',
              'for',
              'while',
              'if',
              'switch',
              'case',
            },
          },
          separator = '─', -- Separator between context and content
        }
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      dependencies = { 'nvim-treesitter' },
      config = function()
        -- No additional configuration needed unless you want to customize keymaps
      end,
    },

    -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',
    require 'kickstart.plugins.lint',
    require 'kickstart.plugins.autopairs',
    require 'kickstart.plugins.neo-tree',
    require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    { import = 'custom.plugins' },
    --
    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
    -- Or use telescope!
    -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
    -- you can continue same window with `<space>sr` which resumes last telescope search
  }, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })

  -- Key mappings for clipboard operations
  vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y"]], { desc = '[Y]ank to clipboard' })

  -- Key mappings for mode operations
  vim.keymap.set('i', '<C-c>', '<Esc>', { desc = '[C]ancel insert mode' })

  -- Key mappings for file and buffer operations
  vim.keymap.set('n', '<leader>dx', '<cmd>!chmod +x %<CR>', { silent = true, desc = '[X] Make file executable' })

  vim.g.netrw_banner = 0 -- Disable the banner at the top of Netrw
  vim.g.netrw_browse_split = 4 -- Open files in the previous window
  vim.g.netrw_altv = 1 -- Open new splits to the right
  vim.g.netrw_liststyle = 3 -- Use a tree-style listing

  -- Function to hide files in Netrw
  local function netrw_hide_files()
    -- Check if netrw_list_hide is initialized
    if vim.g.netrw_list_hide == nil then
      vim.g.netrw_list_hide = ''
    end
    local ignored_files = '\\v(^\\.|\\.(swp|un~|swo|o|pyc)$)' -- Define patterns for ignored files
    vim.g.netrw_list_hide = vim.g.netrw_list_hide .. ',' .. ignored_files
  end

  netrw_hide_files() -- Call the function to hide files in Netrw

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end
