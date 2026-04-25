-- Name:         Tango
-- Description:  Taken from Windows Terminal's Tango Dark and Tango Light.
-- Author:       Phil Runninger <philrunninger@gmail.com>
-- Maintainer:   Phil Runninger <philrunninger@gmail.com>
-- Last Updated: 04/27/2026 00:20:38

-- Revert to Vim default color scheme
vim.cmd('source $VIMRUNTIME/colors/vim.lua')
vim.g.colors_name = 'tango'

local setHighlight = function(definitions)
    local isDark = vim.o.background == 'dark'

    local palette = {
        ['#000']   = isDark and '#000000' or '#ffffff',
        ['#111']   = isDark and '#111111' or '#eeeeee',
        ['#222']   = isDark and '#222222' or '#dddddd',
        ['#333']   = isDark and '#333333' or '#cccccc',
        ['#444']   = isDark and '#444444' or '#bbbbbb',
        ['#555']   = isDark and '#555555' or '#aaaaaa',
        ['#666']   = isDark and '#666666' or '#999999',
        ['#777']   = isDark and '#777777' or '#888888',
        ['#888']   = isDark and '#888888' or '#777777',
        ['#999']   = isDark and '#999999' or '#666666',
        ['#aaa']   = isDark and '#aaaaaa' or '#555555',
        ['#bbb']   = isDark and '#bbbbbb' or '#444444',
        ['#ccc']   = isDark and '#cccccc' or '#333333',
        ['#ddd']   = isDark and '#dddddd' or '#222222',
        ['#eee']   = isDark and '#eeeeee' or '#111111',
        ['#fff']   = isDark and '#ffffff' or '#000000',
        ['red']    = isDark and '#ef2929' or '#cc0000',
        ['orange'] = isDark and '#fe8019' or '#ff5f00',
        ['yellow'] = isDark and '#fce94f' or '#c4a000',
        ['green']  = isDark and '#8ae234' or '#4e9a06',
        ['aqua']   = isDark and '#34e2e2' or '#06989a',
        ['blue']   = isDark and '#729fcf' or '#3465a4',
        ['purple'] = isDark and '#ad7fa8' or '#75507b'
    }

    for group, attributes in pairs(definitions) do
        if attributes.fg then attributes.fg = palette[attributes.fg] or attributes.fg end
        if attributes.bg then attributes.bg = palette[attributes.bg] or attributes.bg end
        vim.api.nvim_set_hl(0, group, attributes)
    end
end

--==========================================================
-- See `:h highlight-groups` for the groups in this section.
--==========================================================
setHighlight({
    ColorColumn =                    {bg = '#333'},
    Conceal =        {fg = '#444'},
    CurSearch =      {fg = 'orange',  bg = '#000',   reverse = 1},
    Cursor =         {fg = '#fff',    bg = '#000',   reverse = 1},
    lCursor =                                       {link = 'Cursor'},
    CursorIM =                                      {link = 'Cursor'},
    CursorColumn =                   {bg = '#222'},
    CursorLine =                                    {link = 'CursorColumn'},
    Directory =      {fg = 'green',                   bold = 1},
    DiffAdd =        {fg = 'green',   bg = '#222',   italic = 1},
    DiffChange =     {fg = 'blue',    bg = '#222',   italic = 1},
    DiffDelete =     {fg = 'red',     bg = '#222',   italic = 1},
    DiffText =       {fg = 'yellow',  bg = '#222',   italic = 1, bold = 1},
    EndOfBuffer =    {},
    TermCursor =                                    {link = 'Cursor'},
    TermCursorNC =   {},
    ErrorMsg =                                      {link = 'Error'},
    WinSeparator =   {fg = '#555',    bg = '#555'},
    Folded =         {fg = '#888'},
    FoldColumn =     {fg = '#bbb'},
    SignColumn =     {fg = '#fff'},
    IncSearch =                                     {link = 'CurSearch'},
    Substitute =     {},
    LineNr =         {fg = '#555',                   bold = 1},
    LineNrAbove =    {},
    LineNrBelow =    {},
    CursorLineNr =                                  {link = 'CursorColumn'},
    CursorLineFold =                                {link = 'CursorColumn'},
    CursorLineSign =                                {link = 'CursorColumn'},
    MatchParen =     {fg = 'purple',                 bold = 1, italic = 1},
    ModeMsg =        {fg = 'yellow',                 bold = 1},
    MsgArea =        {},
    MsgSeparator =   {},
    MoreMsg =        {fg = 'yellow',                 bold = 1},
    NonText =        {fg = '#222'},
    Normal =         {fg = '#fff',    bg = '#000'},
    NormalFloat =                                   {link = 'Normal'},
    FloatBorder =    {fg = '#888',    bg = '#000',   bold = 1},
    FloatTitle =     {fg = '#fff',    bg = '#000',   bold = 1},
    FloatFooter =    {},
    NormalNC =       {},
    Pmenu =          {fg = '#fff',    bg = '#444'},
    PmenuSel =       {fg = '#444',    bg = 'blue',   bold = 1},
    PmenuKind =      {fg = 'red',     bg = '#444'},
    PmenuKindSel =   {fg = 'red',     bg = 'blue'},
    PmenuExtra =     {fg = '#ddd',    bg = '#444'},
    PmenuExtraSel =  {fg = '#555',    bg = 'blue'},
    PmenuSbar =                      {bg = '#444'},
    PmenuThumb =                     {bg = '#888'},
    Question =       {fg = 'orange',                 bold = 1},
    QuickFixLine =   {fg = 'aqua',    bg = '#000',   reverse = 1},
    Search =         {fg = 'green',   bg = '#000',   reverse = 1},
    SnippetTabstop = {},
    SpecialKey =     {fg = 'purple'},
    SpellBad =       {fg = 'red',                    undercurl = 1},
    SpellCap =       {fg = 'blue',                   undercurl = 1},
    SpellLocal =     {fg = 'aqua',                   undercurl = 1},
    SpellRare =      {fg = 'purple',                 undercurl = 1},
    StatusLine =     {fg = '#fff',    bg = '#444'},
    StatusLineNC =   {fg = '#bbb',    bg = '#555'},
    TabLine =        {fg = '#ddd',    bg = '#444'},
    TabLineFill =    {fg = '#fff',    bg = '#222'},
    TabLineSel =     {fg = '#fff',    bg = '#000',   bold = 1},
    Title =          {fg = 'green',                  bold = 1},
    Visual =         {fg = 'blue',    bg = '#000',   reverse = 1},
    VisualNOS =                                     {link = 'Visual'},
    WarningMsg =     {fg = 'red',                    bold = 1},
    WildMenu =       {fg = 'blue',    bg = '#444',   bold = 1},
    WinBar =         {},
    WinBarNC =       {}
})

--==========================================================
-- See ` =h group-name` for the groups in this section.
--==========================================================
setHighlight({
    Comment =        {fg = '#888'},
    Constant =       {fg = 'purple'},
    String =         {fg = 'green'},
    Character =      {fg = 'purple'},
    Number =         {fg = 'purple'},
    Boolean =        {fg = 'purple'},
    Float =          {fg = 'purple'},
    Identifier =     {fg = 'blue'},
    Function =       {fg = 'green',                  bold = 1},
    Statement =      {fg = 'red'},
    Conditional =    {fg = 'red'},
    Repeat =         {fg = 'red'},
    Label =          {fg = 'red'},
    Operator =       {fg = 'aqua'},
    Keyword =        {fg = 'red'},
    Exception =      {fg = 'red'},
    PreProc =        {fg = 'aqua'},
    Include =        {fg = 'aqua'},
    Define =         {fg = 'aqua'},
    Macro =          {fg = 'aqua'},
    PreCondit =      {fg = 'aqua'},
    Type =           {fg = 'yellow'},
    StorageClass =   {fg = 'orange'},
    Structure =      {fg = 'aqua'},
    Typedef =        {fg = 'yellow'},
    Special =        {fg = 'orange'},
    SpecialChar =    {fg = 'red'},
    Tag =            {fg = 'orange'},
    Delimiter =      {fg = 'orange'},
    SpecialComment = {fg = 'red'},
    Debug =          {fg = 'red'},
    Underlined =     {fg = 'blue',                   underline = 1},
    Ignore =         {fg = '#444'},
    Error =          {fg = 'red',     bg = '#000',   bold = 1, reverse = 1},
    Todo =           {fg = '#fff',    bg = '#000',   bold = 1, italic = 1},
    Added =          {fg = 'green',   bg = '#000',   bold = 1, italic = 1},
    Changed =        {fg = 'blue',    bg = '#000',   bold = 1, italic = 1},
    Removed =        {fg = 'red',     bg = '#000',   bold = 1, italic = 1}
})
