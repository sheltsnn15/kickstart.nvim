return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft =
        -- To allow other plugins to add linters to require('lint').linters_by_ft,
        -- instead set linters_by_ft like this:
        -- lint.linters_by_ft = lint.linters_by_ft or {}
        -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
        --
        -- However, note that this will enable a set of default linters,
        -- which will cause errors unless these tools are available:
        {
          ansible = { 'ansible-lint' },
          bash = { 'shellcheck' },
          sh = { 'shellcheck' },
          c = { 'cpplint' },
          cpp = { 'cpplint' },
          cmake = { 'cmakelint' },
          css = { 'stylelint' },
          dockerfile = { 'hadolint' },
          django = { 'djlint' },
          go = { 'golangci-lint', 'nilaway' },
          html = { 'htmlhint' },
          java = { 'checkstyle' },
          javascript = { 'eslint_d' },
          javascriptreact = { 'eslint_d' },
          typescript = { 'eslint_d' },
          typescriptreact = { 'eslint_d' },
          jinja = { 'djlint' },
          json = { 'jsonlint' },
          lua = { 'luacheck' },
          markdown = { 'markdownlint', 'vale' },
          make = { 'checkmake' },
          makefile = { 'checkmake' },
          proto = { 'buf' },
          python = { 'ruff' },
          scss = { 'stylelint' },
          less = { 'stylelint' },
          sql = { 'sqlfluff' },
          systemd = { 'systemdlint' },
          text = { 'vale' },
          vim = { 'vint' },
          yaml = { 'yamllint' },
          vue = { 'eslint_d' },
          svelte = { 'eslint_d' },
        }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
