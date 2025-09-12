-- vim:foldmethod=marker

-- Helper functions  {{{1
local g = vim.g
local map = vim.api.nvim_set_keymap
local noremapSilent = { noremap = true, silent = true }
local noremap = { noremap = true }

-- mini.nvim         - https://github.com/nvim-mini/mini.nvim  {{{1
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

--   mini.notify  {{{2
later(function()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
end)

--   mini.icons  {{{2
later(function() require('mini.icons').setup() end)

--   mini.ai  {{{2
later(function() require('mini.ai').setup() end)

--   mini.comment  {{{2
later(function() require('mini.comment').setup() end)

--   mini.cursorword  {{{2
require('mini.cursorword').setup()

--   mini.hipatterns  {{{2
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

--   mini.pick  {{{2
later(function()
    require('mini.pick').setup()
    map('n', '<leader>b', ':Pick buffers<CR>', noremapSilent)
    map('n', '<F1>', ':Pick help<CR>', noremapSilent)
    map('n', '<leader>g', ':Pick grep_live<CR>', noremapSilent)
end)

--   mini.extra  {{{2
later(function() require('mini.extra').setup() end)

--   mini.align  {{{2
later(function()
    require('mini.align').setup({
        mappings = {
            start = '' -- Keeps 'ga' assigned to the Unicode plugin.
        }
    })
end)

--   mini.operators  {{{2
later(function() require('mini.operators').setup() end)

--   mini.completion  {{{2
later(function()
    require('mini.completion').setup()
    vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
    vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})
    vim.keymap.set('i', '<CR>',    [[pumvisible() ? "\<C-y>" : "\<CR>"]], {expr = true})
end)

--   mini.snippets  {{{2
later(function()
    add({source = 'rafamadriz/friendly-snippets'})
    local gen_loader = require('mini.snippets').gen_loader
    require('mini.snippets').setup({
        snippets = {
            gen_loader.from_file(vim.fn.glob(path_package..'**/friendly-snippets/snippets/global.json',false,true)[1]),
            gen_loader.from_lang(),
        },
    })
    MiniSnippets.start_lsp_server({ match = false })
end)

--   mini.surround  {{{2
later(function()
    -- Use tpope's mappings to preserve nvim's `s` operator without delays.
    require('mini.surround').setup({
        mappings = {
            add = 'ys',
            delete = 'ds',
            replace = 'cs',
            find = '', find_left = '', highlight = '', update_n_lines = ''
        }
    })
end)

--   mini.diff  {{{2
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign',
            signs = { add = '+', change = '↻', delete = '-' }
        }
    })
end)

--   mini.git  {{{2
later(function() require('mini.git').setup() end)

--   mini.files  {{{2
later(function()
    require('mini.files').setup({
        windows = {
            max_number = math.huge, -- Maximum number of windows to show side by side
            preview = true,         -- Whether to show preview of file/directory under cursor
            width_focus = 40,       -- Width of focused window
            width_nofocus = 15,     -- Width of non-focused window
            width_preview = 60,     -- Width of preview window
        }
    })
    vim.api.nvim_set_keymap('n', '<leader>o', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })

    local set_mark = function(id, path, desc)
        MiniFiles.set_bookmark(id, path, { desc = desc })
    end
    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesExplorerOpen',
        callback = function()
            set_mark('n', vim.fn.stdpath('config'), 'Config') -- path
            set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
            set_mark('h', '~', 'Home directory')
            set_mark('s', '~/source', 'My source code')
        end,
    })
end)

-- Disable built-in stuff I don't use.  {{{1
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0

g.loaded = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1


-- LSP               - https://github.com/neovim/nvim-lspconfig, ... {{{1
--                   - https://github.com/mason-org/mason.nvim, ...
--                   - https://github.com/mason-org/mason-lspconfig.nvim
now(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = { 'mason-org/mason.nvim', 'mason-org/mason-lspconfig.nvim' },
    })

    local lspconfig = require('lspconfig')
    require('mason').setup()
    require('mason-lspconfig').setup()

    -- Tweak the UI for diagnostics' signs and floating windows.
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
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
        float = { focusable = false, border = "rounded", source = true, header = "", prefix = "", },
    })

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
        vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, bufopts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, bufopts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    end

    -- Configure each language server.
    lspconfig.cssls.setup({ on_attach = map_keys })

    lspconfig.erlangls.setup({})

    lspconfig.html.setup({ on_attach = map_keys })

    lspconfig.jsonls.setup({ on_attach = map_keys })

    vim.lsp.config('lua_ls', {
        on_attach = map_keys,
        on_init = function(client)
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = {
            Lua = {}
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
end)

-- Treesitter        - https://github.com/nvim-treesitter/nvim-treesitter  {{{1
later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use 'master' while monitoring updates in 'main'
        checkout = 'master',
        monitor = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    -- Possible to immediately execute code which depends on the added plugin
    require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'html', 'css', 'typescript', 'javascript', 'tsx', 'java', 'c_sharp', 'powershell', 'json', 'markdown', 'gitcommit' },
        highlight = { enable = true },
    })
end)

-- AutoTag           - https://github.com/windwp/nvim-ts-autotag   {{{1
add({
    source = 'windwp/nvim-ts-autotag'
})
require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false
    }
})

-- CSV               - https://github.com/chrisbra/csv.vim  {{{1
later(function()
    add({ source = 'chrisbra/csv.vim' })
    g.no_csv_maps = 1
end)

-- Fugitive          - https://github.com/tpope/vim-fugitive  {{{1
later(function()
    add({ source = 'tpope/vim-fugitive' })
    map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
    map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
    map('n', '<leader>G', ':Git<CR>', noremapSilent)
end)

-- Markdown          - https://github.com/tpope/vim-markdown  {{{1
g.markdown_folding = 1
g.markdown_fenced_languages = { 'vim', 'sql', 'cs', 'ps1', 'lua', 'json' }

-- Matchup           - https://github.com/andymass/vim-matchup  {{{1
add({ source = 'andymass/vim-matchup'})
g.matchup_matchparen_offscreen = {method='popup'}

-- REST Console      - https://github.com/Aadniz/vim-rest-console  {{{1
later(function()
    add({ source = 'Aadniz/vim-rest-console' })
    g.vrc_curl_timeout = '0'
    g.vrc_response_default_content_type = 'application/json'
    g.vrc_show_command = 1
    g.vrc_trigger = '<F5>'
end)

-- Undo Tree         - https://github.com/mbbill/undotree  {{{1
later(function()
    add({ source = 'mbbill/undotree' })
    map('n', '<leader>u', ':UndotreeToggle<CR>', noremapSilent)
    g.undotree_WindowLayout = 2
    g.undotree_HelpLine = 0
    g.undotree_ShortIndicators = 1
    g.undotree_TreeNodeShape = '●'
    g.undotree_TreeVertShape = '│'
    g.undotree_TreeSplitShape = '╱'
    g.undotree_TreeReturnShape = '╲'
    g.undotree_SetFocusWhenToggle = 1
end)

-- Unicode           - https://github.com/chrisbra/unicode.vim  {{{1
later(function()
    add({ source = 'chrisbra/unicode.vim' })
    map('n', 'ga', ':UnicodeName<CR>', noremapSilent)
    map('n', '<leader>ga', ':UnicodeSearch!<space>', noremap)
    g.Unicode_no_default_mappings = 1
end)

-- SQL               - https://github.com/PhilRunninger/sql.nvim  {{{1
-- cmd('packadd! sql.nvim')
-- map('n', '<F8>', ':SQL<CR>', noremapSilent)

-- Wiki              - https://github.com/lervag/wiki.vim  {{{1
later(function()
    add({ source = 'lervag/wiki.vim' })
    g.wiki_root = '~/Documents/wiki'
end)

-- Markdown Preview  - https://github.com/iamcco/markdown-preview.nvim  {{{1
later(function() add({ source = 'iamcco/markdown-preview.nvim' }) end)

-- Recover           - https://github.com/chrisbra/Recover.vim  {{{1
later(function() add({ source = 'chrisbra/Recover.vim' }) end)

-- Exchange          - https://github.com/tommcdo/vim-exchange  {{{1
later(function() add({ source = 'tommcdo/vim-exchange' }) end)

-- Repeat            - https://github.com/tpope/vim-repeat  {{{1
later(function() add({ source = 'tpope/vim-repeat' }) end)

-- Signature         - https://github.com/kshenoy/vim-signature  {{{1
later(function() add({ source = 'kshenoy/vim-signature' }) end)
