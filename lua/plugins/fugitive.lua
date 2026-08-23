return {
    'tpope/vim-fugitive',
    lazy = false,
    keys = {
        {'<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>'},
        {'<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', mode='v'},
    },
    cond = not vim.g.vscode,
}
