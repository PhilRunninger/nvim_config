-- Define a formatter for SQL statements.
-- I'm doing it this way because I can't get it to work with
-- treesitter. Or ratter, I'm too lazy to get treesitter working.

vim.bo.formatprg =
    vim.fn.stdpath('data') ..
    '\\mason\\packages\\sql-formatter\\node_modules\\.bin\\sql-formatter.cmd' ..
    ' --config ' .. vim.fn.stdpath('config') .. '\\ftplugin\\sql-formatter-sqlserver.json'

vim.bo.equalprg =
    vim.fn.stdpath('data') ..
    '\\mason\\packages\\sql-formatter\\node_modules\\.bin\\sql-formatter.cmd' ..
    ' --config ' .. vim.fn.stdpath('config') .. '\\ftplugin\\sql-formatter-postgres.json'
