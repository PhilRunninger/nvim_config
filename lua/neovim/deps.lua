-- vim:foldmethod=marker

-- Module Shortcuts  {{{1
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

local add = MiniDeps.add

--   mini.notify  {{{2
require('mini.notify').setup()
vim.notify = require('mini.notify').make_notify()

--   mini.icons  {{{2
require('mini.icons').setup()

--   mini.ai  {{{2
require('mini.ai').setup()

--   mini.comment  {{{2
require('mini.comment').setup()

--   mini.cursorword  {{{2
require('mini.cursorword').setup()

--   mini.hipatterns  {{{2
require('mini.hipatterns').setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
})

--   mini.pick  {{{2
require('mini.pick').setup()
map('n', '<leader>f', ':Pick files<CR>', noremapSilent)
map('n', '<leader>b', ':Pick buffers<CR>', noremapSilent)
map('n', '<leader>g', ':Pick grep_live<CR>', noremapSilent)
map('n', '<F1>', ':Pick help<CR>', noremapSilent)

--   mini.extra  {{{2
require('mini.extra').setup()

--   mini.align  {{{2
require('mini.align').setup({
    mappings = {
        start = 'gl',
        start_with_preview = 'gL'
    }
})

--   mini.completion  {{{2
require('mini.completion').setup()
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})
vim.keymap.set('i', '<CR>',    [[pumvisible() ? "\<C-y>" : "\<CR>"]], {expr = true})

--   mini.snippets  {{{2
add({ source = 'rafamadriz/friendly-snippets' })
local snippets = require('mini.snippets')
require('mini.snippets').setup({
    snippets = {
        snippets.gen_loader.from_file(vim.fn.glob(path_package .. '**/friendly-snippets/snippets/global.json', false, true)[1]),
        snippets.gen_loader.from_lang(),
    },
    mappings = {expand = '', jump_next = '<Tab>', jump_prev = '<S-Tab>'},
})
MiniSnippets.start_lsp_server({ match = false })

--   mini.surround  {{{2
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

--   mini.diff  {{{2
require('mini.diff').setup({
    view = {
        style = 'sign',
        signs = { add = '+', change = '↻', delete = '-' }
    }
})

--   mini.git  {{{2
require('mini.git').setup()

--   mini.files  {{{2
require('mini.files').setup({
    mappings = {
        close = '<Esc'
    },
    windows = {
        max_number = math.huge, -- Maximum number of windows to show side by side
        preview = true,         -- Whether to show preview of file/directory under cursor
        width_focus = 40,       -- Width of focused window
        width_nofocus = 15,     -- Width of non-focused window
        width_preview = 60,     -- Width of preview window
    },
})
vim.api.nvim_set_keymap('n', '<leader>o', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })

-- Setup mappings to open files in split windows/tabs.
local map_split = function(buf_id, lhs, direction)
    local rhs = function()
        -- Make new window and set it as target
        local cur_target = MiniFiles.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target)
        MiniFiles.go_in()
    end

    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, '<C-s>', 'horizontal')
        map_split(buf_id, '<C-v>', 'vertical')
        map_split(buf_id, '<C-t>', 'tab')
    end,
})

-- Create bookmarks. I wish this could be done by user, not by code.
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

-- Copilot           - https://github.com/github/copilot.vim {{{1
add({ source = 'github/copilot.vim' })

-- LSP               - https://github.com/neovim/nvim-lspconfig, ... {{{1
--                   - https://github.com/mason-org/mason.nvim, ...
--                   - https://github.com/mason-org/mason-lspconfig.nvim
add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'mason-org/mason.nvim', 'mason-org/mason-lspconfig.nvim' },
})

require('mason').setup()
require('mason-lspconfig').setup()

vim.diagnostic.config({
    virtual_lines = true,
    underline = false,
    severity_sort = true,
})

-- Configure each language server.
vim.lsp.config('lua_ls', {
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

-- Treesitter        - https://github.com/nvim-treesitter/nvim-treesitter  {{{1
add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'html', 'css', 'typescript', 'javascript', 'tsx', 'java', 'c_sharp', 'powershell', 'json', 'markdown', 'gitcommit', 'diff', 'git_rebase' },
    highlight = { enable = true },
})

-- CSV               - https://github.com/chrisbra/csv.vim  {{{1
add({ source = 'chrisbra/csv.vim' })
g.no_csv_maps = 1

-- Fugitive          - https://github.com/tpope/vim-fugitive  {{{1
add({ source = 'tpope/vim-fugitive' })
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('n', '<leader>G', ':Git<CR>', noremapSilent)

-- Markdown          - https://github.com/tpope/vim-markdown  {{{1
g.markdown_folding = 1
g.markdown_fenced_languages = { 'vim', 'sql', 'cs', 'ps1', 'lua', 'json' }

-- Matchup           - https://github.com/andymass/vim-matchup  {{{1
add({ source = 'andymass/vim-matchup' })
g.matchup_matchparen_offscreen = { method = 'popup' }

-- REST Console      - https://github.com/Aadniz/vim-rest-console  {{{1
add({ source = 'Aadniz/vim-rest-console' })
g.vrc_curl_timeout = '0'
g.vrc_response_default_content_type = 'application/json'
g.vrc_show_command = 1
g.vrc_trigger = '<F5>'

-- Undo Tree         - https://github.com/mbbill/undotree  {{{1
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

-- Unicode           - https://github.com/chrisbra/unicode.vim  {{{1
add({ source = 'chrisbra/unicode.vim' })
map('n', 'ga', ':UnicodeName<CR>', noremapSilent)
map('n', '<leader>ga', ':UnicodeSearch!<space>', noremap)
g.Unicode_no_default_mappings = 1

-- SQL               - https://github.com/PhilRunninger/sql.nvim  {{{1
add({ source = 'PhilRunninger/sql.nvim' })

-- RPN               - https://github.com/PhilRunninger/cmp-rpncalc  {{{1
add({ source = 'PhilRunninger/cmp-rpncalc' })
vim.api.nvim_set_keymap("n", "<F12>",   ":RPN<CR>",            {noremap=true})
vim.api.nvim_set_keymap("n", "<S-F12>", ":RPN!<CR>",           {noremap=true})
vim.api.nvim_set_keymap("x", "<F12>",   ":<C-U>'<,'>RPN<CR>",  {noremap=true})
vim.api.nvim_set_keymap("x", "<S-F12>", ":<C-U>'<,'>RPN!<CR>", {noremap=true})

-- Dear Diary        - https://github.com/ishchow/nvim-deardiary  {{{1
add({ source = 'ishchow/nvim-deardiary' })
require("deardiary.config").journals = {
    {
        path = os.getenv('DIARY') or '~/Documents/Diary',
        frequencies = {
            weekly = {
                formatpath = function(entry_date)
                    local week_start = entry_date:copy():adddays(1 - entry_date:getweekday())
                    return entry_date:getweeknumber() .. week_start:fmt(' - %B %d')
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
vim.api.nvim_set_keymap("n", "<leader>j", ":DearDiaryThisWeek<CR>", {noremap=true})

-- Markdown Preview  - https://github.com/iamcco/markdown-preview.nvim  {{{1
add({ source = 'iamcco/markdown-preview.nvim' })

-- Recover           - https://github.com/chrisbra/Recover.vim  {{{1
add({ source = 'chrisbra/Recover.vim' })

-- Exchange          - https://github.com/tommcdo/vim-exchange  {{{1
add({ source = 'tommcdo/vim-exchange' })

-- Signature         - https://github.com/kshenoy/vim-signature  {{{1
add({ source = 'kshenoy/vim-signature' })

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
