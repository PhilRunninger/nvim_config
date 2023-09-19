local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local noremapSilent = {noremap=true, silent=true}

g.mapleader = ' '

-- Window Sizing
map('n', '<leader>w', '<C-W>', noremapSilent)        -- An alternate keystroke for <C-W>
map('n', '<leader>x', '<C-W>_<C-W>|', noremapSilent) -- Maximize current window.
map('n', '<Up>', '5<C-W>+', noremapSilent)           -- Resize window 5 rows taller
map('n', '<Down>', '5<C-W>-', noremapSilent)         --               5 rows shorter
map('n', '<Right>', '10<C-W>>', noremapSilent)       --               10 columns wider
map('n', '<Left>', '10<C-W><', noremapSilent)        --               10 columns narrower

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
map('n', '<C-h>', ':lua WinTabSwitch("h")<CR>', noremapSilent)
map('n', '<C-j>', ':lua WinTabSwitch("j")<CR>', noremapSilent)
map('n', '<C-k>', ':lua WinTabSwitch("k")<CR>', noremapSilent)
map('n', '<C-l>', ':lua WinTabSwitch("l")<CR>', noremapSilent)
map('t', '<C-h>', '<C-\\><C-n>:lua WinTabSwitch("h")<CR>', noremapSilent)
map('t', '<C-j>', '<C-\\><C-n>:lua WinTabSwitch("j")<CR>', noremapSilent)
map('t', '<C-k>', '<C-\\><C-n>:lua WinTabSwitch("k")<CR>', noremapSilent)
map('t', '<C-l>', '<C-\\><C-n>:lua WinTabSwitch("l")<CR>', noremapSilent)
map('t', '<Esc><Esc>', '<C-\\><C-n>', noremapSilent)

-- Open a terminal in a split window
map('n', '<leader>t', ':split|terminal'..((jit.os == 'Windows' and vim.o.shell ~= 'bash') and ' pwsh' or '')..'<CR>', noremapSilent)

 -- Open a URL in the browser
if jit.os == 'Windows' then
    map('n', 'gx', ':!start <C-R><C-A><CR>', noremapSilent)
elseif jit.os == 'OSX' then
    map('n', 'gx', ':!open <C-R><C-A><CR>', noremapSilent)
end

-- Swap j and k with gj and gk
map('n', 'j', 'gj', noremapSilent)
map('n', 'k', 'gk', noremapSilent)
map('n', 'gj', 'j', noremapSilent)
map('n', 'gk', 'k', noremapSilent)

-- Horizontal scrolling, similar to <C-f> and <C-b>.
map('n', '<C-s>', '40zh', noremapSilent)
map('n', '<C-d>', '40zl', noremapSilent)

-- Show/hide cursorline and cursorcolumn
map('n', '+', ':set cursorline! cursorcolumn!<CR>', noremapSilent)
map('n', '-', ':set cursorline!<CR>', noremapSilent)
map('n', '|', ':set cursorcolumn!<CR>', noremapSilent)

-- Open or close folds with l and h
map('n', 'h', '(foldclosed(".")==-1 || foldlevel(".")>1) && col(".")==1 ? "zc" : "h"', {expr = true})
map('n', 'l', 'foldclosed(".")!=-1 ? "zo" : "l"', {expr = true})

-- Fix the closest prior misspelling
map('i', '<F2>', '★<Esc>[s1z=/★<CR>s', noremapSilent)
map('n', '<F2>', 'i★<Esc>[s1z=/★<CR>x', noremapSilent)

-- Miscellaneous
map('n', '#', ':buffer #<CR>', noremapSilent) -- Make # switch to the alternate buffer
map('n', '<leader>cd', ':cd %:p:h|pwd<CR>', noremapSilent) -- Change cwd to current buffer's directory
map('n', '<leader>z', 'zMzvzz', noremapSilent) -- Focus on the current fold, opening it and closing all others.
map('n', 'U', '<C-R>', noremapSilent) -- Make an easier redo mapping. Who uses the default U anyway?
