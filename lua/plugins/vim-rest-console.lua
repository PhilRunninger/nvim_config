return {
    'Aadniz/vim-rest-console',
    init = function()
        vim.g.vrc_curl_timeout = '0'
        vim.g.vrc_response_default_content_type = 'application/json'
        vim.g.vrc_show_command = 1
        vim.g.vrc_trigger = '<F5>'
    end,
    cond = not vim.g.vscode,
}

