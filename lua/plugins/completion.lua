return {
    'hrsh7th/nvim-cmp',
    event = {'InsertEnter', 'CmdlineEnter'},
    dependencies = {
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
        'zbirenbaum/copilot-cmp',
        'PhilRunninger/cmp-rpncalc',
    },
    config = function()
        local cmp = require('cmp')
        local ls = require('luasnip')
        require("luasnip/loaders/from_vscode").lazy_load()

        local kind_icons = {
            copilot = '🛪',
            nvim_lsp = '👓',
            luasnip = '✀',
            rpncalc = '󰎠',

            Text = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰇽",
            Variable = "󰂡",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰅲",
        }

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
                ["<Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif ls.locally_jumpable(1) then
                            ls.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s", }
                ),
                ["<S-Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif ls.locally_jumpable(1) then
                            ls.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s", }
                ),
                ["<CR>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            if ls.expandable() then
                                ls.expand()
                            elseif cmp.get_active_entry() then
                                cmp.confirm({ select = false, })
                            else
                                fallback()
                            end
                        else
                            fallback()
                        end
                    end, { "i", "c" }
                ),
                ["<Space>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ select = false, })
                            vim.fn.feedkeys(" ")
                        else
                            fallback()
                        end
                    end, { "i", "c" }
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
            }),
            formatting = {
                format = function(entry, vim_item)
                    vim_item.icon = kind_icons[entry.source.name] or vim_item.icon
                    vim_item.kind = ({
                        copilot = '[Copilot]',
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[Lua]',
                        luasnip = '[Snippet]',
                        buffer = '[Buffer]',
                        path = '[Path]',
                        rpncalc = '[RPN]',
                    })[entry.source.name] or '[Text]'
                    return vim_item
                end
            },
        })
    end,
}
