return {
    'PhilRunninger/sql.nvim',
    lazy = false,
    keys = {
        {"<F8>", ":SQL new<CR>"}
    },
    cond = not vim.g.vscode,
}
