function SetStatusLineText()
    local useColor = vim.api.nvim_get_current_win() == vim.g.statusline_winid
    return
        (useColor and '%6*' or '') .. " %4l/%-4L %3v " ..
        (useColor and '%3*' or '') .. "%(  %{get(b:,'gitsigns_head')} %{get(b:,'gitsigns_status','')} %)" ..
        (useColor and '%5*' or '') .. "%( 🕒 %{SessionNameStatusLineFlag()} %)" ..
        (useColor and '%2*' or '') .. " %{&filetype} " ..
        (useColor and '%4*' or '') .. " %{&fileformat=='dos' ? '' : ''} " ..
        (useColor and '%1*' or '') .. " %(%{&readonly?'🔒':''}%)%(%{&modified?'🔴':''}%)%f"
end

vim.opt.statusline = "%!luaeval('SetStatusLineText()')"

local HLSToRGB = function(h,l,s)
    -- Credit: https://www.rapidtables.com/convert/color/hsl-to-rgb.html
    -- More explanation: https://www.wikiwand.com/en/HSL_and_HSV#To_RGB
    local c = (1 - math.abs(2*l - 1)) * s
    local x = c * (1 - math.abs(((h/60) % 2) - 1))
    local m = l - c / 2
    local r,g,b
    if     h < 60  then r,g,b = c, x, 0
    elseif h < 120 then r,g,b = x, c, 0
    elseif h < 180 then r,g,b = 0, c, x
    elseif h < 240 then r,g,b = 0, x, c
    elseif h < 300 then r,g,b = x, 0, c
    else                r,g,b = c, 0, x
    end
    return math.floor((r+m)*255), math.floor((g+m)*255), math.floor((b+m)*255)
end

local changeColors = function(insertMode)
    -- Background Hue: Terminal=purple, INSERT mode=blue, Modified=red, Unmodified=green
    local h = vim.o.buftype == 'terminal' and 288 or (insertMode and 210 or (vim.o.modified and 0 or 120))
    -- Background Saturation
    local s = 0.75
    for i = 1,6,1 do
        local l = vim.o.background == 'light' and (0.725 + 0.025 * i) or (0.275 - 0.025 * i)
        local r,g,b = HLSToRGB(h, l, s)
        local bg = 256*(256*r+g)+b

        if vim.o.background == 'light' then
            r,g,b = HLSToRGB(208, (-.05 + 0.05 * i), 0.08)
        else
            r,g,b = HLSToRGB(40, (1.05 - 0.05 * i), 0.04)
        end
        local fg = 256*(256*r+g)+b
        vim.cmd(string.format('highlight User%d guifg=#%06x guibg=#%06x', i, fg, bg))
    end
    vim.cmd('highlight! default link StatusLine User1')
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'VimEnter','ColorScheme','TermOpen','InsertLeave','TextChanged','BufWritePost','BufEnter'}, {callback = function() changeColors() end, group = group})
