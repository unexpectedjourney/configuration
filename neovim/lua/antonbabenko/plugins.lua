local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
    })
end

vim.cmd.packadd('packer.nvim')
local packer = require("packer")

packer.startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.4',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    "sonph/onehalf",
    rtp = "vim/",
    config = function() vim.cmd("colorscheme onehalfdark") end
  }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {"tpope/vim-commentary"}
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }

  }
  use {
    'ojroques/nvim-osc52'
  }
  use {
    'ojroques/nvim-bufbar'
  }
  use {
    'ojroques/nvim-bufdel'
  }
  use {
    'ojroques/nvim-hardline'
  }

end)

return packer
