return {
    'neovim/nvim-lspconfig',
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
        require('mason').setup()

        vim.diagnostic.config({
            virtual_lines = true,
            underline = false,
            severity_sort = true,
        })

        -- Configure each language server.
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.fn.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim', 'MiniDeps' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = { vim.env.VIMRUNTIME },
                    },
                    telemetry = {
                        enable = false,
                    }
                }
            }
        })

        vim.lsp.config('powershell_es', {
            bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services'
        })

        vim.lsp.config('pyright', {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "off"
                    }
                }
            },
        })

        vim.lsp.enable({
            'lua_ls',
            'html',
            'jsonls',
            'cssls',
            -- 'csharp_ls', -- Copilot is very slow in C# files. Too slow.
            'powershell_es',
            'pyright',
            'ts_ls',
            'vimls'
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client then
                    if client:supports_method('textDocument/completions') then
                        vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
                    end
                end
            end
        })
    end,
    cond = not vim.g.vscode,
}
