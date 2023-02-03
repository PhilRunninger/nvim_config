vim.opt['statusline'] =
    '%1*' .. ' %4l/%-4L %3v ' ..
    '%2*' .. '%(  %{FugitiveHead(8)} %)' ..
    '%3*' .. '%( %{SessionNameStatusLineFlag()} %)' ..
    '%4*' .. ' %{&filetype} ' ..
    '%5*' .. ' %{&fileformat} ' ..
    '%6*' .. ' %(%{&readonly?\'🔒\':\'\'} %)%(%{&modified?\'*\':\'\'} %)%n ' ..
    '%0*' .. ' %f'

local changeColors = function(insertMode)
    for i = 1,6,1 do
        local dim = 92 - 10 * i
        local bright = 156 - 19 * i
        local r,b,g
        if     vim.o.buftype == 'terminal' then r,g,b = bright, dim, 0
        elseif insertMode                  then r,g,b = 0     , dim, bright
        elseif vim.o.modified              then r,g,b = bright, 0  , 0
        else                                    r,g,b = 0     , dim, 0
        end
        vim.cmd('highlight User' .. i .. string.format(" guifg=#afafaf guibg=#%06x", 256*(256*r+g)+b ))
    end
    vim.cmd('highlight! link StatusLine User1')
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'TermOpen', 'InsertLeave', 'TextChanged', 'BufWritePost', 'BufEnter'}, {callback = function() changeColors(false) end, group = group})

-- This works well for &laststatus=3. But for any other value, the non-current statuslines appear with all of the
-- UserN highlight groups. To fix that, do something similar to this, to remove the %N* modifiers from &statusline:
-- https://github.com/PhilRunninger/nvim_config/blob/7a8c6925032d725582f8f4ce93b902a5dedc33eb/init.vim#L434-L470
