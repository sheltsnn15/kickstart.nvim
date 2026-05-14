-- ============================================================
-- LaTeX
-- VimTeX configuration for LaTeX editing, compilation, and PDF
-- synchronization with Zathura
-- ============================================================

vim.pack.add {
  'https://github.com/lervag/vimtex',
}

-- NOTE:
-- VimTeX should not be lazy loaded.
-- Inverse search and several internal features rely on global commands.
-- See :help vimtex-lazy-loading

-- ============================================================
-- Viewer Configuration
-- ============================================================

vim.g.vimtex_view_method = 'zathura'

vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'

-- ============================================================
-- Compiler Configuration
-- ============================================================

vim.g.vimtex_compiler_method = 'latexmk'

vim.g.vimtex_compiler_latexmk = {
  executable = 'latexmk',

  options = {
    '-xelatex',
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}

-- ============================================================
-- Quickfix
-- ============================================================

vim.g.vimtex_quickfix_method = vim.fn.executable 'pplatex' == 1 and 'pplatex' or 'latexlog'

-- ============================================================
-- Keymap Compatibility
-- ============================================================

-- Prevent VimTeX from overriding LSP hover
vim.g.vimtex_mappings_disable = {
  ['n'] = { 'K' },
}

-- ============================================================
-- Conceal
-- ============================================================

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('vimtex-conceal', { clear = true }),

  pattern = { 'tex', 'bib' },

  callback = function() vim.wo.conceallevel = 2 end,
})
