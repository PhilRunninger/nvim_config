-- vim:foldmethod=marker

local map = function(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {noremap=true, silent=true})
end

vim.g.mapleader = ' '

-- Window Sizing
map('n', '<leader>x', '<C-W>_<C-W>|') -- Maximize current window.
map('n', '<Up>', '5<C-W>+')           -- Resize window 5 rows taller
map('n', '<Down>', '5<C-W>-')         --               5 rows shorter
map('n', '<Right>', '10<C-W>>')       --               10 columns wider
map('n', '<Left>', '10<C-W><')        --               10 columns narrower

-- Switch Between Windows and Tabs
function WinTabSwitch(direction)
    local info = vim.fn.getwininfo(vim.fn.win_getid())[1]
    local wincol = vim.fn.win_screenpos(vim.fn.winnr())[2]
    if (direction == 'h' and wincol <= 1) then
        vim.cmd('tabprev|99wincmd l')
    elseif (direction == 'l' and wincol + info.width >= vim.o.columns) then
        vim.cmd('tabnext|99wincmd h')
    else
        vim.cmd('wincmd '..direction)
    end
end
map('n', '<C-h>', ':lua WinTabSwitch("h")<CR>')
map('n', '<C-j>', ':lua WinTabSwitch("j")<CR>')
map('n', '<C-k>', ':lua WinTabSwitch("k")<CR>')
map('n', '<C-l>', ':lua WinTabSwitch("l")<CR>')
map('t', '<C-h>', '<C-\\><C-n>:lua WinTabSwitch("h")<CR>')
map('t', '<C-j>', '<C-\\><C-n>:lua WinTabSwitch("j")<CR>')
map('t', '<C-k>', '<C-\\><C-n>:lua WinTabSwitch("k")<CR>')
map('t', '<C-l>', '<C-\\><C-n>:lua WinTabSwitch("l")<CR>')

-- A shortcut for <C-W>
map('n', '<leader>w', '<C-W>')

-- Open a URL in the browser
if jit.os == 'Windows' then
    map('n', 'gx', ':!start <C-R><C-A><CR>')
elseif jit.os == 'OSX' then
    map('n', 'gx', ':!open <C-R><C-A><CR>')
end

-- Swap j and k with gj and gk
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('n', 'gj', 'j')
map('n', 'gk', 'k')

-- Horizontal scrolling, similar to <C-f> and <C-b>.
map('n', '<C-s>', '40zh')
map('n', '<C-d>', '40zl')

-- Open or close folds with l and h
map('n', 'h', '(foldclosed(".")==-1 || foldlevel(".")>1) && col(".")==1 ? "zc" : "h"', {expr = true})
map('n', 'l', 'foldclosed(".")!=-1 ? "zo" : "l"', {expr = true})

-- Fix the closest prior misspelling
map('i', '<F2>', '★<Esc>[s1z=/★<CR>s')
map('n', '<F2>', 'i★<Esc>[s1z=/★<CR>x')

-- Remove trailing spaces.
map('n', '<leader>d<space>', ':let [v,c,l]=[winsaveview(),&cuc,&cul]|set cuc cul|keeppatterns %s/\\s\\+$//ce|let [&cuc,&cul]=[c,l]|call winrestview(v)|unlet v l c<CR>')

-- Grab some mappings from mini.basics. Don't want anything else from it.
map('n', '\\b', '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>')
map('n', '\\d', '<Cmd>lua MiniBasics.toggle_diagnostic()<CR>')
map('n', '\\D', '<Cmd>if &diff | diffoff | else | diffthis | endif<CR>')
map('n', '\\h', '<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>')
map('n', '\\i', '<Cmd>setlocal ignorecase!<CR>')
map('n', '\\l', '<Cmd>setlocal list!<CR>')
map('n', '\\n', '<Cmd>setlocal number!<CR>')
map('n', '\\r', '<Cmd>setlocal relativenumber!<CR>')
map('n', '\\s', '<Cmd>setlocal spell!<CR>')
map('n', '\\w', '<Cmd>setlocal wrap!<CR>')

-- Miscellaneous
map('n', '#', ':buffer #<CR>') -- Make # switch to the alternate buffer
map('n', '<leader>cd', ':cd %:p:h|pwd<CR>') -- Change cwd to current buffer's directory
map('n', '<leader>z', 'zMzvzz') -- Focus on the current fold, opening it and closing all others.
map('n', 'U', '<C-R>') -- Make an easier redo mapping. Who uses the default U anyway?
map('n', '-', '<Cmd>setlocal cursorline!<CR>')
map('n', '|', '<Cmd>setlocal cursorcolumn!<CR>')
map('n', '+', '<Cmd>setlocal cursorline! cursorcolumn!<CR>')
