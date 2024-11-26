return {
  {
    'RaafatTurki/hex.nvim',
    config = function()
      require('hex').setup {
        -- Configuration options
        dump_cmd = 'xxd -g 1 -u',
        assemble_cmd = 'xxd -r',
        is_file_binary_pre_read = function()
          -- Add any custom logic to detect binary files
        end,
        is_file_binary_post_read = function()
          -- Add any custom logic to detect binary files
        end,
      }
    end,
  },
  {
    'emmanueltouzery/decisive.nvim',
    config = function()
      require('decisive').setup {}
    end,
    lazy = true,
    ft = { 'csv' },
  },
}
