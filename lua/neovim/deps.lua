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

--   mini.hipatterns  {{{2
later(function()
    local hipatterns = require('mini.hipatterns')

    -- HTML Color Names - Source: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/named-color   {{{3
    local colorNames         = {
        -- Standard Colors ---------------------
        black                = '#000000',
        silver               = '#c0c0c0',
        gray                 = '#808080',
        white                = '#ffffff',
        maroon               = '#800000',
        red                  = '#ff0000',
        purple               = '#800080',
        fuchsia              = '#ff00ff',
        green                = '#008000',
        lime                 = '#00ff00',
        olive                = '#808000',
        yellow               = '#ffff00',
        navy                 = '#000080',
        blue                 = '#0000ff',
        teal                 = '#008080',
        aqua                 = '#00ffff',
        -- Other Colors ------------------------
        aliceblue            = '#f0f8ff',
        antiquewhite         = '#faebd7',
        aquamarine           = '#7fffd4',
        azure                = '#f0ffff',
        beige                = '#f5f5dc',
        bisque               = '#ffe4c4',
        blanchedalmond       = '#ffebcd',
        blueviolet           = '#8a2be2',
        brown                = '#a52a2a',
        burlywood            = '#deb887',
        cadetblue            = '#5f9ea0',
        chartreuse           = '#7fff00',
        chocolate            = '#d2691e',
        coral                = '#ff7f50',
        cornflowerblue       = '#6495ed',
        cornsilk             = '#fff8dc',
        crimson              = '#dc143c',
        cyan                 = '#00ffff',
        darkblue             = '#00008b',
        darkcyan             = '#008b8b',
        darkgoldenrod        = '#b8860b',
        darkgray             = '#a9a9a9',
        darkgreen            = '#006400',
        darkgrey             = '#a9a9a9',
        darkkhaki            = '#bdb76b',
        darkmagenta          = '#8b008b',
        darkolivegreen       = '#556b2f',
        darkorange           = '#ff8c00',
        darkorchid           = '#9932cc',
        darkred              = '#8b0000',
        darksalmon           = '#e9967a',
        darkseagreen         = '#8fbc8f',
        darkslateblue        = '#483d8b',
        darkslategray        = '#2f4f4f',
        darkslategrey        = '#2f4f4f',
        darkturquoise        = '#00ced1',
        darkviolet           = '#9400d3',
        deeppink             = '#ff1493',
        deepskyblue          = '#00bfff',
        dimgray              = '#696969',
        dimgrey              = '#696969',
        dodgerblue           = '#1e90ff',
        firebrick            = '#b22222',
        floralwhite          = '#fffaf0',
        forestgreen          = '#228b22',
        gainsboro            = '#dcdcdc',
        ghostwhite           = '#f8f8ff',
        gold                 = '#ffd700',
        goldenrod            = '#daa520',
        greenyellow          = '#adff2f',
        grey                 = '#808080',
        honeydew             = '#f0fff0',
        hotpink              = '#ff69b4',
        indianred            = '#cd5c5c',
        indigo               = '#4b0082',
        ivory                = '#fffff0',
        khaki                = '#f0e68c',
        lavender             = '#e6e6fa',
        lavenderblush        = '#fff0f5',
        lawngreen            = '#7cfc00',
        lemonchiffon         = '#fffacd',
        lightblue            = '#add8e6',
        lightcoral           = '#f08080',
        lightcyan            = '#e0ffff',
        lightgoldenrodyellow = '#fafad2',
        lightgray            = '#d3d3d3',
        lightgreen           = '#90ee90',
        lightgrey            = '#d3d3d3',
        lightpink            = '#ffb6c1',
        lightsalmon          = '#ffa07a',
        lightseagreen        = '#20b2aa',
        lightskyblue         = '#87cefa',
        lightslategray       = '#778899',
        lightslategrey       = '#778899',
        lightsteelblue       = '#b0c4de',
        lightyellow          = '#ffffe0',
        limegreen            = '#32cd32',
        linen                = '#faf0e6',
        magenta              = '#ff00ff',
        mediumaquamarine     = '#66cdaa',
        mediumblue           = '#0000cd',
        mediumorchid         = '#ba55d3',
        mediumpurple         = '#9370db',
        mediumseagreen       = '#3cb371',
        mediumslateblue      = '#7b68ee',
        mediumspringgreen    = '#00fa9a',
        mediumturquoise      = '#48d1cc',
        mediumvioletred      = '#c71585',
        midnightblue         = '#191970',
        mintcream            = '#f5fffa',
        mistyrose            = '#ffe4e1',
        moccasin             = '#ffe4b5',
        navajowhite          = '#ffdead',
        oldlace              = '#fdf5e6',
        olivedrab            = '#6b8e23',
        orange               = '#ffa500',
        orangered            = '#ff4500',
        orchid               = '#da70d6',
        palegoldenrod        = '#eee8aa',
        palegreen            = '#98fb98',
        paleturquoise        = '#afeeee',
        palevioletred        = '#db7093',
        papayawhip           = '#ffefd5',
        peachpuff            = '#ffdab9',
        peru                 = '#cd853f',
        pink                 = '#ffc0cb',
        plum                 = '#dda0dd',
        powderblue           = '#b0e0e6',
        rebeccapurple        = '#663399',
        rosybrown            = '#bc8f8f',
        royalblue            = '#4169e1',
        saddlebrown          = '#8b4513',
        salmon               = '#fa8072',
        sandybrown           = '#f4a460',
        seagreen             = '#2e8b57',
        seashell             = '#fff5ee',
        sienna               = '#a0522d',
        skyblue              = '#87ceeb',
        slateblue            = '#6a5acd',
        slategray            = '#708090',
        slategrey            = '#708090',
        snow                 = '#fffafa',
        springgreen          = '#00ff7f',
        steelblue            = '#4682b4',
        tan                  = '#d2b48c',
        thistle              = '#d8bfd8',
        tomato               = '#ff6347',
        turquoise            = '#40e0d0',
        violet               = '#ee82ee',
        wheat                = '#f5deb3',
        whitesmoke           = '#f5f5f5',
        yellowgreen          = '#9acd32',
    } --   }}}3

    hipatterns.setup({
        highlighters = {
            fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
            todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
            note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),

            -- Highlight color names using corresponding color.
            word_color = { pattern = '%S+', group = function(_, match)
                local hex = colorNames[match]
                if hex == nil then
                    return nil
                end
                return hipatterns.compute_hex_color_group(hex, 'bg')
            end
        },
    },
})
end)

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


--   mini.completion  {{{2
later(function()
    require('mini.completion').setup()
    vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
    vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})
    vim.keymap.set('i', '<CR>',    [[pumvisible() ? "\<C-y>" : "\<CR>"]], {expr = true})
end)

--   mini.snippets  {{{2
later(function()
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

later(function()

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
map('n', '<leader>G', ':Git<CR>')

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
later(function() add({ source = 'github/copilot.vim' }) end)

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
