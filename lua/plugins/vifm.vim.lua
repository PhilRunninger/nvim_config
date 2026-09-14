return {
    'vifm/vifm.vim',
    lazy = false,  -- prevents error on `:drop` in plugin/vifm.vim
    init = function()
        vim.g.vifm_exec_args = '-c "source ' .. vim.fn.escape(vim.fn.stdpath('config') .. '/vifm.vim.rc', '\\') .. '"'
    end,
    keys = {
        {'<leader>o', '<CMD>Vifm<CR>', desc = 'vifm file manager/picker'}
    },
    cond = not vim.g.vscode,
}
