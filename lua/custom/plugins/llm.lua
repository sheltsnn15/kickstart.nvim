-- ============================================================
-- LLM Ghost Text
-- Local Ollama-powered inline suggestions
-- ============================================================

vim.pack.add {
  'https://github.com/huggingface/llm.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('llm').setup {
  backend = 'ollama',

  url = 'http://localhost:11434',

  -- Good balance between speed and quality
  model = 'qwen2.5-coder:7b-instruct-q4_K_M',

  -- Do not start suggestions automatically
  enable_suggestions_on_startup = false,

  -- Keep completion focused on development files
  enable_suggestions_on_files = {
    '*.c',
    '*.cpp',
    '*.go',
    '*.java',
    '*.js',
    '*.jsx',
    '*.lua',
    '*.py',
    '*.rs',
    '*.ts',
    '*.tsx',
  },

  -- Lower feels more responsive
  debounce_ms = 120,

  -- Avoid completion conflicts
  accept_keymap = '<C-l>',
  dismiss_keymap = '<C-]>',

  request_body = {
    options = {
      temperature = 0.2,
      top_p = 0.95,
      num_ctx = 4096,
      num_predict = 96,
    },
  },

  -- Most local coding models still behave better without FIM
  fim = {
    enabled = false,
  },
}

-- ============================================================
-- LLM Commands
-- ============================================================

vim.api.nvim_create_user_command('LLMToggle', function() vim.cmd 'LLMToggleAutoSuggest' end, {
  desc = 'Toggle LLM autosuggestions',
})

vim.api.nvim_create_user_command('LLMSuggest', function() vim.cmd 'LLMSuggestion' end, {
  desc = 'Request LLM suggestion',
})
