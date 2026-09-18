return {
    {
        'zbirenbaum/copilot.lua',
        event = { 'VeryLazy' },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        }
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        event = { 'VeryLazy' },
        dependencies = {
            'https://github.com/nvim-lua/plenary.nvim'
        }
    },
    cond = not vim.g.vscode,
}


