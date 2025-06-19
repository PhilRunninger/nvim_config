local lspconfig = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup()

-- Tweak the UI for diagnostics' signs and floating windows.
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs, },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = { focusable = false, style = "minimal", border = "rounded", source = true, header = "", prefix = "", },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", })

-- Map keys after language server attaches to current buffer.
local map_keys = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Configure each language server.
lspconfig.cssls.setup({ on_attach = map_keys })

lspconfig.erlangls.setup({})

lspconfig.html.setup({ on_attach = map_keys })

lspconfig.jsonls.setup({ on_attach = map_keys })

lspconfig.lua_ls.setup({
    on_attach = map_keys,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                }
            }
        }
    }
})

lspconfig.omnisharp.setup({
    on_attach = map_keys,
    cmd = { 'dotnet', vim.fn.stdpath('data') .. '/lsp_servers/omnisharp/omnisharp' },
})

lspconfig.powershell_es.setup({
    on_attach = map_keys,
    bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services'
})

lspconfig.pyright.setup({
    on_attach = map_keys,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off"
            }
        }
    },
})

lspconfig.ts_ls.setup({ on_attach = map_keys })

lspconfig.vimls.setup({ on_attach = map_keys })
