local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-2),
		["<C-f>"] = cmp.mapping.scroll_docs(2),
		["<C-Space>"] = cmp.mapping.complete({}),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "ultisnips" },
		{ name = "emmet_vim" },
		{ name = "path" },
	},
})
