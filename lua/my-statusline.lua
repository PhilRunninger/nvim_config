function SetStatusLineText()
    local useColor = vim.api.nvim_get_current_win() == vim.g.statusline_winid
    local divider = useColor and '' or ''  -- Other candidates:     ┃
    return
        (useColor and '%1*'        or  '') .. " %4l/%-4L %3v " ..
        (useColor and '%#User12#'  or  '') .. divider ..
        (useColor and '%2*'        or  '') .. "%(  %{get(b:,'gitsigns_head')} %{get(b:,'gitsigns_status','')} %)" ..
        (useColor and '%#User23#'  or  '') .. divider ..
        (useColor and '%3*'        or  '') .. "%( 🕒 %{SessionNameStatusLineFlag()} %)" ..
        (useColor and '%#User34#'  or  '') .. divider ..
        (useColor and '%4*'        or  '') .. " %{&filetype} %{&fileformat=='dos' ? '' : ''} " ..
        (useColor and '%#User45#'  or  '') .. divider ..
        (useColor and '%5*'        or  '') .. " %(%{&readonly?'🔒':''}%)%(%{&modified?'🔴':''}%)%f"
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
    r,g,b = math.floor((r+m)*255), math.floor((g+m)*255), math.floor((b+m)*255)
    return 256*(256*r+g)+b
end

local changeColors = function(insertMode)
    -- Background Hue: Terminal=purple, INSERT mode=blue, Modified=red, Unmodified=green
    local h = vim.o.buftype == 'terminal' and 312 or (insertMode and 204 or (vim.o.modified and 0 or 108))

    local bg = {}
    for i = 1,6,1 do
        local l = vim.o.background == 'light' and (0.925 - 0.075 * i) or (0.075 + 0.075 * i)
        bg[i] = HLSToRGB(h, l, 0.999)

        local limit = 0.457781037 - 0.002553392*h + 7.13007e-5 *h^2 - 1.43305e-6*h^3 + 1.17384e-8 *h^4 - 3.8692e-11*h^5 + 4.3931e-14*h^6
        local fg = HLSToRGB(0, l < limit and 1 or 0, 0.999)  -- white or black

        vim.cmd(string.format('highlight User%d gui=bold guifg=#%06x guibg=#%06x', i, fg, bg[i]))
    end

    for i = 1,5,1 do
        vim.cmd(string.format('highlight User%d%d guifg=#%06x guibg=#%06x', i, i+1, bg[i], bg[i+1]))
    end
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'VimEnter','ColorScheme','TermOpen','InsertLeave','TextChanged','BufWritePost','BufEnter'}, {callback = function() changeColors() end, group = group})
