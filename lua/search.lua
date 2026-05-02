-- vim:foldmethod=marker

local M = {}

M.words = {}

local function create_search_string() -- {{{1
    local count = #M.words
    local msg = string.format(
        "Search [%d pattern%s]: %s",
        count,
        count == 1 and "" or "s",
        table.concat(M.words, ", ")
    )
    vim.api.nvim_echo({{msg, "None"}}, false, {})
    if count == 0 then
        vim.fn.setreg("/", "")
    else
        vim.fn.setreg("/", "\\(" .. table.concat(M.words, "\\|") .. "\\)")
    end
end

function M.toggle_word(text) -- {{{1
    for i, word in ipairs(M.words) do
        if word == text then
            table.remove(M.words, i)
            create_search_string()
            return
        end
        if word == '\\<' .. text .. '\\>' or text == '\\<' .. word .. '\\>' then
            table.remove(M.words, i)
        end
    end

    table.insert(M.words, text)
    create_search_string()
    vim.fn.execute('normal! nN')
end

function M.clear_all_words() -- {{{1
    M.words = {}
    create_search_string()
end

function M.matches(pattern) -- {{{1
    local buffer = vim.fn.bufnr("")
    local pos = vim.fn.winsaveview()
    vim.fn.execute('normal! gg0')
    local lines = {}
    local nr = vim.fn.search(pattern,'ceWz')
    while nr > 0 do
        table.insert(lines, {bufnr = buffer, lnum = nr, text = vim.fn.getline(nr)})
        nr = vim.fn.search(pattern,'ceWz')
    end
    vim.fn.winrestview(pos)

    vim.fn.setqflist(lines, 'r', {title = pattern})
    vim.cmd("copen")
end

-- Keymaps {{{1
vim.keymap.set("n", "*", function() M.toggle_word('\\<' .. vim.fn.expand("<cword>") .. '\\>') end, {silent=true})
vim.keymap.set("n", "g*", function() M.toggle_word(vim.fn.expand("<cword>")) end, {silent=true})
vim.keymap.set("v", "*", function()
    vim.cmd('normal! "xy')
    M.toggle_word(vim.fn.getreg("x"))
end, {silent=true})
vim.keymap.set("n", "<leader>*", function() M.clear_all_words() end, {silent=true})
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", {silent=true, noremap=true})

vim.keymap.set("n", "<leader>/", function() M.matches(vim.fn.getreg("/")) end, {silent=true})
vim.keymap.set("v", "<leader>/", function()
    vim.cmd('normal! "xy')
    vim.cmd('/' .. vim.fn.getreg("x"))
    M.matches(vim.fn.getreg("x"))
end, {silent=true})

return M
