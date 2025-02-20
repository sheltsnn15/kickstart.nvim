-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'huggingface/llm.nvim',
  opts = {
    backend = 'ollama', -- Uses Ollama backend
    model = 'deepseek-r1:7b', -- Your preferred model
    url = 'http://localhost:11434', -- Ollama API endpoint
    request_body = {
      options = {
        temperature = 0.2, -- Controls randomness
        top_p = 0.95, -- Sampling parameter
      },
    },

    -- Disable auto-suggestions to avoid conflict with LSP & cmp
    enable_suggestions_on_startup = false,

    -- Enable AI suggestions only in these filetypes
    enable_suggestions_on_files = {
      '*.ansible',
      '*.sh',
      '*.c',
      '*.cpp',
      '*.cmake',
      '*.css',
      '*.dockerfile',
      '*.django',
      '*.go',
      '*.html',
      '*.java',
      '*.js',
      '*.jsx',
      '*.ts',
      '*.tsx',
      '*.jinja',
      '*.json',
      '*.lua',
      '*.md',
      '*.make',
      '*.proto',
      '*.py',
      '*.scss',
      '*.less',
      '*.sql',
      '*.systemd',
      '*.txt',
      '*.vim',
      '*.yaml',
      '*.vue',
      '*.svelte',
    },
  },
}
