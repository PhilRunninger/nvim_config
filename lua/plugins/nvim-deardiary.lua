return {
    'ishchow/nvim-deardiary',
    config = function()
        require("deardiary.config").journals = {
            {
                path = os.getenv('DIARY') or '~/Documents/Diary',
                frequencies = {
                    weekly = {
                        formatpath = function(entry_date)
                            local week_start = entry_date:copy():adddays(1 - entry_date:getweekday())
                            local filename = string.format('%02d - %s.md', entry_date:getweeknumber(), week_start:fmt('%B %d'))
                            return require("deardiary.util").join_path({"weekly", entry_date:getyear(),  filename})
                        end,
                        template = function(entry_date)
                            local week_start = entry_date:copy():adddays(1 - entry_date:getweekday())
                            return week_start:fmt('# Week of %B %d, %Y') .. '\n\n' ..
                                '## Cards\n\n' ..
                                '## Training\n\n' ..
                                '## Other'
                        end
                    }
                }
            }
        }
        require('deardiary').set_current_journal(1)
    end,
    init = function()
        vim.g.deardiary_use_default_mappings = 0
    end,
    keys = {
        {"<leader>J", ":DearDiaryThisWeek<CR>"}
    }
}
