function SetStatusLineText()
    local useColor = vim.api.nvim_get_current_win() == vim.g.statusline_winid
    return
        (useColor and '%1*' or '') .. " %4l/%-4L %3v " ..
        (useColor and '%2*' or '') .. "%(  %{FugitiveHead(8)} %)" ..
        (useColor and '%3*' or '') .. "%( %{SessionNameStatusLineFlag()} %)" ..
        (useColor and '%4*' or '') .. " %{&filetype} " ..
        (useColor and '%5*' or '') .. " %{&fileformat} " ..
        (useColor and '%6*' or '') .. " %(%{&readonly?'🔒':''} %)%(%{&modified?'🔴':''} %)%n " ..
        (useColor and '%0*' or '') .. " %f"
end

vim.opt.statusline = "%!luaeval('SetStatusLineText()')"

local changeColors = function(insertMode)
    for i = 1,6,1 do
        local dim = 92 - 10 * i
        local bright = 156 - 19 * i
        local r,b,g
        if     vim.o.buftype == 'terminal' then r,g,b = bright, dim,    0       -- 1:#895200 6:#2a2000
        elseif insertMode                  then r,g,b = 0     , dim,    bright  -- 1:#005289 6:#00202a
        elseif vim.o.modified              then r,g,b = bright, 0  ,    0       -- 1:#890000 6:#2a0000
        else                                    r,g,b = 0     , bright, 0       -- 1:#008900 6:#002a00
        end
        vim.cmd('highlight User' .. i .. string.format(" guifg=#afafaf guibg=#%06x", 256*(256*r+g)+b ))
    end
    vim.cmd('highlight! link StatusLine User1')
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'TermOpen', 'InsertLeave', 'TextChanged', 'BufWritePost', 'BufEnter'}, {callback = function() changeColors() end, group = group})
