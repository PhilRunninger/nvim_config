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
        local minor = vim.o.background == 'light' and  (63 + 20 * i) or  (92 - 10 * i)
        local major = vim.o.background == 'light' and (127 + 10 * i) or (156 - 20 * i)

        local r,b,g
        if     vim.o.buftype == 'terminal' then r,g,b = major+64, minor+32, 0
        elseif insertMode                  then r,g,b = 0,        minor,    major
        elseif vim.o.modified              then r,g,b = major,    0,        0
        else                                    r,g,b = 0,        major,    0
        end
        local bg = 256*(256*r+g)+b
        local luminance = 0.299*r + 0.587*g + 0.114*b
        local fg = luminance < 128 and 0xffffff or 0
        vim.cmd(string.format('highlight User%d guifg=#%06x guibg=#%06x', i, fg, bg))
    end
    vim.cmd('highlight! link StatusLine User1')
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'VimEnter','ColorScheme','TermOpen','InsertLeave','TextChanged','BufWritePost','BufEnter'}, {callback = function() changeColors() end, group = group})
