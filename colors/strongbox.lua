-- Name:         Strong GruvBox
-- Description:  A variation of morhetz's gruvbox, with stronger contrast; the
--               bg[0-4] and fg[0-4] colors span the whole range fom black to white.
-- Lineage:      [gruvbox](https://github.com/morhetz/gruvbox)
--                 ↳ [retrobox](https://github.com/vim/colorschemes)
--                     ↳ [strongbox](this file)
-- Author:       Phil Runninger <philrunninger@gmail.com>
-- Maintainer:   Phil Runninger <philrunninger@gmail.com>
-- Last Updated: 12/05/2025 02:43:42

-- Revert to Vim default color scheme
vim.cmd('source $VIMRUNTIME/colors/vim.lua')
vim.g.colors_name = 'strongbox'

--==================================================
-- Define the palettes and a function to apply them.
--==================================================
local isDark = vim.o.background == 'dark'

local c = {
    black  = isDark and '#000000' or '#ffffff',
    gray13 = isDark and '#342f2d' or '#e7dac0',
    gray25 = isDark and '#574f49' or '#cebe9d',
    gray35 = isDark and '#70655b' or '#b3a38b',
    gray50 = isDark and '#918473' or '#918473',
    gray63 = isDark and '#b3a38b' or '#70655b',
    gray75 = isDark and '#cebe9d' or '#574f49',
    gray88 = isDark and '#e7dac0' or '#342f2d',
    white  = isDark and '#ffffff' or '#000000',
    red    = isDark and '#fb4934' or '#9d0006',
    orange = isDark and '#fe8019' or '#ff5f00',
    yellow = isDark and '#fabd2f' or '#b57614',
    green  = isDark and '#b8bb26' or '#79740e',
    aqua   = isDark and '#8ec07c' or '#427b58',
    blue   = isDark and '#83a598' or '#076678',
    purple = isDark and '#d3869b' or '#8f3f71'
}

local hi = function(definitions)
    for group, attributes in pairs(definitions) do
        vim.api.nvim_set_hl(0, group, attributes)
    end
end

--==========================================================
-- See `:h highlight-groups` for the groups in this section.
--==========================================================
hi({
    ColorColumn =                    {bg = c.gray25},
    Conceal =        {fg = c.gray25},
    CurSearch =      {fg = c.orange,  bg = c.black,    reverse = 1},
    Cursor =         {fg = c.white,   bg = c.black,    reverse = 1},
    lCursor =                                         {link = 'Cursor'},
    CursorIM =                                        {link = 'Cursor'},
    CursorColumn =                   {bg = c.gray13},
    CursorLine =                                      {link = 'CursorColumn'},
    Directory =      {fg = c.green,                    bold = 1},
    DiffAdd =        {fg = c.green,   bg = c.gray25,   bold = 1, italic = 1},
    DiffChange =     {fg = c.aqua,    bg = c.gray25,   bold = 1, italic = 1},
    DiffDelete =     {fg = c.red,     bg = c.gray25,   bold = 1, italic = 1},
    DiffText =       {fg = c.yellow,  bg = c.gray25,   bold = 1, italic = 1},
    EndOfBuffer =    {},
    TermCursor =                                      {link = 'Cursor'},
    TermCursorNC =   {},
    ErrorMsg =                                        {link = 'Error'},
    WinSeparator =   {fg = c.gray25,  bg = c.gray25},
    Folded =         {fg = c.gray50},
    FoldColumn =     {fg = c.gray75},
    SignColumn =     {fg = c.white},
    IncSearch =                                       {link = 'CurSearch'},
    Substitute =     {},
    LineNr =         {fg = c.gray35,                   bold = 1},
    LineNrAbove =    {},
    LineNrBelow =    {},
    CursorLineNr =                                    {link = 'CursorColumn'},
    CursorLineFold =                                  {link = 'CursorColumn'},
    CursorLineSign =                                  {link = 'CursorColumn'},
    MatchParen =     {fg = c.purple,                   bold = 1, italic = 1},
    ModeMsg =        {fg = c.yellow,                   bold = 1},
    MsgArea =        {},
    MsgSeparator =   {},
    MoreMsg =        {fg = c.yellow,                   bold = 1},
    NonText =        {fg = c.gray13},
    Normal =         {fg = c.white,   bg = c.black},
    NormalFloat =                                     {link = 'Normal'},
    FloatBorder =    {},
    FloatTitle =     {},
    FloatFooter =    {},
    NormalNC =       {},
    Pmenu =          {fg = c.white,   bg = c.gray25},
    PmenuSel =       {fg = c.gray25,  bg = c.blue,     bold = 1},
    PmenuKind =      {fg = c.red,     bg = c.gray25},
    PmenuKindSel =   {fg = c.red,     bg = c.blue},
    PmenuExtra =     {fg = c.gray88,  bg = c.gray25},
    PmenuExtraSel =  {fg = c.gray35,  bg = c.blue},
    PmenuSbar =                      {bg = c.gray25},
    PmenuThumb =                     {bg = c.gray50},
    Question =       {fg = c.orange,                   bold = 1},
    QuickFixLine =   {fg = c.aqua,    bg = c.black,    reverse = 1},
    Search =         {fg = c.green,   bg = c.black,    reverse = 1},
    SnippetTabstop = {},
    SpecialKey =     {fg = c.purple},
    SpellBad =       {fg = c.red,                       undercurl = 1},
    SpellCap =       {fg = c.blue,                      undercurl = 1},
    SpellLocal =     {fg = c.aqua,                      undercurl = 1},
    SpellRare =      {fg = c.purple,                    undercurl = 1},
    StatusLine =     {fg = c.white,   bg = c.gray25},
    StatusLineNC =   {fg = c.gray63,  bg = c.gray25},
    TabLine =        {fg = c.gray88,  bg = c.gray25},
    TabLineFill =    {fg = c.white,   bg = c.gray13},
    TabLineSel =     {fg = c.white,   bg = c.black,     bold = 1},
    Title =          {fg = c.green,                     bold = 1},
    Visual =         {fg = c.blue,    bg = c.black,     reverse = 1},
    VisualNOS =                                        {link = 'Visual'},
    WarningMsg =     {fg = c.red,                       bold = 1},
    WildMenu =       {fg = c.blue,    bg = c.gray25,    bold = 1},
    WinBar =         {},
    WinBarNC =       {}
})

--==========================================================
-- See ` =h group-name` for the groups in this section.
--==========================================================
hi({
    Comment =        {fg = c.gray50},
    Constant =       {fg = c.purple},
    String =         {fg = c.green},
    Character =      {fg = c.purple},
    Number =         {fg = c.purple},
    Boolean =        {fg = c.purple},
    Float =          {fg = c.purple},
    Identifier =     {fg = c.blue},
    Function =       {fg = c.green,                     bold = 1},
    Statement =      {fg = c.red},
    Conditional =    {fg = c.red},
    Repeat =         {fg = c.red},
    Label =          {fg = c.red},
    Operator =       {fg = c.aqua},
    Keyword =        {fg = c.red},
    Exception =      {fg = c.red},
    PreProc =        {fg = c.aqua},
    Include =        {fg = c.aqua},
    Define =         {fg = c.aqua},
    Macro =          {fg = c.aqua},
    PreCondit =      {fg = c.aqua},
    Type =           {fg = c.yellow},
    StorageClass =   {fg = c.orange},
    Structure =      {fg = c.aqua},
    Typedef =        {fg = c.yellow},
    Special =        {fg = c.orange},
    SpecialChar =    {fg = c.red},
    Tag =            {fg = c.orange},
    Delimiter =      {fg = c.orange},
    SpecialComment = {fg = c.red},
    Debug =          {fg = c.red},
    Underlined =     {fg = c.blue,                      underline = 1},
    Ignore =         {fg = c.gray25},
    Error =          {fg = c.red,     bg = c.black,     bold = 1, reverse = 1},
    Todo =           {fg = c.white,   bg = c.black,     bold = 1, italic = 1},
    Added =          {fg = c.green,   bg = c.black,     bold = 1, italic = 1},
    Changed =        {fg = c.aqua,    bg = c.black,     bold = 1, italic = 1},
    Removed =        {fg = c.red,     bg = c.black,     bold = 1, italic = 1}
})
