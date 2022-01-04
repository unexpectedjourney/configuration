-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local fmt = string.format

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', fn.stdpath('data'))
if fn.empty(fn.glob(paq_dir)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir})
end

require 'paq' {
    {'savq/paq-nvim', opt = true},    -- paq-nvim manages itself
    {'airblade/vim-gitgutter'},
    {'joshdick/onedark.vim'},
    {'shougo/deoplete-lsp'},
    {'shougo/deoplete.nvim', run = fn['remote#host#UpdateRemotePlugins']},
    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-treesitter/nvim-treesitter-textobjects'},
    {'neovim/nvim-lspconfig'},
    {'junegunn/fzf', run = fn['fzf#install']},
    {'junegunn/fzf.vim'},
    {'ojroques/nvim-lspfuzzy'},
    {'ojroques/nvim-bufbar'},
    {'ojroques/nvim-bufdel'},
    {'ojroques/nvim-hardline'},
    -- {'ojroques/vim-oscyank'},
    {'justinmk/vim-dirvish'},
    {'kyazdani42/nvim-web-devicons'},
    {'tpope/vim-commentary'},
    {'romgrk/barbar.nvim'},
    {
        'junegunn/goyo.vim', 
        requires = {'junegunn/limelight.vim', opt = true, event = 'GoyoEnter'},
        cmd = 'Goyo',
        config = function()
        -- Launch Limelight with Goyo
        cmd [[ augroup GoyoMode ]]
        cmd [[ autocmd! ]]
        cmd [[ autocmd User GoyoEnter Limelight ]]
        cmd [[ autocmd User GoyoLeave Limelight! ]]
        cmd [[ augroup END ]]
        end,
    },
}
-------------------- PLUGIN SETUP --------------------------
-- bufbar
require('bufbar').setup {show_bufname = 'visible', show_flags = false}

-- bufdel
map('n', '<leader>w', '<cmd>BufDel<CR>')
require('bufdel').setup {next = 'alternate'}

-- deoplete
g['deoplete#enable_at_startup'] = 1
fn['deoplete#custom#option']('ignore_case', false)
fn['deoplete#custom#option']('max_list', 10)

-- dirvish
g['dirvish_mode'] = [[:sort ,^.*[\/],]]

-- fugitive and git
local log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen\%as \%Cblue\%an\%Creset]]
map('n', '<leader>g<space>', ':Git ')
map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
map('n', '<leader>gg', '<cmd>Git<CR>')
map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>', log))

-- hardline
require('hardline').setup {}

--nvim-comment
map("n", "<C-\\>", ":Commentary<CR>")
map("v", "<C-\\>", ":Commentary<CR>")

-- fzf
map('n', '<leader>/', '<cmd>BLines<CR>')
map('n', '<leader>f', '<cmd>Files<CR>')
map('n', '<leader>r', '<cmd>Rg<CR>')
map('n', 's', '<cmd>Buffers<CR>')
g['fzf_action'] = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit',
}

-- tree-sitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['aa'] = '@parameter.outer', ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer', ['if'] = '@function.inner',
      },
    },
    move = {
      enable = true,
      goto_next_start = {[']a'] = '@parameter.outer', [']f'] = '@function.outer'},
      goto_next_end = {[']A'] = '@parameter.outer', [']F'] = '@function.outer'},
      goto_previous_start = {['[a'] = '@parameter.outer', ['[f'] = '@function.outer'},
      goto_previous_end = {['[A'] = '@parameter.outer', ['[F'] = '@function.outer'},
    },
  },
}
-------------------- OPTIONS -------------------------------
g['mapleader'] = "\\"
local indent, width = 4, 80
cmd 'colorscheme onedark'

opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('b', 'softtabstop', indent)                       -- Number of spaces tabs count for
opt('b', 'textwidth', width)                          -- Maximum width of text
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('o', 'termguicolors', false)
opt('w', 'colorcolumn', tostring(width))              -- Line length marker
opt('w', 'cursorline', true)                          -- Highlight cursor line
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', true)                      -- Relative line numbers
opt('w', 'signcolumn', 'yes')                         -- Show sign column
opt('w', 'wrap', false)                               -- Disable line wrap

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

map('i', 'jj', '<ESC>')

--- <tabs>
map('n', '<C-w>T', '<cmd>tabclose<CR>')
map('n', '<C-w>t', '<cmd>tabnew<CR>')

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>nohlsearch<CR>') -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- For ccls we use the default settings
lsp.ccls.setup {}
-- root_dir is where the LSP server will start: here at the project root otherwise in current folder
lsp.pylsp.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- COMMANDS ------------------------------
function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end

vim.tbl_map(function(c) cmd(fmt('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | execute "OSCYankReg +" | endif',
  'TextYankPost * lua vim.highlight.on_yank {timeout = 200, on_visual = false}',
})
