return {
  'lervag/vimtex',
  lazy = false, -- Lazy-loading is disabled to maintain functionality like inverse search
  config = function()
    -- Viewer configuration
    vim.g.vimtex_view_method = 'zathura' -- For Zathura users
    -- Alternatively, for generic viewer configuration (e.g., Okular)
    vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'

    -- Compiler configuration
    vim.g.vimtex_compiler_method = 'latexmk'

    -- Conceal settings, applied only to bib and tex filetypes
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      group = vim.api.nvim_create_augroup('lazyvim_vimtex_conceal', { clear = true }),
      pattern = { 'bib', 'tex' },
      callback = function()
        vim.wo.conceallevel = 2 -- Sets conceal level to 2 for specified filetypes
      end,
    })

    -- Disable specific mappings if they conflict with your setup
    vim.g.vimtex_mappings_disable = { ['n'] = { 'K' } } -- Disables `K` in normal mode as it conflicts with LSP hover

    -- Quickfix method configuration
    -- Uses 'pplatex' if it is executable, otherwise defaults to 'latexlog'
    vim.g.vimtex_quickfix_method = vim.fn.executable 'pplatex' == 1 and 'pplatex' or 'latexlog'
  end,
}
