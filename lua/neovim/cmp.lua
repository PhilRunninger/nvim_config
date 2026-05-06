local cmp = require('cmp')
local ls = require('luasnip')

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_vscode").lazy_load({paths={"./snippets"}})

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable,
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<Space>"] = cmp.mapping.confirm { select = false },
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif ls.expandable() then
                    ls.expand()
                elseif ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s", }
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif ls.jumpable(-1) then
                    ls.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", }
        ),
    },
    sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua'},
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'rpncalc' },
    })
})
