return {
    'PhilRunninger/bufselect',
    config = function()
        vim.fn['bufselect#settings']({
            mappings={delete='w', open='l', gopen='gl'},
            win={config={title='Buffers', title_pos='center'}}})
    end,
    keys = {
        {'<leader>b', '<CMD>ShowBufferList<CR>', desc='BufSelect buffer switcher'}
    },
    cond = not vim.g.vscode,
}

