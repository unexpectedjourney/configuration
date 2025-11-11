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

vim.keymap.set({ "n", "v" }, "<leader>c", '"+y')   -- copy selection / line
vim.keymap.set("n", "<leader>cc", '"+yy')  -- copy single line

-- Delete to black hole register with <leader>d
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete to black hole' })
vim.keymap.set('n', '<leader>dd', '"_dd', { desc = 'Delete line to black hole' })
vim.keymap.set('n', '<leader>D', '"_D', { desc = 'Delete to EOL to black hole' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete to black hole' })
vim.keymap.set('x', '<leader>d', '"_d', { desc = 'Delete to black hole' })
