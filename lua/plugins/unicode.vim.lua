return {
    'chrisbra/unicode.vim',
    keys = {
        {'ga', ':UnicodeName<CR>'},
        {'<leader>ga', ':UnicodeSearch!<space>', {noremap = true}},
    },
    init = function()
        vim.g.Unicode_no_default_mappings = 1
    end,
    cond = not vim.g.vscode,
}

