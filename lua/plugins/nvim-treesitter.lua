return {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        vim.cmd('TSUpdate')
    end,
    opts = {
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'html', 'css', 'typescript', 'javascript', 'tsx', 'java', 'c_sharp', 'powershell', 'json', 'markdown', 'mermaid', 'gitcommit', 'diff', 'git_rebase' },
        highlight = { enable = true },
    },
    cond = not vim.g.vscode,
}

