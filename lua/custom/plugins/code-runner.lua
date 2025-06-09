return {
  'CRAG666/code_runner.nvim',
  config = function()
    require('code_runner').setup {
      mode = 'toggleterm',
      term = {
        position = 'float',
        size = 15,
      },
      filetype = {
        cpp = {
          'g++ -Wall -Wextra -g $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt',
        },
        c = {
          'gcc -Wall -Wextra -g $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt',
        },
        python = 'python3 -u',
        bash = 'bash',
        lua = 'lua',
        go = 'go run $fileName',
        java = {
          'javac $fileName && java -cp $dir $fileNameWithoutExt',
        },
        php = 'php $fileName',
      },
    }
  end,
}
