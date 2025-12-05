-- Name:         Tango
-- Description:  Taken from Windows Terminal's Tango Dark and Tango Light.
-- Author:       Phil Runninger <philrunninger@gmail.com>
-- Maintainer:   Phil Runninger <philrunninger@gmail.com>
-- Last Updated: 12/05/2025 00:44:08

--vim.cmd('hi clear')     --- not needed, maybe.

vim.g.colors_name = 'tango'

--==================================================
-- Define the palettes and a function to apply them.
--==================================================
local isDark = vim.o.background == 'dark'

local bg0    = isDark and '#000000' or '#ffffff'
local bg1    = isDark and '#1c1c1c' or '#e0e0e0'
local bg2    = isDark and '#383838' or '#c4c4c4'
local bg3    = isDark and '#545454' or '#a8a8a8'
local bg4    = isDark and '#707070' or '#8c8c8c'
local fg4    = isDark and '#8c8c8c' or '#707070'
local fg3    = isDark and '#a8a8a8' or '#545454'
local fg2    = isDark and '#c4c4c4' or '#383838'
local fg1    = isDark and '#e0e0e0' or '#1c1c1c'
local fg0    = isDark and '#ffffff' or '#000000'
local grey   = isDark and '#928374' or '#928374'
local red    = isDark and '#ef2929' or '#cc0000'
local orange = isDark and '#fe8019' or '#ff5f00'
local yellow = isDark and '#fce94f' or '#c4a000'
local green  = isDark and '#8ae234' or '#4e9a06'
local aqua   = isDark and '#34e2e2' or '#06989a'
local blue   = isDark and '#729fcf' or '#3465a4'
local purple = isDark and '#ad7fa8' or '#75507b'

local hiLite = function(definitions)
    for group, attributes in pairs(definitions) do
        vim.api.nvim_set_hl(0, group, attributes)
    end
end

--==========================================================
-- See `:h highlight-groups` for the groups in this section.
--==========================================================
hiLite({
    ColorColumn =                  {bg = bg2},
    Conceal =        {fg = bg2},
    CurSearch =      {fg = orange,  bg = bg0,    reverse = 1},
    Cursor =         {fg = fg0,     bg = bg0,    reverse = 1},
    lCursor =                                   {link = 'Cursor'},
    CursorIM =                                  {link = 'Cursor'},
    CursorColumn =                 {bg = bg2},
    CursorLine =                                {link = 'CursorColumn'},
    Directory =      {fg = green,                bold = 1},
    DiffAdd =        {fg = green,   bg = bg2,    bold = 1, italic = 1},
    DiffChange =     {fg = aqua,    bg = bg2,    bold = 1, italic = 1},
    DiffDelete =     {fg = red,     bg = bg2,    bold = 1, italic = 1},
    DiffText =       {fg = yellow,  bg = bg2,    bold = 1, italic = 1},
    EndOfBuffer =    {},
    TermCursor =                                {link = 'Cursor'},
    TermCursorNC =   {},
    ErrorMsg =                                  {link = 'Error'},
    WinSeparator =   {fg = bg2,     bg = bg2},
    Folded =         {fg = bg4},
    FoldColumn =     {fg = fg3},
    SignColumn =     {fg = fg0},
    IncSearch =                                 {link = 'CurSearch'},
    Substitute =     {},
    LineNr =         {fg = bg3,                  bold = 1},
    LineNrAbove =    {},
    LineNrBelow =    {},
    CursorLineNr =                              {link = 'CursorColumn'},
    CursorLineFold =                            {link = 'CursorColumn'},
    CursorLineSign =                            {link = 'CursorColumn'},
    MatchParen =     {fg = purple,               bold = 1, italic = 1},
    ModeMsg =        {fg = yellow,               bold = 1},
    MsgArea =        {},
    MsgSeparator =   {},
    MoreMsg =        {fg = yellow,                bold = 1},
    NonText =        {fg = bg1},
    Normal =         {fg = fg0,     bg = bg0},
    NormalFloat =    {fg = fg1,     bg = bg1},
    FloatBorder =    {},
    FloatTitle =     {},
    FloatFooter =    {},
    NormalNC =       {},
    Pmenu =          {fg = fg0,     bg = bg2},
    PmenuSel =       {fg = bg2,     bg = blue,   bold = 1},
    PmenuKind =      {fg = red,     bg = bg2},
    PmenuKindSel =   {fg = red,     bg = blue},
    PmenuExtra =     {fg = fg2,     bg = bg2},
    PmenuExtraSel =  {fg = bg3,     bg = blue},
    PmenuSbar =                    {bg = bg2},
    PmenuThumb =                   {bg = bg4},
    Question =       {fg = orange,               bold = 1},
    QuickFixLine =   {fg = aqua,    bg = bg0,    reverse = 1},
    Search =         {fg = green,   bg = bg0,    reverse = 1},
    SnippetTabstop = {},
    SpecialKey =     {fg = purple},
    SpellBad =       {fg = red,                   undercurl = 1},
    SpellCap =       {fg = blue,                  undercurl = 1},
    SpellLocal =     {fg = aqua,                  undercurl = 1},
    SpellRare =      {fg = purple,                undercurl = 1},
    StatusLine =     {fg = fg0,     bg = bg2},
    StatusLineNC =   {fg = fg4,     bg = bg2},
    TabLine =        {fg = fg2,     bg = bg2},
    TabLineFill =    {fg = fg0,     bg = bg1},
    TabLineSel =     {fg = fg0,     bg = bg0,    bold = 1},
    Title =          {fg = green,                 bold = 1},
    Visual =         {fg = blue,    bg = bg0,    reverse = 1},
    VisualNOS =                                  {link = 'Visual'},
    WarningMsg =     {fg = red,                   bold = 1},
    WildMenu =       {fg = blue,    bg = bg2,    bold = 1},
    WinBar =         {},
    WinBarNC =       {}
})

--==========================================================
-- See ` =h group-name` for the groups in this section.
--==========================================================
hiLite({
    Comment =        {fg = grey},
    Constant =       {fg = purple},
    String =         {fg = green},
    Character =      {fg = purple},
    Number =         {fg = purple},
    Boolean =        {fg = purple},
    Float =          {fg = purple},
    Identifier =     {fg = blue},
    Function =       {fg = green,           bold = 1},
    Statement =      {fg = red},
    Conditional =    {fg = red},
    Repeat =         {fg = red},
    Label =          {fg = red},
    Operator =       {fg = aqua},
    Keyword =        {fg = red},
    Exception =      {fg = red},
    PreProc =        {fg = aqua},
    Include =        {fg = aqua},
    Define =         {fg = aqua},
    Macro =          {fg = aqua},
    PreCondit =      {fg = aqua},
    Type =           {fg = yellow},
    StorageClass =   {fg = orange},
    Structure =      {fg = aqua},
    Typedef =        {fg = yellow},
    Special =        {fg = orange},
    SpecialChar =    {fg = red},
    Tag =            {fg = orange},
    Delimiter =      {fg = orange},
    SpecialComment = {fg = red},
    Debug =          {fg = red},
    Underlined =     {fg = blue,            underline = 1},
    Ignore =         {fg = bg2},
    Error =          {fg = red,   bg = bg0, bold = 1, reverse = 1},
    Todo =           {fg = fg0,   bg = bg0, bold = 1, italic = 1},
    Added =          {fg = green, bg = bg0, bold = 1, italic = 1},
    Changed =        {fg = aqua,  bg = bg0, bold = 1, italic = 1},
    Removed =        {fg = red,   bg = bg0, bold = 1, italic = 1}
})
