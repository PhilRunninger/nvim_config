vim.opt.statusline = "%!luaeval('SetStatusLineText()')"

local colors = {
    count = 5,
    hues = { modified = 30, unmodified = 108 , insert = 204, terminal = 312 }, -- 30=DarkOrange 108=green2 204=DeepSkyBlue 312=magenta3
    luminances = { light = { m = -0.075, b = 0.925 }, dark = { m = 0.075, b = 0.075 } },
    saturation = 0.999
}

function SetStatusLineText()
    local useColor = vim.api.nvim_get_current_win() == vim.g.statusline_winid
    local divider = useColor and '' or ''  -- Other candidates:     ┃  
    return
        (useColor and '%#User1#'  or '') .. " %4l/%-4L %3v " ..
        (useColor and '%#User12#' or '') .. divider ..
        (useColor and '%#User2#'  or '') .. "%(  %{get(b:,'gitsigns_head','')} %{get(b:,'gitsigns_status','')} %)" ..
        (useColor and '%#User23#' or '') .. divider ..
        (useColor and '%#User3#'  or '') .. "%( 🖪 %{SessionNameStatusLineFlag()} %)" ..
        (useColor and '%#User34#' or '') .. divider ..
        (useColor and '%#User4#'  or '') .. " %(%{&filetype} %)%(%{&fileformat=='dos' ? '' : ''} %)" ..
        (useColor and '%#User45#' or '') .. divider ..
        (useColor and '%#User5#'  or '') .."%( %{&readonly?'⃠':''}%{&modified?'':''}%) %f"
end

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
    return string.format('#%06x', 256*(256*r+g)+b)
end

local foregroundColor = function(h,l)
    local limit = 0.457781037 - 0.002553392*h + 7.13007e-5 *h^2 - 1.43305e-6*h^3 + 1.17384e-8 *h^4 - 3.8692e-11*h^5 + 4.3931e-14*h^6
    return l < limit and 'white' or 'black'
end

local changeColors = function(insertMode)
    local mode = vim.o.buftype == 'terminal' and 'terminal' or (insertMode and 'insert' or (vim.o.modified and 'modified' or 'unmodified'))
    for i = 1,colors.count,1 do
        vim.api.nvim_set_hl(0, 'User'..i, {fg=colors[mode][vim.o.background].fg[i], bg=colors[mode][vim.o.background].bg[i], bold=true})
        vim.api.nvim_set_hl(0, ('User'..i)..(i+1), {fg=colors[mode][vim.o.background].bg[i], bg=colors[mode][vim.o.background].bg[i+1]})
    end
end

for mode,h in pairs(colors.hues) do
    colors[mode] = {}
    for background,l in pairs(colors.luminances) do
        colors[mode][background] = {bg={}, fg={}}
        for i = 1,colors.count+1,1 do
            colors[mode][background].bg[i] = HLSToRGB(h,        l.b + l.m * i, colors.saturation)
            colors[mode][background].fg[i] = foregroundColor(h, l.b + l.m * i)
        end
    end
end

local group = vim.api.nvim_create_augroup('mySLgroup', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {callback = function() changeColors(true) end, group = group})
vim.api.nvim_create_autocmd({'VimEnter','ColorScheme','TermOpen','TermClose','InsertLeave','TextChanged','BufWritePost','BufEnter'}, {callback = function() changeColors() end, group = group})
vim.api.nvim_create_autocmd('ColorScheme', {command = 'highlight! link StatusLine User5', group = group})
