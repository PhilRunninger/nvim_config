G.mapleader = ' '

-- An alternate keystroke for <C-W>
Map('n', '<leader>w', '<C-W>', Noremap)

-- Resize windows
Map('n', '<Up>', '5<C-W>+', NoremapSilent)
Map('n', '<Down>', '5<C-W>-', NoremapSilent)
Map('n', '<Right>', '10<C-W>>', NoremapSilent)
Map('n', '<Left>', '10<C-W><', NoremapSilent)
Map('n', '<S-Up>', '<C-W>+', NoremapSilent)
Map('n', '<S-Down>', '<C-W>-', NoremapSilent)
Map('n', '<S-Right>', '<C-W>>', NoremapSilent)
Map('n', '<S-Left>', '<C-W><', NoremapSilent)
Map('n', '<leader>x', '<C-W>_<C-W>|', NoremapSilent)

-- Switch Between Windows and Tabs
Cmd([[
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
Map('n', '<C-h>', '<Cmd>call WinTabSwitch("h")<CR>', NoremapSilent)
Map('n', '<C-j>', '<Cmd>call WinTabSwitch("j")<CR>', NoremapSilent)
Map('n', '<C-k>', '<Cmd>call WinTabSwitch("k")<CR>', NoremapSilent)
Map('n', '<C-l>', '<Cmd>call WinTabSwitch("l")<CR>', NoremapSilent)
Map('t', '<C-h>', '<C-\\><C-n><Cmd>call WinTabSwitch("h")<CR>', NoremapSilent)
Map('t', '<C-j>', '<C-\\><C-n><Cmd>call WinTabSwitch("j")<CR>', NoremapSilent)
Map('t', '<C-k>', '<C-\\><C-n><Cmd>call WinTabSwitch("k")<CR>', NoremapSilent)
Map('t', '<C-l>', '<C-\\><C-n><Cmd>call WinTabSwitch("l")<CR>', NoremapSilent)
Map('t', '<Esc><Esc>', '<C-\\><C-n>', NoremapSilent)

-- Open a terminal in a split window
if Fn.has('win32') and not string.find(vim.o.shell,'bash') then
    Map('n', '<leader>t', '<Cmd>split<BAR>terminal pwsh<CR>', NoremapSilent)
    Map('n', '<C-Z>', 'nop', NoremapSilent)  -- Prevent C-Z from freezing the shell
elseif string.find(vim.o.shell,'bash') then
    Map('n', '<leader>t', '<Cmd>split<BAR>terminal<CR>', NoremapSilent)
end

-- Make # go to the alternate buffer
Map('n', '#', '<Cmd>buffer #<CR>', NoremapSilent)

-- Swap j/k with gj/gk
Map('n', 'j', 'gj', NoremapSilent)
Map('n', 'k', 'gk', NoremapSilent)
Map('n', 'gj', 'j', NoremapSilent)
Map('n', 'gk', 'k', NoremapSilent)

-- Show/hide cursorline and cursorcolumn
Map('n', '+', '<Cmd>set cursorline! cursorcolumn!<CR>', NoremapSilent)
Map('n', '-', '<Cmd>set cursorline!<CR>', NoremapSilent)
Map('n', '|', '<Cmd>set cursorcolumn!<CR>', NoremapSilent)

-- Change cwd to current buffer's directory
Map('n', '<leader>cd', '<Cmd>cd %:p:h<Bar>pwd<CR>', NoremapSilent)

-- Focus on the current fold, opening it and closing all others.
Map('n', '<leader>z', 'zMzvzz', NoremapSilent)

-- Insert current date and/or time in insert mode
Map('i', 'Dt', '=strftime("%m/%d/%y %H:%M:%S")<CR><Space>', NoremapSilent)
Map('i', 'Dd', '=strftime("%m/%d/%y")<CR><Space>', NoremapSilent)
Map('i', 'Tt', '=strftime("%H:%M:%S")<CR><Space>', NoremapSilent)
Map('i', 'Dj', '* **=strftime("%d")<CR>**:<Space>', NoremapSilent)

-- Fix the closest prior misspelling
Map('n', '<F2>', '★<Esc>[s1z=/★<CR>s', NoremapSilent)
Map('n', '<F2>', 'i★<Esc>[s1z=/★<CR>x', NoremapSilent)

-- Make an easier redo mapping. Who uses the default U anyway?
Map('n', 'U', '<C-R>', NoremapSilent)
