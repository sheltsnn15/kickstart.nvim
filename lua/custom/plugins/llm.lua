-- LLM ghost-text integration via Ollama for Neovim
return {
  {
    'huggingface/llm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    opts = function()
      local config = {
        backend = 'ollama',
        url = 'http://localhost:11434',
        model = 'llama3.1:8b-instruct-q4_K_M', -- default: fast & solid on CPU

        -- keep ghost-text tidy & responsive
        enable_suggestions_on_startup = false,
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
          '*.rs',
          '*.toml',
          '*.xml',
        },
        debounce_ms = 120,
        accept_keymap = '<C-l>', -- avoid <Tab> conflicts with cmp
        dismiss_keymap = '<C-]>',
        tokens_to_clear = { '<|endoftext|>', '<EOT>' },

        request_body = {
          -- passed as-is to Ollama /api/generate
          options = {
            temperature = 0.2,
            top_p = 0.95,
            num_ctx = 4096, -- plenty for completions
            num_thread = 8, -- try 8–12 on the 5900HX; start at 8
            num_predict = 96, -- short, snappy ghost-text
          },
        },

        -- leave FIM off unless the model explicitly supports it
        fim = { enabled = false },
      }
      return config
    end,

    config = function(_, opts)
      local ok, llm = pcall(require, 'llm')
      if not ok then
        vim.notify('llm.nvim not found!', vim.log.levels.ERROR)
        return
      end
      llm.setup(opts)

      -- model presets
      local models = {
        fast = { model = 'llama3.1:8b-instruct-q4_K_M', label = 'llama3.1:8b-instruct (Fast)' },
        coder = { model = 'qwen2.5-coder:7b-instruct-q4_K_M', label = 'qwen2.5-coder:7b (Coding)' },
        deepseek = { model = 'deepseek-r1:7b', label = 'deepseek-r1:7b (Reasoning)' },
      }

      local function switch_model(key)
        local m = models[key]
        if not m then
          vim.notify('Invalid model key: ' .. tostring(key), vim.log.levels.ERROR)
          return
        end
        llm.setup { model = m.model }
        vim.notify('LLM → ' .. m.label)
      end

      -- commands to switch model
      vim.api.nvim_create_user_command('LLMModelFast', function()
        switch_model 'fast'
      end, { desc = 'Use llama3.1:8b-instruct' })
      vim.api.nvim_create_user_command('LLMModelCoder', function()
        switch_model 'coder'
      end, { desc = 'Use qwen2.5-coder:7b' })
      vim.api.nvim_create_user_command('LLMModelDeepseek', function()
        switch_model 'deepseek'
      end, { desc = 'Use deepseek-r1:7b' })

      -- toggle autosuggest using the plugin command
      vim.api.nvim_create_user_command('LLMToggle', function()
        vim.cmd 'LLMToggleAutoSuggest'
      end, { desc = 'Toggle LLM autosuggestions' })

      -- on-demand suggestion
      vim.api.nvim_create_user_command('LLMSuggest', function()
        vim.cmd 'LLMSuggestion'
      end, { desc = 'Request a suggestion now' })
    end,
  },
}
