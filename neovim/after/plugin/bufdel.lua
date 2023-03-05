require('bufdel').setup {next = 'alternate', quit = false}

vim.keymap.set('n', '<leader>w', '<cmd>BufDel<CR>')
