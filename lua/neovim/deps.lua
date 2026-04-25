-- vim:foldmethod=marker

-- Module Shortcuts  {{{1
local g = vim.g

local map = function(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {noremap=true, silent=true})
end

-- mini.nvim         - https://github.com/nvim-mini/mini.nvim  {{{1
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.fn.isdirectory(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, later = MiniDeps.add, MiniDeps.later

--   mini.notify  {{{2
require('mini.notify').setup()
vim.notify = require('mini.notify').make_notify()

--   mini.icons  {{{2
later(function() require('mini.icons').setup() end)

--   mini.ai  {{{2
later(function() require('mini.ai').setup() end)

--   mini.comment  {{{2
later(function() require('mini.comment').setup() end)

--   mini.cursorword  {{{2
later(function() require('mini.cursorword').setup() end)

--   mini.extra  {{{2
later(function() require('mini.extra').setup() end)

--   mini.align  {{{2
later(function()
    require('mini.align').setup({
        mappings = {
            start = 'gl',
            start_with_preview = 'gL'
        }
    })
end)

--   mini.surround  {{{2
later(function()
    require('mini.surround').setup({
        -- Use tpope's mappings to preserve nvim's `s` operator without delays.
        mappings = {
            add = 'ys',
            delete = 'ds',
            replace = 'cs',
            find = '',
            find_left = '',
            highlight = '',
            update_n_lines = ''
        }
    })
end)

--   mini.diff  {{{2
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign',
            signs = { add = '▌', change = '█', delete = '▐' }
        }
    })
end)

-- Completion        - https://github.com/hrsh7th/nvim-cmp   {{{1
--                     - https://github.com/L3MON4D3/LuaSnip
--                     - https://github.com/rafamadriz/friendly-snippets
--                     - https://github.com/saadparwaiz1/cmp_luasnip
--                     - https://github.com/hrsh7th/cmp-path
--                     - https://github.com/hrsh7th/cmp-buffer
--                     - https://github.com/hrsh7th/cmp-nvim-lsp
--                     - https://github.com/hrsh7th/cmp-nvim-lua
--                     - https://github.com/PhilRunninger/cmp-rpncalc
later(function()
    add({
        source = 'hrsh7th/nvim-cmp',
        depends = {
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'PhilRunninger/cmp-rpncalc' }})
    require('neovim.cmp')
end)

-- BufSelect         - https://github.com/PhilRunninger/bufselect  {{{1
later(function()
    add({ source = 'PhilRunninger/bufselect' })
    vim.fn['bufselect#settings']({
        mappings={delete='w', open='l', gopen='gl'},
        win={config={border='rounded', title='Buffers', title_pos='center'}, hl='NormalFloat:Normal'}})
    map('n', '<leader>b', ':ShowBufferList<CR>')
end)

-- Vifm              - https://github.com/vifm/vifm.vim  {{{1
later(function()
    add({ source = 'vifm/vifm.vim' })
    g.vifm_exec_args = '-c "source ' .. vim.fn.escape(vim.fn.stdpath('config') .. '/vifm.vim.rc', '\\') .. '"'
    map('n', '<leader>o', ':Vifm<CR>')
end)

-- CSV               - https://github.com/chrisbra/csv.vim  {{{1
later(function()
    add({ source = 'chrisbra/csv.vim' })
    g.no_csv_maps = 1
    g.csv_default_delim = ','
end)

-- Fugitive          - https://github.com/tpope/vim-fugitive  {{{1
add({ source = 'tpope/vim-fugitive' })
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>')
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>')

-- Markdown          - https://github.com/tpope/vim-markdown  {{{1
g.markdown_folding = 1
g.markdown_fenced_languages = { 'vim', 'sql', 'cs', 'ps1', 'lua', 'json', 'mermaid' }

-- Markdown Preview  - https://github.com/wardenclyffetower/markdown-preview.nvim.git  {{{1
later(function()
    add({ source = 'wardenclyffetower/markdown-preview.nvim' })
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_page_title = '${name}'
    vim.g.mkdp_combine_preview = 1
end)

-- Colorizer         - https://github.com/NvChad/nvim-colorizer.lua   {{{1
later(function()
    add({ source = 'NvChad/nvim-colorizer.lua' })
    require('colorizer').setup()
end)

-- Mermaid           - https://github.com/mracos/mermaid.vim.git  {{{1
later(function() add({ source = 'mracos/mermaid.vim' }) end)

-- Matchup           - https://github.com/andymass/vim-matchup  {{{1
later(function()
    add({ source = 'andymass/vim-matchup' })
    g.matchup_matchparen_offscreen = { method = 'popup' }
end)

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
    g.undotree_WindowLayout = 2
    g.undotree_HelpLine = 0
    g.undotree_ShortIndicators = 1
    g.undotree_TreeNodeShape = '●'
    g.undotree_TreeVertShape = '│'
    g.undotree_TreeSplitShape = '╱'
    g.undotree_TreeReturnShape = '╲'
    g.undotree_SetFocusWhenToggle = 1
    map('n', '<leader>u', ':UndotreeToggle<CR>')
end)

-- Unicode           - https://github.com/chrisbra/unicode.vim  {{{1
later(function()
    add({ source = 'chrisbra/unicode.vim' })
    map('n', 'ga', ':UnicodeName<CR>')
    map('n', '<leader>ga', ':UnicodeSearch!<space>', {noremap = true})
    g.Unicode_no_default_mappings = 1
end)

-- SQL               - https://github.com/PhilRunninger/sql.nvim  {{{1
add({ source = 'PhilRunninger/sql.nvim' })

-- RPN               - https://github.com/PhilRunninger/cmp-rpncalc  {{{1
later(function()
    add({ source = 'PhilRunninger/cmp-rpncalc' })
    map("n", "<F12>",   ":RPN<CR>",            {noremap=true})
    map("n", "<S-F12>", ":RPN!<CR>",           {noremap=true})
    map("x", "<F12>",   ":<C-U>'<,'>RPN<CR>",  {noremap=true})
    map("x", "<S-F12>", ":<C-U>'<,'>RPN!<CR>", {noremap=true})
end)

-- Dear Diary        - https://github.com/ishchow/nvim-deardiary  {{{1
later(function()
    add({ source = 'ishchow/nvim-deardiary' })
    require("deardiary.config").journals = {
        {
            path = os.getenv('DIARY') or '~/Documents/Diary',
            frequencies = {
                weekly = {
                    formatpath = function(entry_date)
                        local week_start = entry_date:copy():adddays(1 - entry_date:getweekday())
                        local filename = string.format('%02d - %s.md', entry_date:getweeknumber(), week_start:fmt('%B %d'))
                        return require("deardiary.util").join_path({"weekly", entry_date:getyear(),  filename})
                    end,
                    template = function(entry_date)
                        local week_start = entry_date:copy():adddays(1 - entry_date:getweekday())
                        return week_start:fmt('# Week of %B %d, %Y') .. '\n\n' ..
                            '## Cards\n\n' ..
                            '## Training\n\n' ..
                            '## Other'
                    end
                }
            }
        }
    }
    require('deardiary').set_current_journal(1)
    vim.g.deardiary_use_default_mappings = 0
    map("n", "<leader>j", ":DearDiaryThisWeek<CR>", {noremap=true})
end)

-- Recover           - https://github.com/chrisbra/Recover.vim  {{{1
add({ source = 'chrisbra/Recover.vim' })

-- Exchange          - https://github.com/tommcdo/vim-exchange  {{{1
later(function() add({ source = 'tommcdo/vim-exchange' }) end)

-- Signature         - https://github.com/kshenoy/vim-signature  {{{1
later(function() add({ source = 'kshenoy/vim-signature' }) end)

-- Copilot           - https://github.com/github/copilot.vim {{{1
--                   - https://github.com/CopilotC-Nvim/CopilotChat.nvim
--                   - https://github.com/nvim-lua/plenary.nvim
later(function()
    add({ source = 'github/copilot.vim' })
    add({ source = 'CopilotC-Nvim/CopilotChat.nvim',
        depends = {'nvim-lua/plenary.nvim' }
    })
    vim.g.copilot_filetypes = {
        markdown = true,
    }
end)


-- LSP               - https://github.com/neovim/nvim-lspconfig, ... {{{1
--                   - https://github.com/mason-org/mason.nvim, ...
later(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = { 'mason-org/mason.nvim' }
    })

    require('mason').setup()

    vim.diagnostic.config({
        virtual_lines = true,
        underline = false,
        severity_sort = true,
    })

    -- Configure each language server.
    vim.lsp.config('lua_ls', {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

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

    require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'html', 'css', 'typescript', 'javascript', 'tsx', 'java', 'c_sharp', 'powershell', 'json', 'markdown', 'mermaid', 'gitcommit', 'diff', 'git_rebase' },
        highlight = { enable = true },
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
