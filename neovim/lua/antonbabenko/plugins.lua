-----------------------------------------------------------------------
-- 1. Bootstrap lazy.nvim --------------------------------------------
-----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------
-- 2. Plugin specification -------------------------------------------
-----------------------------------------------------------------------
require("lazy").setup({

	---------------------------------------------------------------------
	-- Telescope --------------------------------------------------------
	---------------------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = vim.fn.executable("make") == 1,
			},
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = { mappings = { i = { ["<esc>"] = actions.close } } },
			})
			pcall(telescope.load_extension, "fzf")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},

	---------------------------------------------------------------------
	-- colourscheme -----------------------------------------
	---------------------------------------------------------------------
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("catppuccin-mocha")
	-- 	end,
	-- },
    {
        "vague-theme/vague.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other plugins
        config = function()
            -- NOTE: you do not need to call setup if you don't want to.
            require("vague").setup({
                -- optional configuration here
            })
            vim.cmd("colorscheme vague")
        end
    },

	---------------------------------------------------------------------
	-- Treesitter -------------------------------------------------------
	---------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"lua",
					"vim",
					"python",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"yaml",
					"markdown",
					"markdown_inline",
				},
				highlight = { enable = true },
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
						},
					},
					move = {
						enable = true,
						goto_next_start = { ["]a"] = "@parameter.outer", ["]f"] = "@function.outer" },
						goto_next_end = { ["]A"] = "@parameter.outer", ["]F"] = "@function.outer" },
						goto_prev_start = { ["[a"] = "@parameter.outer", ["[f"] = "@function.outer" },
						goto_prev_end = { ["[A"] = "@parameter.outer", ["[F"] = "@function.outer" },
					},
				},
			})
		end,
	},

	{ "tpope/vim-commentary", event = "VeryLazy" },

	---------------------------------------------------------------------
	-- Mason + LSP ------------------------------------------------------
	---------------------------------------------------------------------
	{ "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

	{
		"williamboman/mason-lspconfig.nvim",
		version = "^2",
		dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			-- 1. capabilities ----------------------------------------------------
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			-- 2. on_attach -------------------------------------------------------
			local function on_attach(client, bufnr) -- <-- keep client!
				local map, opts = vim.keymap.set, { buffer = bufnr, silent = true }

				map("n", "<space>,", vim.diagnostic.goto_prev, opts)
				map("n", "<space>;", vim.diagnostic.goto_next, opts)
				map("n", "<space>a", vim.lsp.buf.code_action, opts)
				map("n", "<space>d", vim.lsp.buf.definition, opts)
				map("n", "<space>h", vim.lsp.buf.hover, opts)
				map("n", "<space>m", vim.lsp.buf.rename, opts)
				map("n", "<space>r", vim.lsp.buf.references, opts)
				map("n", "<space>s", vim.lsp.buf.document_symbol, opts)
				map("n", "<leader>f", vim.lsp.buf.format, opts)
			end

			-- 3. servers ---------------------------------------------------------
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
						},
					},
				},
				clangd = {},
				pylsp = {},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = true,
			})

			local lspconfig = require("lspconfig")
			for name, opts in pairs(servers) do
				opts.capabilities = capabilities
				opts.on_attach = on_attach
				lspconfig[name].setup(opts)
			end

			-- 4. diagnostics look ----------------------------------------------
			vim.diagnostic.config({
				virtual_text = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "E",
						[vim.diagnostic.severity.WARN] = "W",
						[vim.diagnostic.severity.INFO] = "I",
						[vim.diagnostic.severity.HINT] = "H",
					},
				},
			})
		end,
	},

	---------------------------------------------------------------------
	-- Completion -------------------------------------------------------
	---------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp, luasnip = require("cmp"), require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(a)
						luasnip.lsp_expand(a.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fb)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fb()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fb)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fb()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "nvim_lua" } },
					{ { name = "buffer" }, { name = "path" } }
				),
			})
		end,
	},

	---------------------------------------------------------------------
	-- Formatter / linter bridge ---------------------------------------
	---------------------------------------------------------------------
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		config = function()
			local nls = require("null-ls") -- module name is still 'null-ls'
			nls.setup({
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.black,
					nls.builtins.diagnostics.ruff,
					nls.builtins.formatting.isort,
					nls.builtins.formatting.clang_format,
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
		opts = {
			automatic_installation = true,
			ensure_installed = { "stylua", "black", "ruff", "isort", "clang-format" },
		},
	},

	---------------------------------------------------------------------
	-- Buffer helpers & statusline -------------------------------------
	---------------------------------------------------------------------
	{
		"ojroques/nvim-bufbar",
		config = function()
			require("bufbar").setup({ modifier = "full", term_modifier = "full", show_flags = false })
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
