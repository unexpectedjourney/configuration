local indent, width = 4, 80

vim.opt.expandtab = true                           -- Use spaces instead of tabs
vim.opt.shiftwidth = indent                        -- Size of an indent
vim.opt.smartindent = true                         -- Insert indents automatically
vim.opt.tabstop = indent                           -- Number of spaces tabs count for
vim.opt.softtabstop = indent                       -- Number of spaces tabs count for
vim.opt.textwidth = width                          -- Maximum width of text
vim.opt.completeopt = 'menuone,noinsert,noselect'  -- Completion options (for deoplete)
vim.opt.hidden = true                              -- Enable modified buffers in background
vim.opt.ignorecase = true                          -- Ignore case
vim.opt.joinspaces = false                         -- No double spaces with join after a dot
vim.opt.scrolloff = 4                              -- Lines of context
vim.opt.shiftround = true                          -- Round indent
vim.opt.sidescrolloff = 8                          -- Columns of context
vim.opt.smartcase = true                           -- Don't ignore case with capitals
vim.opt.splitbelow = true                          -- Put new windows below current
vim.opt.splitright = true                          -- Put new windows right of current
vim.opt.wildmode = 'list:longest'                  -- Command-line completion mode
vim.opt.termguicolors = false
vim.opt.colorcolumn = tostring(width)              -- Line length marker
vim.opt.cursorline = true                          -- Highlight cursor line
vim.opt.list = true                                -- Show some invisible characters (tabs...)
vim.opt.number = true                              -- Print line number
vim.opt.relativenumber = true                      -- Relative line numbers
vim.opt.signcolumn = 'yes'                         -- Show sign column
vim.opt.wrap = false                               -- Disable line wrap

