local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = "rounded",
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

vim.api.nvim_set_keymap('n', '<leader>t', ':Floaterminal<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<Esc><Esc>', '<C-\\><C-n>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<Esc><Esc><Esc>', '<Cmd>Floaterminal<CR>', {noremap=true, silent=true})

local group = vim.api.nvim_create_augroup('Floaterminal', {clear = true})

-- Turn off line numbers in Terminal windows.
vim.api.nvim_create_autocmd('TermOpen', {command = 'setlocal nonumber norelativenumber | startinsert', group = group})
vim.api.nvim_create_autocmd('BufEnter', {command = 'if &buftype=="terminal"|startinsert|endif', group = group})

-- Close Terminal window automatically if it didn't throw an error.
vim.api.nvim_create_autocmd('TermClose', {command = 'if !v:event.status && expand("<afile>") !~# "vifm: " | execute "bdelete! ".expand("<abuf>") | endif', group = group})
