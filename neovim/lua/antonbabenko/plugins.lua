-----------------------------------------------------------------------
-- BOOTSTRAP lazy.nvim ------------------------------------------------
-----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------
-- PLUGIN SPEC --------------------------------------------------------
-----------------------------------------------------------------------
require("lazy").setup({

  ---------------------------------------------------------------------
  -- Telescope --------------------------------------------------------
  ---------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    tag         = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = { mappings = { i = { ["<esc>"] = actions.close } } },
      })

      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers,   {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  },

  ---------------------------------------------------------------------
  -- Colourscheme -----------------------------------------------------
  ---------------------------------------------------------------------
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      vim.cmd("colorscheme catppuccin-mocha")
    end,
  },

  ---------------------------------------------------------------------
  -- Treesitter -------------------------------------------------------
  ---------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash","c","lua","vim","python","javascript","typescript",
          "html","css","json","yaml","markdown","markdown_inline",
        },
        highlight   = { enable = true },
        textobjects = {
          select = {
            enable  = true,
            keymaps = {
              ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",  ["if"] = "@function.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start = { ["]a"] = "@parameter.outer", ["]f"] = "@function.outer" },
            goto_next_end   = { ["]A"] = "@parameter.outer", ["]F"] = "@function.outer" },
            goto_prev_start = { ["[a"] = "@parameter.outer", ["[f"] = "@function.outer" },
            goto_prev_end   = { ["[A"] = "@parameter.outer", ["[F"] = "@function.outer" },
          },
        },
      })
    end,
  },

  ---------------------------------------------------------------------
  -- Commenting -------------------------------------------------------
  ---------------------------------------------------------------------
  { "tpope/vim-commentary", event = "VeryLazy" },

  ---------------------------------------------------------------------
  -- LSP / Completion (lsp-zero v1) ----------------------------------
  ---------------------------------------------------------------------
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v1.x",
    lazy   = false,
    dependencies = {
      -- LSP core
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", version = "1.*" }, -- ← pin to v1
      -- Completion
      "hrsh7th/nvim-cmp",         "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",       "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lua",
      -- Snippets
      "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets",
    },
    config = function()
      -----------------------------------------------------------------
      -- basic lsp-zero setup ----------------------------------------
      -----------------------------------------------------------------
      local lsp = require("lsp-zero").preset("recommended")

      lsp.ensure_installed({ "pylsp", "clangd", "lua_ls" })

      -- use the modern name 'lua_ls'
      lsp.configure("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
      })

      lsp.set_preferences({
        suggest_lsp_servers = false,
        sign_icons = { error = "E", warn = "W", hint = "H", info = "I" },
      })

      lsp.on_attach(function(_, bufnr)
        local map  = vim.keymap.set
        local opts = { buffer = bufnr, remap = false }

        map("n", "<space>,", vim.diagnostic.goto_prev,      opts)
        map("n", "<space>;", vim.diagnostic.goto_next,      opts)
        map("n", "<space>a", vim.lsp.buf.code_action,       opts)
        map("n", "<space>d", vim.lsp.buf.definition,        opts)
        map("n", "<space>f", vim.lsp.buf.format,            opts)
        map("n", "<space>h", vim.lsp.buf.hover,             opts)
        map("n", "<space>m", vim.lsp.buf.rename,            opts)
        map("n", "<space>r", vim.lsp.buf.references,        opts)
        map("n", "<space>s", vim.lsp.buf.document_symbol,   opts)
      end)

      lsp.setup()
      vim.diagnostic.config({ virtual_text = true })
    end,
  },

  ---------------------------------------------------------------------
  -- OSC-52 clipboard -------------------------------------------------
  ---------------------------------------------------------------------
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({ trim = true })

      local function copy(lines, _)
        require("osc52").copy(table.concat(lines, "\n"))
      end
      local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end

      vim.g.clipboard = {
        name  = "osc52",
        copy  = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }

      vim.keymap.set("n", "<leader>c", '"+y')
      vim.keymap.set("n", "<leader>cc", '"+yy')
      vim.keymap.set("v", "<leader>c", require("osc52").copy_visual)
    end,
  },

  ---------------------------------------------------------------------
  -- Buffer helpers ---------------------------------------------------
  ---------------------------------------------------------------------
  {
    "ojroques/nvim-bufbar",
    config = function()
      require("bufbar").setup({
        modifier      = "full",
        term_modifier = "full",
        show_flags    = false,
      })
    end,
  },
  {
    "ojroques/nvim-bufdel",
    config = function()
      require("bufdel").setup({ next = "alternate", quit = false })
      vim.keymap.set("n", "<leader>w", "<cmd>BufDel<CR>")
    end,
  },
  {
    "ojroques/nvim-hardline",
    config = function()
      require("hardline").setup({})
    end,
  },
})

