" Name:         Strong GruvBox
" Description:  A variation of morhetz's gruvbox, with stronger contrast; the
"               bg[0-4] and fg[0-4] colors span the whole range fom black to white.
" Lineage:      [gruvbox](https://github.com/morhetz/gruvbox)
"                 ↳ [retrobox](https://github.com/vim/colorschemes)
"                     ↳ [strongbox](this file)
" Author:       Phil Runninger <philrunninger@gmail.com>
" Maintainer:   Phil Runninger <philrunninger@gmail.com>
" Last Updated: 2024-10-10

hi clear
let g:colors_name = 'strongbox'

"==================================================
" Define the palettes and a function to apply them.
"==================================================
let s:colors = {
    \ 'bg0':    &background ==# 'dark' ? '#000000': '#ffffff',
    \ 'bg1':    &background ==# 'dark' ? '#131312': '#e4dcc9',
    \ 'bg2':    &background ==# 'dark' ? '#262424': '#c8baa0',
    \ 'bg3':    &background ==# 'dark' ? '#3c3936': '#a69881',
    \ 'bg4':    &background ==# 'dark' ? '#5a534c': '#7f7466',
    \ 'fg4':    &background ==# 'dark' ? '#7f7466': '#5a534c',
    \ 'fg3':    &background ==# 'dark' ? '#a69881': '#3c3936',
    \ 'fg2':    &background ==# 'dark' ? '#c8baa0': '#262424',
    \ 'fg1':    &background ==# 'dark' ? '#e4dcc9': '#131312',
    \ 'fg0':    &background ==# 'dark' ? '#ffffff': '#000000',
    \ 'grey':   &background ==# 'dark' ? '#928374': '#928374',
    \ 'red':    &background ==# 'dark' ? '#fb4934': '#9d0006',
    \ 'orange': &background ==# 'dark' ? '#fe8019': '#ff5f00',
    \ 'yellow': &background ==# 'dark' ? '#fabd2f': '#b57614',
    \ 'green':  &background ==# 'dark' ? '#b8bb26': '#79740e',
    \ 'aqua':   &background ==# 'dark' ? '#8ec07c': '#427b58',
    \ 'blue':   &background ==# 'dark' ? '#83a598': '#076678',
    \ 'purple': &background ==# 'dark' ? '#d3869b': '#8f3f71'
\ }

function! s:HiLite(definitions)
    for [name, attributes] in items(a:definitions)
        " Substitute palette values in place of names. If not a palette name, use as is.
        if has_key(attributes,'fg')
            let attributes.fg = get(s:colors, attributes.fg, attributes.fg)
        endif
        if has_key(attributes,'bg')
            let attributes.bg = get(s:colors, attributes.bg, attributes.bg)
        endif
        call nvim_set_hl(0, name, attributes)
    endfor
endfunction

"==========================================================
" See `:h highlight-groups` for the groups in this section.
"==========================================================
call s:HiLite(#{
    \ ColorColumn:    #{              bg:'bg2'},
    \ Conceal:        #{fg:'bg2'},
    \ CurSearch:      #{fg:'orange',  bg:'bg0',    reverse:1},
    \ Cursor:         #{fg:'fg0',     bg:'bg0',    reverse:1},
    \ lCursor:        #{                           link:'Cursor'},
    \ CursorIM:       #{                           link:'Cursor'},
    \ CursorColumn:   #{              bg:'bg2'},
    \ CursorLine:     #{                           link:'CursorColumn'},
    \ Directory:      #{fg:'green',                bold:1},
    \ DiffAdd:        #{fg:'green',   bg:'bg2',    bold:1, italic:1},
    \ DiffChange:     #{fg:'aqua',    bg:'bg2',    bold:1, italic:1},
    \ DiffDelete:     #{fg:'red',     bg:'bg2',    bold:1, italic:1},
    \ DiffText:       #{fg:'yellow',  bg:'bg2',    bold:1, italic:1},
    \ EndOfBuffer:    #{},
    \ TermCursor:     #{},
    \ TermCursorNC:   #{},
    \ ErrorMsg:       #{                           link:'Error'},
    \ WinSeparator:   #{fg:'bg2',     bg:'bg2'},
    \ Folded:         #{fg:'fg3'},
    \ FoldColumn:     #{fg:'fg3'},
    \ SignColumn:     #{fg:'fg0'},
    \ IncSearch:      #{                           link:'CurSearch'},
    \ Substitute:     #{},
    \ LineNr:         #{fg:'bg4',                  bold:1},
    \ LineNrAbove:    #{},
    \ LineNrBelow:    #{},
    \ CursorLineNr:   #{fg:'fg1',     bg:'bg0',    bold:1},
    \ CursorLineFold: #{},
    \ CursorLineSign: #{},
    \ MatchParen:     #{fg:'bg0',     bg:'yellow', bold:1},
    \ ModeMsg:        #{fg:'yellow',               bold:1},
    \ MsgArea:        #{},
    \ MsgSeparator:   #{},
    \ MoreMsg:        #{fg:'yellow',               bold:1},
    \ NonText:        #{fg:'bg2'},
    \ Normal:         #{fg:'fg0',     bg:'bg0'},
    \ NormalFloat:    #{fg:'fg1',     bg:'bg0'},
    \ FloatBorder:    #{},
    \ FloatTitle:     #{},
    \ FloatFooter:    #{},
    \ NormalNC:       #{},
    \ Pmenu:          #{fg:'fg0',     bg:'bg2'},
    \ PmenuSel:       #{fg:'bg2',     bg:'blue',   bold:1},
    \ PmenuKind:      #{fg:'red',     bg:'bg2'},
    \ PmenuKindSel:   #{fg:'red',     bg:'blue'},
    \ PmenuExtra:     #{fg:'fg2',     bg:'bg2'},
    \ PmenuExtraSel:  #{fg:'bg3',     bg:'blue'},
    \ PmenuSbar:      #{              bg:'bg2'},
    \ PmenuThumb:     #{              bg:'bg4'},
    \ Question:       #{fg:'orange',               bold:1},
    \ QuickFixLine:   #{fg:'aqua',    bg:'bg0',    reverse:1},
    \ Search:         #{fg:'green',   bg:'bg0',    reverse:1},
    \ SnippetTabstop: #{},
    \ SpecialKey:     #{fg:'purple'},
    \ SpellBad:       #{fg:'red',                  undercurl:1},
    \ SpellCap:       #{fg:'blue',                 undercurl:1},
    \ SpellLocal:     #{fg:'aqua',                 undercurl:1},
    \ SpellRare:      #{fg:'purple',               undercurl:1},
    \ StatusLine:     #{fg:'fg0',     bg:'bg2'},
    \ StatusLineNC:   #{fg:'fg4',     bg:'bg2'},
    \ TabLine:        #{fg:'fg2',     bg:'bg2'},
    \ TabLineFill:    #{fg:'fg0',     bg:'bg1'},
    \ TabLineSel:     #{fg:'fg0',     bg:'bg0',    bold:1},
    \ Title:          #{fg:'green',                bold:1},
    \ Visual:         #{fg:'blue',    bg:'bg0',    reverse:1},
    \ VisualNOS:      #{                           link:'Visual'},
    \ WarningMsg:     #{fg:'red',                  bold:1},
    \ WildMenu:       #{fg:'blue',    bg:'bg2',    bold:1},
    \ WinBar:         #{},
    \ WinBarNC:       #{}
\})

"==========================================================
" See `:h group-name` for the groups in this section.
"==========================================================
call s:HiLite(#{
    \ Comment:        #{fg:'grey'},
    \ Constant:       #{fg:'purple'},
    \ String:         #{fg:'green'},
    \ Character:      #{fg:'purple'},
    \ Number:         #{fg:'purple'},
    \ Boolean:        #{fg:'purple'},
    \ Float:          #{fg:'purple'},
    \ Identifier:     #{fg:'blue'},
    \ Function:       #{fg:'green',           bold:1},
    \ Statement:      #{fg:'red'},
    \ Conditional:    #{fg:'red'},
    \ Repeat:         #{fg:'red'},
    \ Label:          #{fg:'red'},
    \ Operator:       #{fg:'aqua'},
    \ Keyword:        #{fg:'red'},
    \ Exception:      #{fg:'red'},
    \ PreProc:        #{fg:'aqua'},
    \ Include:        #{fg:'aqua'},
    \ Define:         #{fg:'aqua'},
    \ Macro:          #{fg:'aqua'},
    \ PreCondit:      #{fg:'aqua'},
    \ Type:           #{fg:'yellow'},
    \ StorageClass:   #{fg:'orange'},
    \ Structure:      #{fg:'aqua'},
    \ Typedef:        #{fg:'yellow'},
    \ Special:        #{fg:'orange'},
    \ SpecialChar:    #{fg:'red'},
    \ Tag:            #{fg:'orange'},
    \ Delimiter:      #{fg:'orange'},
    \ SpecialComment: #{fg:'red'},
    \ Debug:          #{fg:'red'},
    \ Underlined:     #{fg:'blue',            underline:1},
    \ Ignore:         #{fg:'bg2'},
    \ Error:          #{fg:'red',   bg:'bg0', bold:1, reverse:1},
    \ Todo:           #{fg:'fg0',   bg:'bg0', bold:1},
    \ Added:          #{fg:'green', bg:'bg0', bold:1, italic:1},
    \ Changed:        #{fg:'aqua',  bg:'bg0', bold:1, italic:1},
    \ Removed:        #{fg:'red',   bg:'bg0', bold:1, italic:1}
\ })

" vim: et ts=8 sw=2 sts=2
