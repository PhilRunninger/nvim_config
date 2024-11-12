" Name:         Strong GruvBox
" Description:  A variation of morhetz's gruvbox, with stronger contrast; the
"               bg[0-4] and fg[0-4] colors span the whole range fom black to white.
" Lineage:      [gruvbox](https://github.com/morhetz/gruvbox)
"                 ↳ [retrobox](https://github.com/vim/colorschemes)
"                     ↳ [strongbox](this file)
" Author:       Phil Runninger <philrunninger@gmail.com>
" Maintainer:   Phil Runninger <philrunninger@gmail.com>
" Last Updated: 2024-10-23 18:08

hi clear
let g:colors_name = 'strongbox'

"==================================================
" Define the palettes and a function to apply them.
"==================================================
let isDark = &background ==# 'dark'

let s:bg0    = isDark ? '#000000': '#ffffff'
let s:bg1    = isDark ? '#2f2b29': '#eadfc6'
let s:bg2    = isDark ? '#514a45': '#d4c4a2'
let s:bg3    = isDark ? '#665c54': '#beae93'
let s:bg4    = isDark ? '#837769': '#a0927e'
let s:fg4    = isDark ? '#a0927e': '#837769'
let s:fg3    = isDark ? '#beae93': '#665c54'
let s:fg2    = isDark ? '#d4c4a2': '#514a45'
let s:fg1    = isDark ? '#eadfc6': '#2f2b29'
let s:fg0    = isDark ? '#ffffff': '#000000'
let s:grey   = isDark ? '#928374': '#928374'
let s:red    = isDark ? '#fb4934': '#9d0006'
let s:orange = isDark ? '#fe8019': '#ff5f00'
let s:yellow = isDark ? '#fabd2f': '#b57614'
let s:green  = isDark ? '#b8bb26': '#79740e'
let s:aqua   = isDark ? '#8ec07c': '#427b58'
let s:blue   = isDark ? '#83a598': '#076678'
let s:purple = isDark ? '#d3869b': '#8f3f71'

function! s:HiLite(definitions)
    for [name, attributes] in items(a:definitions)
        call nvim_set_hl(0, name, attributes)
    endfor
endfunction

"==========================================================
" See `:h highlight-groups` for the groups in this section.
"==========================================================
call s:HiLite(#{
    \ ColorColumn:                   #{bg: s:bg2},
    \ Conceal:        #{fg: s:bg2},
    \ CurSearch:      #{fg: s:orange,  bg: s:bg0,    reverse: 1},
    \ Cursor:         #{fg: s:fg0,     bg: s:bg0,    reverse: 1},
    \ lCursor:                                     #{link: 'Cursor'},
    \ CursorIM:                                    #{link: 'Cursor'},
    \ CursorColumn:                  #{bg: s:bg2},
    \ CursorLine:                                  #{link: 'CursorColumn'},
    \ Directory:      #{fg: s:green,                 bold: 1},
    \ DiffAdd:        #{fg: s:green,   bg: s:bg2,    bold: 1, italic: 1},
    \ DiffChange:     #{fg: s:aqua,    bg: s:bg2,    bold: 1, italic: 1},
    \ DiffDelete:     #{fg: s:red,     bg: s:bg2,    bold: 1, italic: 1},
    \ DiffText:       #{fg: s:yellow,  bg: s:bg2,    bold: 1, italic: 1},
    \ EndOfBuffer:    #{},
    \ TermCursor:                                  #{link: 'Cursor'},
    \ TermCursorNC:   #{},
    \ ErrorMsg:                                    #{link: 'Error'},
    \ WinSeparator:   #{fg: s:bg2,     bg: s:bg2},
    \ Folded:         #{fg: s:fg3},
    \ FoldColumn:     #{fg: s:fg3},
    \ SignColumn:     #{fg: s:fg0},
    \ IncSearch:                                   #{link: 'CurSearch'},
    \ Substitute:     #{},
    \ LineNr:         #{fg: s:bg3,                   bold: 1},
    \ LineNrAbove:    #{},
    \ LineNrBelow:    #{},
    \ CursorLineNr:   #{fg: s:fg1,                   bold: 1},
    \ CursorLineFold: #{},
    \ CursorLineSign: #{},
    \ MatchParen:     #{fg: s:purple,                bold: 1, italic: 1},
    \ ModeMsg:        #{fg: s:yellow,                bold: 1},
    \ MsgArea:        #{},
    \ MsgSeparator:   #{},
    \ MoreMsg:        #{fg: s:yellow,                bold: 1},
    \ NonText:        #{fg: s:bg2},
    \ Normal:         #{fg: s:fg0,     bg: s:bg0},
    \ NormalFloat:    #{fg: s:fg1,     bg: s:bg0},
    \ FloatBorder:    #{},
    \ FloatTitle:     #{},
    \ FloatFooter:    #{},
    \ NormalNC:       #{},
    \ Pmenu:          #{fg: s:fg0,     bg: s:bg2},
    \ PmenuSel:       #{fg: s:bg2,     bg: s:blue,   bold: 1},
    \ PmenuKind:      #{fg: s:red,     bg: s:bg2},
    \ PmenuKindSel:   #{fg: s:red,     bg: s:blue},
    \ PmenuExtra:     #{fg: s:fg2,     bg: s:bg2},
    \ PmenuExtraSel:  #{fg: s:bg3,     bg: s:blue},
    \ PmenuSbar:                     #{bg: s:bg2},
    \ PmenuThumb:                    #{bg: s:bg4},
    \ Question:       #{fg: s:orange,                bold: 1},
    \ QuickFixLine:   #{fg: s:aqua,    bg: s:bg0,    reverse: 1},
    \ Search:         #{fg: s:green,   bg: s:bg0,    reverse: 1},
    \ SnippetTabstop: #{},
    \ SpecialKey:     #{fg: s:purple},
    \ SpellBad:       #{fg: s:red,                   undercurl: 1},
    \ SpellCap:       #{fg: s:blue,                  undercurl: 1},
    \ SpellLocal:     #{fg: s:aqua,                  undercurl: 1},
    \ SpellRare:      #{fg: s:purple,                undercurl: 1},
    \ StatusLine:     #{fg: s:fg0,     bg: s:bg2},
    \ StatusLineNC:   #{fg: s:fg4,     bg: s:bg2},
    \ TabLine:        #{fg: s:fg2,     bg: s:bg2},
    \ TabLineFill:    #{fg: s:fg0,     bg: s:bg1},
    \ TabLineSel:     #{fg: s:fg0,     bg: s:bg0,    bold: 1},
    \ Title:          #{fg: s:green,                 bold: 1},
    \ Visual:         #{fg: s:blue,    bg: s:bg0,    reverse: 1},
    \ VisualNOS:                                   #{link: 'Visual'},
    \ WarningMsg:     #{fg: s:red,                   bold: 1},
    \ WildMenu:       #{fg: s:blue,    bg: s:bg2,    bold: 1},
    \ WinBar:         #{},
    \ WinBarNC:       #{}
\})

"==========================================================
" See `:h group-name` for the groups in this section.
"==========================================================
call s:HiLite(#{
    \ Comment:        #{fg: s:grey},
    \ Constant:       #{fg: s:purple},
    \ String:         #{fg: s:green},
    \ Character:      #{fg: s:purple},
    \ Number:         #{fg: s:purple},
    \ Boolean:        #{fg: s:purple},
    \ Float:          #{fg: s:purple},
    \ Identifier:     #{fg: s:blue},
    \ Function:       #{fg: s:green,            bold: 1},
    \ Statement:      #{fg: s:red},
    \ Conditional:    #{fg: s:red},
    \ Repeat:         #{fg: s:red},
    \ Label:          #{fg: s:red},
    \ Operator:       #{fg: s:aqua},
    \ Keyword:        #{fg: s:red},
    \ Exception:      #{fg: s:red},
    \ PreProc:        #{fg: s:aqua},
    \ Include:        #{fg: s:aqua},
    \ Define:         #{fg: s:aqua},
    \ Macro:          #{fg: s:aqua},
    \ PreCondit:      #{fg: s:aqua},
    \ Type:           #{fg: s:yellow},
    \ StorageClass:   #{fg: s:orange},
    \ Structure:      #{fg: s:aqua},
    \ Typedef:        #{fg: s:yellow},
    \ Special:        #{fg: s:orange},
    \ SpecialChar:    #{fg: s:red},
    \ Tag:            #{fg: s:orange},
    \ Delimiter:      #{fg: s:orange},
    \ SpecialComment: #{fg: s:red},
    \ Debug:          #{fg: s:red},
    \ Underlined:     #{fg: s:blue,             underline: 1},
    \ Ignore:         #{fg: s:bg2},
    \ Error:          #{fg: s:red,   bg: s:bg0, bold: 1, reverse: 1},
    \ Todo:           #{fg: s:fg0,   bg: s:bg0, bold: 1},
    \ Added:          #{fg: s:green, bg: s:bg0, bold: 1, italic: 1},
    \ Changed:        #{fg: s:aqua,  bg: s:bg0, bold: 1, italic: 1},
    \ Removed:        #{fg: s:red,   bg: s:bg0, bold: 1, italic: 1}
\ })
