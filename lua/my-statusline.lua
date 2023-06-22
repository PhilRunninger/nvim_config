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
    local h = vim.o.buftype == 'terminal' and 276 or (insertMode and 204 or (vim.o.modified and 0 or 108))
    local bg,fg = {},{}

    for i = 1,6,1 do
        if  vim.o.background == 'light' then
            bg[i] = HLSToRGB(h, (0.925 - 0.075 * i), 0.75)
            fg[i] = HLSToRGB(208, (0.35 - 0.05 * i), 0.08)
        else
            bg[i] = HLSToRGB(h, (0.075 + 0.075 * i), 0.75)
            fg[i] = HLSToRGB(40, (0.65 + 0.05 * i), 0.04)
        end
        vim.cmd(string.format('highlight User%d guifg=#%06x guibg=#%06x', i, fg[i], bg[i]))
    end

    for i = 1,5,1 do
        vim.cmd(string.format('highlight User%d%d guifg=#%06x guibg=#%06x', i, i+1, bg[i], bg[i+1]))
    end
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'VimEnter','ColorScheme','TermOpen','InsertLeave','TextChanged','BufWritePost','BufEnter'}, {callback = function() changeColors() end, group = group})
