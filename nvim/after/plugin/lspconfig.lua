local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()
local Remap = require("mmm.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local sumneko_root_path = "/home/work/.local/bin"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require 'cmp'.setup {
    sources = {
        { name = 'nvim_lsp_signature_help' }
    }
}
-- Setup nvim-cmp.
local cmp = require("cmp")
-- local source_mapping = {
-- 	buffer = "[Buffer]",
-- 	nvim_lsp = "[LSP]",
-- 	nvim_lua = "[Lua]",
-- 	luasnip  = "[Snip]",
-- 	path = "[Path]",
-- }
local lspkind = require("lspkind")

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            -- vim.fn["vsnip#anonymous"](args.body)

            -- For `luasnip` user.
            require("luasnip").lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-b>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        --       ['<CR>'] = cmp.mapping.confirm {
        --          behavior = cmp.ConfirmBehavior.Replace,
        --          select = true,
        --      },
        ['`'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<`>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    }),
    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                luasnip = "[Snip]",
                buffer = "[Buff]",
                path = "[path]",
            },
        },
    },

    -- formatting = {
    -- 	format = function(entry, vim_item)
    -- 		vim_item.kind = lspkind.presets.default[vim_item.kind]
    -- 		local menu = source_mapping[entry.source.name]
    -- 		if entry.source.name == "cmp_tabnine" then
    -- 			if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
    -- 				menu = entry.completion_item.data.detail .. " " .. menu
    -- 			end
    -- 			vim_item.kind = ""
    -- 		end
    -- 		vim_item.menu = menu
    -- 		return vim_item
    -- 	end,
    -- },

    sources = {

        { name = "nvim_lsp" },

        -- For vsnip user.
        -- { name = 'vsnip' },

        -- For luasnip user.
        { name = "luasnip" },

        -- For ultisnips user.
        -- { name = 'ultisnips' },

        { name = "buffer" },
        { name = "path" },

    },
})


-- local function config(_config)
-- 	return vim.tbl_deep_extend("force", {
-- 		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
-- 		on_attach = function()
-- 			nnoremap("gd", function() vim.lsp.buf.definition() end)
-- 			nnoremap("K", function() vim.lsp.buf.hover() end)
-- 			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
-- 			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
-- 			nnoremap("[d", function() vim.diagnostic.goto_next() end)
-- 			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
-- 			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
-- 			nnoremap("<leader>vco", function() vim.lsp.buf.code_action({
--                 filter = function(code_action)
--                     if not code_action or not code_action.data then
--                         return false
--                     end

--                     local data = code_action.data.id
--                     return string.sub(data, #data - 1, #data) == ":0"
--                 end,
--                 apply = true
--             }) end)
-- 			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
-- 			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
-- 			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
-- 		end,
-- 	}, _config or {})
-- end


require("lspconfig").tsserver.setup({
    capabilities = capabilities,
})
require("lspconfig").tailwindcss.setup({
    capabilities = capabilities,
})



-- who even uses this?
require("lspconfig").rust_analyzer.setup({
    -- cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    capabilities = capabilities,
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    }
    -- settings = {
    -- ["rust-analyzer"] = {
    -- cargo = {
    -- allFeatures = true,
    -- },
    -- completion = {
    -- postfix = {
    --  enable = false,
    -- },
    -- },
    -- },
    -- },
    --[[
    --
    --]]
})

require("lspconfig").sumneko_lua.setup({
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
        },
    },
})

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require("symbols-outline").setup(opts)

-- local snippets_paths = function()
-- 	local plugins = { "friendly-snippets" }
-- 	local paths = {}
-- 	local path
-- 	local root_path = vim.env.HOME .. "/.vim/plugged/"
-- 	for _, plug in ipairs(plugins) do
-- 		path = root_path .. plug
-- 		if vim.fn.isdirectory(path) ~= 0 then
-- 			table.insert(paths, path)
-- 		end
-- 	end
-- 	return paths
-- end

-- require("luasnip.loaders.from_vscode").lazy_load({
-- 	paths = snippets_paths(),
-- 	include = nil, -- Load all languages
-- 	exclude = {},
-- })
