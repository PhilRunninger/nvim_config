local M = {}

M.words = {}

local function create_search_string()
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

function M.toggle_word(fragment, full)
    local countBefore = #M.words
    local fullWord = "\\<" .. fragment .. "\\>"
    local existingFragment, existingWord
    for i, word in ipairs(M.words) do
        if word == fragment then existingFragment = i end
        if word == fullWord then existingWord = i end
    end

    if existingFragment then
        table.remove(M.words, existingFragment)
    elseif existingWord then
        table.remove(M.words, existingWord)
    end

    if (existingFragment and full)
        or (existingWord and not full)
        or (not existingFragment and not existingWord) then
        table.insert(M.words, full and fullWord or fragment)
    end

    create_search_string()

    if #M.words > countBefore then
        vim.api.nvim_feedkeys("nN", "n", false)
    end
end

function M.clear_all_words()
    M.words = {}
    create_search_string()
end

function M.matches(pat)
    local buffer = vim.fn.bufnr("")
    local pos = vim.fn.winsaveview()
    vim.fn.execute('normal! gg0')
    local lines = {}
    local nr = vim.fn.search(pat,'ceWz')
    while nr > 0 do
        table.insert(lines, {bufnr = buffer, lnum = nr, text = vim.fn.getline(nr):gsub('"', '\\"')})
        nr = vim.fn.search(pat,'ceWz')
    end
    vim.fn.winrestview(pos)

    vim.fn.setqflist(lines)
    vim.fn.setqflist({}, 'a', {title = pat})
    vim.cmd("copen")
end

-- Keymaps
vim.keymap.set("n", "*", function() M.toggle_word(vim.fn.expand("<cword>"), true) end, {silent=true})
vim.keymap.set("n", "g*", function() M.toggle_word(vim.fn.expand("<cword>"), false) end, {silent=true})
vim.keymap.set("v", "*", function()
    vim.cmd('normal! "xy')
    M.toggle_word(vim.fn.getreg("x"), false)
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
