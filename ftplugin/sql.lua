-- Define a formatter for SQL statements.
-- I'm doing it this way because I can't get it to work with
-- treesitter. Or rather, I'm too lazy to get treesitter working.

vim.bo.formatprg =
    vim.fn.stdpath('data') ..
    [[\mason\packages\sql-formatter\node_modules\.bin\sql-formatter.cmd]] ..
    [[ --config ]] .. vim.fn.stdpath('config') .. [[\ftplugin\sql-formatter-sqlserver.json]]

vim.bo.equalprg =
    vim.fn.stdpath('data') ..
    [[\mason\packages\sql-formatter\node_modules\.bin\sql-formatter.cmd]] ..
    [[ --config ]] .. vim.fn.stdpath('config') .. [[\ftplugin\sql-formatter-postgres.json]]


-- Create a command to change the case of all SQL keywords.
--   :Case  converts to uppercase.
--   :Case! converts to lowercase
-- Use this when the formatter above gets too aggressive with its changes.
local sqlKeywords =
    {
        -- Verbs
        'alter','create','delete','drop','exec','execute','merge','select','truncate','update',
        -- Objects
        'column','constraint','cursor','database','function','index','proc','procedure','schema','table','trigger','user',
        --
        'add', 'all', 'and', 'any', 'as', 'asc', 'authorization','auto',
        'backup', 'begin', 'between', 'break', 'browse', 'bulk', 'by',
        'cascade', 'case', 'check', 'checkpoint', 'close', 'clustered', 'coalesce', 'collate', 'column',
            'commit', 'compute', 'contains', 'containstable', 'continue', 'convert', 'cross',
            'current', 'current_date', 'current_time', 'current_timestamp', 'current_user',
        'dbcc', 'deallocate', 'declare', 'default', 'deny', 'desc', 'disk', 'distinct', 'distributed', 'double', 'dump',
        'elements', 'else', 'end', 'errlvl', 'escape', 'except', 'exists', 'exit', 'explicit', 'external',
        'fetch', 'file', 'fillfactor', 'for', 'foreign', 'freetext', 'freetexttable', 'from', 'full',
        'goto', 'grant', 'group',
        'having', 'holdlock',
        'identity', 'identitycol', 'identity_insert', 'if', 'in', 'inner', 'insert', 'intersect', 'into', 'is',
        'join',
        'key', 'kill',
        'left', 'like', 'lineno', 'load',
        'national', 'nocheck', 'nonclustered', 'not', 'null', 'nullif',
        'of', 'off', 'offsets', 'on', 'open', 'opendatasource', 'openquery', 'openrowset', 'openxml', 'option', 'or', 'order', 'outer', 'over',
        'path', 'percent', 'pivot', 'plan', 'precision', 'primary', 'print', 'public',
        'raiserror', 'raw', 'read',     'readtext', 'reconfigure', 'references', 'replication', 'restore', 'restrict', 'return', 'revert',
            'revoke', 'right', 'rollback', 'rowcount', 'rowguidcol',  'rule',
        'save', 'securityaudit', 'session_user', 'set', 'setuser', 'shutdown', 'some', 'statistics', 'system_user',
        'tablesample', 'textsize', 'then', 'to', 'top', 'tran', 'transaction', 'try_convert', 'tsequal',
        'union', 'unique', 'unpivot', 'updatetext', 'use',
        'values', 'varying', 'view',
        'waitfor', 'when', 'where', 'while', 'with', 'within group', 'writetext',
        'xml'
    }

vim.api.nvim_buf_create_user_command(0, 'Case',
    function(opts)
        local range =
            opts.range == 2 and string.format('%d,%d',opts.line1, opts.line2) or
            opts.range == 1 and string.format('%d',opts.line1) or
            '%'

        local view = vim.fn.winsaveview()

        if opts.bang == true then
            vim.cmd([[keeppatterns ]]..range..[[s/\C\(--.*\)\@256<!\<\(]] ..
                vim.fn.join(vim.tbl_map(vim.fn.toupper,sqlKeywords), [[\|]]) ..
                [[\)\>/\L&\E/gce]])
        else
            vim.cmd([[keeppatterns ]]..range..[[s/\C\(--.*\)\@256<!\<\(]] ..
                vim.fn.join(sqlKeywords, [[\|]]) ..
                [[\)\>/\U&\E/gce]])
        end

        vim.fn.winrestview(view)
    end,
    {
        desc = 'Change the case of all SQL keywords',
        bang = true,
        range = true
    }
)
