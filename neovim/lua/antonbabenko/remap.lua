vim.g.mapleader = "\\"
vim.keymap.set("n", "<C-\\>", ":Commentary<CR>")
vim.keymap.set("v", "<C-\\>", ":Commentary<CR>")

vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<C-l>', '<cmd>nohlsearch<CR>') -- Clear highlights
vim.keymap.set('n', '<leader>o', 'm`o<Esc>``')
vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

vim.keymap.set('n', '<C-w>t', '<cmd>tabnew<CR>')
vim.keymap.set('n', '<C-w>T', '<cmd>tabclose<CR>')
