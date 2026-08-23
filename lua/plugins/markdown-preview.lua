return {
    'wardenclyffetower/markdown-preview.nvim',
    init = function()
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_page_title = '${name}'
        vim.g.mkdp_combine_preview = 1
    end,
    build = function()
        vim.cmd('call mkdp#util#install()')
    end,
}
