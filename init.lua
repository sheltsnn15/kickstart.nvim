-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true

-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clipboard keymaps
vim.keymap.set({ 'n', 'v' }, '<leader>Cy', [["+y"]], { desc = '[Y]ank to [C]lipboard' })
vim.keymap.set('n', '<leader>CY', [["+Y"]], { desc = '[Y]ank line to [C]lipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>Cp', [["+p"]], { desc = '[P]aste from [C]lipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>Cd', [["+d"]], { desc = '[D]elete (cut) to [C]lipboard' })

-- Key mappings for mode operations
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = '[C]ancel insert mode' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>tq', function()
  vim.diagnostic.setloclist { open = false } -- Fill the loclist, but do NOT open
  require('quicker').toggle { loclist = true } -- Toggle loclist with `quicker`
end, { desc = '[T]oggle [Q]uickfix list' })

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

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

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
  -- NOTE: Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
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
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle', mode = { 'n' } },
        { '<leader>R', group = '[R]efactor', mode = { 'n', 'v' } },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
        { '<leader>gc', group = '[G]it [C]onflict' },
        { '<leader>gd', group = '[G]it [D]iffview' },
        { '<leader>gh', group = '[G]it[h]ub' },
        { '<leader>ghc', group = '[G]it[H]ub [C]ommits' },
        { '<leader>ghi', group = '[G]it[H]ub [I]ssues' },
        { '<leader>ghl', group = '[G]it[H]ub [L]itee' },
        { '<leader>ghp', group = '[G]it[H]ub [P]ull Request' },
        { '<leader>ghr', group = '[G]it[H]ub [R]eview' },
        { '<leader>ght', group = '[G]it[H]ub [T]hreads' },
        { '<leader>gs', group = '[G]it[S]igns' },
        { '<leader>gt', group = '[G]it [T]oggle', mode = { 'n' } },
        { '<leader>m', group = 'Vi[m]ux/Test', mode = { 'n' } },
        { '<leader>C', group = 'System [C]lipboard', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
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
    -- By default, Telescope is included and acts as your picker for everything.

    -- If you would like to switch to a different picker (like snacks, or fzf-lua)
    -- you can disable the Telescope plugin by setting enabled to false and enable
    -- your replacement picker by requiring it explicitly (e.g. 'custom.plugins.snacks')

    -- Note: If you customize your config for yourself,
    -- it’s best to remove the Telescope plugin config entirely
    -- instead of just disabling it here, to keep your config clean.
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function() return vim.fn.executable 'make' == 1 end,
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
        defaults = {
          file_ignore_patterns = {
            -- Version Control
            '^.git/',
            '^.svn/',
            '^.hg/',
            '^node_modules/',

            -- Build & Compiled Files
            '%.o$',
            '%.a$',
            '%.so$',
            '%.class$',
            '%.pyc$',
            '%.pyo$',
            '%.pyd$',
            '%.jar$',
            '%.war$',
            '%.ear$',
            '%.tsbuildinfo$',
            '%.phar$',
            '%.gem$',

            -- Temporary & Backup
            '%.swp$',
            '%.bak$',
            '%~$',
            '%.tmp$',

            -- Media & Archives
            '%.mp3$',
            '%.mp4$',
            '%.jpg$',
            '%.jpeg$',
            '%.png$',
            '%.gif$',
            '%.svg$',
            '%.ico$',
            '%.zip$',
            '%.tar%.gz$',
            '%.rar$',
            '%.7z$',

            -- IDE/Editor
            '%.idea/',
            '%.vscode/',

            -- Development & Build Artifacts
            '__pycache__/',
            '%_pycache_%',
            '^target/',
            '^build/',
            '^dist/',
            '^out/',
            '^%.next/',
            '^%.nuxt/',
            '^%.cache/',
            '^%.parcel-cache/',
            '^%.svelte-kit/',
            '^%.gradle/',
            '^%.cargo/',
            '^%.go/',
            '^%.bundle/',
            '^%.mix/',
            '^_build/',
            '^deps/',
            '^bin/',
            '^vendor/',
            '^bower_components/',
            '^%.yarn/',
            '^%.pnpm-store/',
            '^%.pnp%.[^/]*',

            -- Logs
            '%.log$',
            '^logs/',

            -- System & OS Specific
            '%DS_Store$',
            '%.AppleDouble$',
            '%.LSOverride$',
            '%desktop%.ini$',
            '%Thumbs%.db$',
            'ehthumbs%.db$',
            '%.fuse_hidden%',

            -- Microsoft Office
            '%.doc$',
            '%.docx$',
            '%.docm$',
            '%.dot$',
            '%.dotx$',
            '%.dotm$',
            '%.xls$',
            '%.xlsx$',
            '%.xlsm$',
            '%.xlt$',
            '%.xltx$',
            '%.xltm$',
            '%.xlam$',
            '%.ppt$',
            '%.pptx$',
            '%.pptm$',
            '%.pot$',
            '%.potx$',
            '%.potm$',
            '%.pps$',
            '%.ppsx$',
            '%.ppsm$',
            '%.accdb$',
            '%.accde$',
            '%.accdt$',
            '%.accdr$',
            '%.pub$',
            '%.vsd$',
            '%.vsdx$',
            '%.mpp$',
            '%.mpt$',
            '%.one$',

            -- LibreOffice/OpenOffice
            '%.odt$',
            '%.ott$',
            '%.oth$',
            '%.ods$',
            '%.ots$',
            '%.odp$',
            '%.otp$',
            '%.odg$',
            '%.otg$',
            '%.odb$',
            '%.odf$',
            '%.odm$',
            '%.stw$',

            -- Other Office Suites & Formats
            '%.pages$',
            '%.numbers$',
            '%.key$',
            '%.wps$',
            '%.wpd$',
            '%.sxw$',
            '%.sxc$',
            '%.sxi$',
            '%.sxd$',

            -- PDF & Ebooks
            '%.pdf$',
            '%.xps$',
            '%.epub$',
            '%.mobi$',

            -- Fonts
            '%.ttf$',
            '%.otf$',
            '%.woff$',
            '%.woff2$',

            -- Documentation
            '%.chm$',

            -- Temporary Office Files
            '~%.*%.docx?$',
            '~%.*%.xlsx?$',
            '~%.*%.pptx?$',
            '^~%$.*',
            '%.%.lock%.%.*',
            '%.asd$',

            -- Environment files (optional - uncomment if you want to ignore these)
            -- '%env%',
            -- '%ENV%',
            -- '%env%.*',
            -- '%ENV%.*',
            -- '%.env%',
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
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
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
      -- it is better explained there). This allows easily switching between pickers if you prefer using something else!
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      -- Override default behavior and theme when searching
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      { 'b0o/schemastore.nvim', lazy = true },
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

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>

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

        buf_ls = {},

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

        ltex = {
          settings = {
            ltex = {
              language = 'en-GB',
              diagnosticSeverity = 'information',
              enabled = { 'markdown', 'tex', 'latex', 'quarto', 'rmd', 'plaintext' },
            },
          },
        },

        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,

          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              completion = { callSnippet = 'Replace' },
              -- (don’t set workspace.library here; on_init handles it conditionally)
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
              venvPath = (function()
                local venv = vim.env.VIRTUAL_ENV or vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
                return venv ~= '' and vim.fn.fnamemodify(venv, ':h') or nil
              end)(),
              venv = (function()
                local venv = vim.env.VIRTUAL_ENV or vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
                return venv ~= '' and vim.fn.fnamemodify(venv, ':t') or nil
              end)(),
            },
            pyright = { disableOrganizeImports = true },
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
                enable = false,
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
            -- vtsls-specific goodies
            vtsls = {
              autoUseWorkspaceTsdk = true, -- prefer project TS version
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                  entriesLimit = 100, -- tweak to taste
                },
              },
            },

            javascript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = { completeFunctionCalls = true, autoImports = true },
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
              preferences = {
                -- pick what you like: 'relative' | 'non-relative' | 'shortest'
                importModuleSpecifier = 'non-relative',
                includePackageJsonAutoImports = 'off', -- reduces noisy package completions
              },
            },

            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = { completeFunctionCalls = true, autoImports = true },
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
              preferences = {
                importModuleSpecifier = 'non-relative',
                includePackageJsonAutoImports = 'off',
              },
              tsserver = {
                -- bump if you work in very large monorepos
                -- maxTsServerMemory = 4096,
              },
            },
          },
          on_attach = function(client)
            disable_lsp_formatting(client)
          end,
        },

        vimls = {},

        vale_ls = {
          filetypes = { 'markdown', 'mdx', 'text' },
          init_options = {
            configPath = vim.fn.expand '~/.vale.ini',
            glob = '**/*.{md,mdx,txt}',
          },
        },

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
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
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
        'stylua',

        -- LSPs
        'jq-lsp',
        'emmet-language-server',
        'powershell-editor-services',
        'ansible-language-server',
        'arduino-language-server',
        'bash-language-server',
        'buf',
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
        'llm-ls',
        'ltex-ls',
        'lua-language-server',
        'marksman',
        'mesonlsp',
        'neocmakelsp',
        'pyright',
        'ruff',
        'starpls',
        'sqls',
        'taplo',
        'templ',
        'texlab',
        'vim-language-server',
        'vtsls',
        'yaml-language-server',

        -- Debuggers
        'delve',
        'debugpy',
        'bash-debug-adapter',
        'js-debug-adapter',
        'java-debug-adapter',
        'java-test',
        'codelldb',
        -- You can add other tools here that you want Mason to install
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          -- c = true,
          -- cpp = true,
        }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 1000,
            lsp_format = 'fallback',
          }
        end
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
        javascriptreact = { 'prettierd', 'eslint_d', stop_after_first = true },
        typescript = { 'prettierd', 'eslint_d', stop_after_first = true },
        typescriptreact = { 'prettierd', 'eslint_d', stop_after_first = true },
        jinja = { 'djlint' },
        json = { 'jq', 'prettierd', 'prettier', stop_after_first = true },
        latex = { 'latexindent' },
        less = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        markdown = { 'markdownlint', 'doctoc', stop_after_first = false },
        proto = { 'buf' },
        python = { 'black', 'ruff', stop_after_first = false },
        php = { 'php_cs_fixer' },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt', 'beautysh', stop_after_first = false },
        sql = { 'sqlfmt' },
        yaml = { 'yamlfmt' },
        xml = { 'xmlformatter' },
        ipynb = { 'jupytext' },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        svelte = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
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
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'catppuccin-macchiato'

      require('catppuccin').setup {
        -- Enable the transparent background
        transparent = true,
      }

      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Smooth animations for cursor movements, scrolling, window resizing, etc.
      require('mini.animate').setup()

      -- Align text interactively
      --
      -- - Alignment in 3 steps: Split lines, justify parts, merge with delimiters.
      --   - `s`: Split pattern, `j`: Justification side, `m`: Merge delimiter.
      --   - `f`: Filter parts, `i`: Ignore matches, `p`: Pair parts, `t`: Trim whitespace.
      --   - `<BS>`: Remove last pre-step.
      require('mini.align').setup()

      -- Jump to next/previous single character
      --
      -- - Extend `f`, `F`, `t`, `T` to work across multiple lines.
      -- - Repeat jump with `f`, `F`, `t`, `T`; resets after non-jump move or timeout.
      require('mini.jump').setup()

      -- Move any selection in any direction
      --
      -- - Linewise: `=` for reindent, `>` / `<` for indent/dedent.
      -- - Cursor follows selection; supports `v:count` and undo with `u`.
      -- - Preferred column respected for vertical moves.
      require('mini.move').setup()

      -- Fast and flexible start screen
      --
      -- - Choose items by:
      --   1. Typing a prefix query (case-insensitive; highlights unique prefixes).
      --   2. Navigating with Down/Up, <C-n>/<C-p>, or <M-j>/<M-k>, and pressing Enter.
      -- - Supports multiple open Starter buffers.
      require('mini.starter').setup()

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
      statusline.section_location = function() return '%2l:%-2v' end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
          vim.g.no_plugin_maps = true
        end, -- avoid ftplugin mapping conflicts
        config = function()
          require('nvim-treesitter-textobjects').setup {}
        end,
      },
    },
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then return end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
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
  require 'kickstart.plugins.gitsigns',

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
}, { ---@diagnostic disable-line: missing-fields
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
