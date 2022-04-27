local cmd = vim.cmd
local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local noremapSilent = {noremap=true, silent=true}
local noremap = {noremap=true}

g.mapleader = ' '

-- An alternate keystroke for <C-W>
map('n', '<leader>w', '<C-W>', noremap)

-- Resize windows
map('n', '<Up>', '5<C-W>+', noremapSilent)
map('n', '<Down>', '5<C-W>-', noremapSilent)
map('n', '<Right>', '10<C-W>>', noremapSilent)
map('n', '<Left>', '10<C-W><', noremapSilent)
map('n', '<S-Up>', '<C-W>+', noremapSilent)
map('n', '<S-Down>', '<C-W>-', noremapSilent)
map('n', '<S-Right>', '<C-W>>', noremapSilent)
map('n', '<S-Left>', '<C-W><', noremapSilent)
map('n', '<leader>x', '<C-W>_<C-W>|', noremapSilent)

-- Switch Between Windows and Tabs
cmd([[
    function! WinTabSwitch(direction)
        let info = getwininfo(win_getid())[0]
            let wincol = win_screenpos(winnr())[1]
        if a:direction == 'h' && wincol <= 1
            execute 'tabprev|99wincmd l'
        elseif a:direction == 'l' && wincol + info.width >= &columns
            execute 'tabnext|99wincmd h'
        else
            execute 'wincmd '.a:direction
        endif
    endfunction
]])

-- Switch Between Windows and Tabs
map('n', '<C-h>', '<Cmd>call WinTabSwitch("h")<CR>', noremapSilent)
map('n', '<C-j>', '<Cmd>call WinTabSwitch("j")<CR>', noremapSilent)
map('n', '<C-k>', '<Cmd>call WinTabSwitch("k")<CR>', noremapSilent)
map('n', '<C-l>', '<Cmd>call WinTabSwitch("l")<CR>', noremapSilent)
map('t', '<C-h>', '<C-\\><C-n><Cmd>call WinTabSwitch("h")<CR>', noremapSilent)
map('t', '<C-j>', '<C-\\><C-n><Cmd>call WinTabSwitch("j")<CR>', noremapSilent)
map('t', '<C-k>', '<C-\\><C-n><Cmd>call WinTabSwitch("k")<CR>', noremapSilent)
map('t', '<C-l>', '<C-\\><C-n><Cmd>call WinTabSwitch("l")<CR>', noremapSilent)
map('t', '<Esc><Esc>', '<C-\\><C-n>', noremapSilent)

-- Open a terminal in a split window
if fn.has('win32') and not string.find(vim.o.shell,'bash') then
    map('n', '<leader>t', '<Cmd>split<BAR>terminal pwsh<CR>', noremapSilent)
    map('n', '<C-Z>', 'nop', noremapSilent)  -- Prevent C-Z from freezing the shell
elseif string.find(vim.o.shell,'bash') then
    map('n', '<leader>t', '<Cmd>split<BAR>terminal<CR>', noremapSilent)
end

-- Make # go to the alternate buffer
map('n', '#', '<Cmd>buffer #<CR>', noremapSilent)

-- Swap j/k with gj/gk
map('n', 'j', 'gj', noremapSilent)
map('n', 'k', 'gk', noremapSilent)
map('n', 'gj', 'j', noremapSilent)
map('n', 'gk', 'k', noremapSilent)

-- Show/hide cursorline and cursorcolumn
map('n', '+', '<Cmd>set cursorline! cursorcolumn!<CR>', noremapSilent)
map('n', '-', '<Cmd>set cursorline!<CR>', noremapSilent)
map('n', '|', '<Cmd>set cursorcolumn!<CR>', noremapSilent)

-- Change cwd to current buffer's directory
map('n', '<leader>cd', '<Cmd>cd %:p:h<Bar>pwd<CR>', noremapSilent)

-- Focus on the current fold, opening it and closing all others.
map('n', '<leader>z', 'zMzvzz', noremapSilent)

-- Insert current date and/or time
map('n', '<leader>Dt', 'i=strftime("%m/%d/%y %H:%M:%S")<CR><Space>', noremapSilent)
map('n', '<leader>Dd', 'i=strftime("%m/%d/%y")<CR><Space>', noremapSilent)
map('n', '<leader>Tt', 'i=strftime("%H:%M:%S")<CR><Space>', noremapSilent)
map('n', '<leader>Dj', 'i* **=strftime("%d")<CR>**:<Space>', noremapSilent)

-- Fix the closest prior misspelling
map('n', '<F2>', '★<Esc>[s1z=/★<CR>s', noremapSilent)
map('n', '<F2>', 'i★<Esc>[s1z=/★<CR>x', noremapSilent)

-- Make an easier redo mapping. Who uses the default U anyway?
map('n', 'U', '<C-R>', noremapSilent)
