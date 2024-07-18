" Name:         Stark GruvBox
" Description:  A variation of morhetz's gruvbox, but with a stark black or white &background.
" Lineage:      [gruvbox](https://github.com/morhetz/gruvbox)
"                 ↳ [retrobox](https://github.com/vim/colorschemes)
"                     ↳ [starkbox](this file)
" Author:       Phil Runninger <philrunninger@gmail.com>
" Maintainer:   Phil Runninger <philrunninger@gmail.com>
" Last Updated: 2024-07-18 08:07:19

hi clear
let g:colors_name = 'starkbox'

hi! link CursorColumn CursorLine
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link VisualNOS Visual
hi! link Tag Special
hi! link lCursor Cursor
hi! link MessageWindow PMenu
hi! link PopupNotification Todo
hi! link CurSearch IncSearch
hi! link Terminal Normal
hi! link CursorIM Cursor
hi! link ErrorMsg Error

if &background ==# 'dark'
  let g:terminal_ansi_colors = [
    \ '#000000', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#a89984',
    \ '#928374', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2'
  \ ]
  hi Normal         guifg=#ebdbb2 guibg=#000000 gui=NONE
  hi NormalFloat    guifg=#ebdbb2 guibg=#1c1c1c gui=NONE
  hi CursorLineNr   guifg=#fabd2f guibg=bg      gui=bold
  hi FoldColumn     guifg=#928374 guibg=bg      gui=NONE
  hi SignColumn     guifg=#928374 guibg=bg      gui=NONE
  hi WinSeparator   guifg=#3c3836 guibg=#3c3836 gui=NONE
  hi ColorColumn    guifg=NONE    guibg=#181818 gui=NONE
  hi Comment        guifg=#928374 guibg=NONE    gui=NONE
  hi CursorLine     guifg=NONE    guibg=#303030 gui=NONE
  hi Error          guifg=#fb4934 guibg=bg      gui=bold,reverse
  hi Folded         guifg=#928374 guibg=bg      gui=NONE
  hi LineNrAbove    guifg=#7c6f64 guibg=NONE    gui=NONE
  hi LineNr         guifg=#fabd2f guibg=NONE    gui=bold
  hi LineNrBelow    guifg=#7c6f64 guibg=NONE    gui=NONE
  hi MatchParen     guifg=#ffcf00 guibg=#af00af gui=bold
  hi NonText        guifg=#504945 guibg=NONE    gui=NONE
  hi Pmenu          guifg=fg      guibg=#3c3836 gui=NONE
  hi PmenuSbar      guifg=NONE    guibg=#3c3836 gui=NONE
  hi PmenuSel       guifg=#3c3836 guibg=#83a598 gui=bold
  hi PmenuThumb     guifg=NONE    guibg=#7c6f64 gui=NONE
  hi PmenuKind      guifg=#fb4934 guibg=#3c3836 gui=NONE
  hi PmenuKindSel   guifg=#fb4934 guibg=#83a598 gui=NONE
  hi PmenuExtra     guifg=#a89984 guibg=#3c3836 gui=NONE
  hi PmenuExtraSel  guifg=#303030 guibg=#83a598 gui=NONE
  hi PmenuMatch     guifg=#b16286 guibg=#3c3836 gui=NONE
  hi PmenuMatchSel  guifg=#b16286 guibg=#83a598 gui=bold
  hi SpecialKey     guifg=#ff00af guibg=NONE    gui=NONE
  hi StatusLine     guifg=fg      guibg=#504945
  hi StatusLineNC   guifg=#a89984 guibg=#3c3836
  hi TabLine        guifg=#a89984 guibg=#504945 gui=NONE
  hi TabLineFill    guifg=fg      guibg=#3c3836 gui=NONE
  hi TabLineSel     guifg=#fbf1c7 guibg=bg      gui=bold
  hi ToolbarButton  guifg=#fbf1c7 guibg=#303030 gui=bold
  hi ToolbarLine    guifg=NONE    guibg=NONE    gui=NONE
  hi Visual         guifg=#83a598 guibg=bg      gui=reverse
  hi WildMenu       guifg=#83a598 guibg=#504945 gui=bold
  hi EndOfBuffer    guifg=#504945 guibg=NONE    gui=NONE
  hi Conceal        guifg=#504945 guibg=NONE    gui=NONE
  hi DiffAdd        guifg=#b8bb26 guibg=bg      gui=reverse
  hi DiffChange     guifg=#8ec07c guibg=bg      gui=reverse
  hi DiffDelete     guifg=#fb4934 guibg=bg      gui=reverse
  hi DiffText       guifg=#fabd2f guibg=bg      gui=reverse
  hi Directory      guifg=#b8bb26 guibg=NONE    gui=bold
  hi IncSearch      guifg=#fe8019 guibg=bg      gui=reverse
  hi ModeMsg        guifg=#fabd2f guibg=NONE    gui=bold
  hi MoreMsg        guifg=#fabd2f guibg=NONE    gui=bold
  hi Question       guifg=#fe8019 guibg=NONE    gui=bold
  hi Search         guifg=#98971a guibg=bg      gui=reverse
  hi QuickFixLine   guifg=#8ec07c guibg=bg      gui=reverse
  hi SpellBad       guifg=#fb4934 guibg=NONE    guisp=#fb4934 gui=undercurl
  hi SpellCap       guifg=#83a598 guibg=NONE    guisp=#83a598 gui=undercurl
  hi SpellLocal     guifg=#8ec07c guibg=NONE    guisp=#8ec07c gui=undercurl
  hi SpellRare      guifg=#d3869b guibg=NONE    guisp=#d3869b gui=undercurl
  hi Title          guifg=#b8bb26 guibg=NONE    gui=bold
  hi WarningMsg     guifg=#fb4934 guibg=NONE    gui=bold
  hi Boolean        guifg=#d3869b guibg=NONE    gui=NONE
  hi Character      guifg=#d3869b guibg=NONE    gui=NONE
  hi Conditional    guifg=#fb4934 guibg=NONE    gui=NONE
  hi Constant       guifg=#d3869b guibg=NONE    gui=NONE
  hi Define         guifg=#8ec07c guibg=NONE    gui=NONE
  hi Debug          guifg=#fb4934 guibg=NONE    gui=NONE
  hi Delimiter      guifg=#fe8019 guibg=NONE    gui=NONE
  hi Exception      guifg=#fb4934 guibg=NONE    gui=NONE
  hi Float          guifg=#d3869b guibg=NONE    gui=NONE
  hi Function       guifg=#b8bb26 guibg=NONE    gui=bold
  hi Identifier     guifg=#83a598 guibg=NONE    gui=NONE
  hi Ignore         guifg=fg      guibg=NONE    gui=NONE
  hi Include        guifg=#8ec07c guibg=NONE    gui=NONE
  hi Keyword        guifg=#fb4934 guibg=NONE    gui=NONE
  hi Label          guifg=#fb4934 guibg=NONE    gui=NONE
  hi Macro          guifg=#8ec07c guibg=NONE    gui=NONE
  hi Number         guifg=#d3869b guibg=NONE    gui=NONE
  hi Operator       guifg=#8ec07c guibg=NONE    gui=NONE
  hi PreCondit      guifg=#8ec07c guibg=NONE    gui=NONE
  hi PreProc        guifg=#8ec07c guibg=NONE    gui=NONE
  hi Repeat         guifg=#fb4934 guibg=NONE    gui=NONE
  hi SpecialChar    guifg=#fb4934 guibg=NONE    gui=NONE
  hi SpecialComment guifg=#fb4934 guibg=NONE    gui=NONE
  hi Statement      guifg=#fb4934 guibg=NONE    gui=NONE
  hi StorageClass   guifg=#fe8019 guibg=NONE    gui=NONE
  hi Special        guifg=#fe8019 guibg=NONE    gui=NONE
  hi String         guifg=#b8bb26 guibg=NONE    gui=NONE
  hi Structure      guifg=#8ec07c guibg=NONE    gui=NONE
  hi Todo           guifg=fg      guibg=bg      gui=bold
  hi Type           guifg=#fabd2f guibg=NONE    gui=NONE
  hi Typedef        guifg=#fabd2f guibg=NONE    gui=NONE
  hi Underlined     guifg=#83a598 guibg=NONE    gui=underline
  hi Cursor         guifg=#fbf1c7 guibg=bg      gui=reverse

else
  " Light background
  let g:terminal_ansi_colors = [
    \ '#3c3836', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#7c6f64',
    \ '#928374', '#9d0006', '#79740e', '#b57614', '#076678', '#8f3f71', '#427b58', '#ffffff'
  \ ]
  hi Normal         guifg=#3c3836 guibg=#ffffff gui=NONE
  hi NormalFloat    guifg=#3c3836 guibg=#fbf1c7 gui=NONE
  hi CursorLineNr   guifg=#b57614 guibg=bg      gui=bold
  hi FoldColumn     guifg=#928374 guibg=bg      gui=NONE
  hi SignColumn     guifg=fg      guibg=bg      gui=NONE
  hi WinSeparator   guifg=#ebdbb2 guibg=#ebdbb2 gui=NONE
  hi ColorColumn    guifg=NONE    guibg=#f2e9d8 gui=NONE
  hi Comment        guifg=#928374 guibg=NONE    gui=NONE
  hi CursorLine     guifg=NONE    guibg=#e5d4b1 gui=NONE
  hi Error          guifg=#9d0006 guibg=bg      gui=bold,reverse
  hi Folded         guifg=#928374 guibg=bg      gui=NONE
  hi LineNrAbove    guifg=#a89984 guibg=NONE    gui=NONE
  hi LineNr         guifg=#b57614 guibg=NONE    gui=bold
  hi LineNrBelow    guifg=#a89984 guibg=NONE    gui=NONE
  hi MatchParen     guifg=#ffcf00 guibg=#af00af gui=bold
  hi NonText        guifg=#e5d4b1 guibg=NONE    gui=NONE
  hi Pmenu          guifg=fg      guibg=#e5d4b1 gui=NONE
  hi PmenuSbar      guifg=NONE    guibg=#e5d4b1 gui=NONE
  hi PmenuSel       guifg=#e5d4b1 guibg=#076678 gui=bold
  hi PmenuThumb     guifg=NONE    guibg=#a89984 gui=NONE
  hi PmenuKind      guifg=#9d0006 guibg=#e5d4b1 gui=NONE
  hi PmenuKindSel   guifg=#9d0006 guibg=#076678 gui=NONE
  hi PmenuExtra     guifg=#7c6f64 guibg=#e5d4b1 gui=NONE
  hi PmenuExtraSel  guifg=#bdae93 guibg=#076678 gui=NONE
  hi PmenuMatch     guifg=#8f3f71 guibg=#e5d4b1 gui=NONE
  hi PmenuMatchSel  guifg=#d3869b guibg=#076678 gui=bold
  hi SpecialKey     guifg=#ff00af guibg=NONE    gui=NONE
  hi StatusLine     guifg=fg      guibg=#bdae93
  hi StatusLineNC   guifg=fg      guibg=#ebdbb2
  hi TabLine        guifg=#665c54 guibg=#bdae93 gui=NONE
  hi TabLineFill    guifg=#ebdbb2 guibg=#ebdbb2 gui=NONE
  hi TabLineSel     guifg=#282828 guibg=bg      gui=bold
  hi ToolbarButton  guifg=#282828 guibg=#bdae93 gui=bold
  hi ToolbarLine    guifg=NONE    guibg=NONE    gui=NONE
  hi Visual         guifg=#076678 guibg=bg      gui=reverse
  hi WildMenu       guifg=#076678 guibg=#e5d4b1 gui=bold
  hi EndOfBuffer    guifg=#e5d4b1 guibg=NONE    gui=NONE
  hi Conceal        guifg=#a89984 guibg=NONE    gui=NONE
  hi DiffAdd        guifg=#79740e guibg=bg      gui=reverse
  hi DiffChange     guifg=#427b58 guibg=bg      gui=reverse
  hi DiffDelete     guifg=#9d0006 guibg=bg      gui=reverse
  hi DiffText       guifg=#b57614 guibg=bg      gui=reverse
  hi Directory      guifg=#79740e guibg=NONE    gui=bold
  hi IncSearch      guifg=#ff5f00 guibg=bg      gui=reverse
  hi ModeMsg        guifg=fg      guibg=NONE    gui=bold
  hi MoreMsg        guifg=fg      guibg=NONE    gui=bold
  hi Question       guifg=#ff5f00 guibg=NONE    gui=bold
  hi Search         guifg=#98971a guibg=bg      gui=reverse
  hi QuickFixLine   guifg=#427b58 guibg=bg      gui=reverse
  hi SpellBad       guifg=#9d0006 guibg=NONE    guisp=#9d0006 gui=undercurl
  hi SpellCap       guifg=#076678 guibg=NONE    guisp=#076678 gui=undercurl
  hi SpellLocal     guifg=#427b58 guibg=NONE    guisp=#427b58 gui=undercurl
  hi SpellRare      guifg=#8f3f71 guibg=NONE    guisp=#8f3f71 gui=undercurl
  hi Title          guifg=#79740e guibg=NONE    gui=bold
  hi WarningMsg     guifg=#9d0006 guibg=NONE    gui=bold
  hi Boolean        guifg=#8f3f71 guibg=NONE    gui=NONE
  hi Character      guifg=#8f3f71 guibg=NONE    gui=NONE
  hi Conditional    guifg=#9d0006 guibg=NONE    gui=NONE
  hi Constant       guifg=#8f3f71 guibg=NONE    gui=NONE
  hi Define         guifg=#427b58 guibg=NONE    gui=NONE
  hi Debug          guifg=#9d0006 guibg=NONE    gui=NONE
  hi Delimiter      guifg=#ff5f00 guibg=NONE    gui=NONE
  hi Exception      guifg=#9d0006 guibg=NONE    gui=NONE
  hi Float          guifg=#8f3f71 guibg=NONE    gui=NONE
  hi Function       guifg=#79740e guibg=NONE    gui=bold
  hi Identifier     guifg=#076678 guibg=NONE    gui=NONE
  hi Ignore         guifg=fg      guibg=NONE    gui=NONE
  hi Include        guifg=#427b58 guibg=NONE    gui=NONE
  hi Keyword        guifg=#9d0006 guibg=NONE    gui=NONE
  hi Label          guifg=#9d0006 guibg=NONE    gui=NONE
  hi Macro          guifg=#427b58 guibg=NONE    gui=NONE
  hi Number         guifg=#8f3f71 guibg=NONE    gui=NONE
  hi Operator       guifg=#427b58 guibg=NONE    gui=NONE
  hi PreCondit      guifg=#427b58 guibg=NONE    gui=NONE
  hi PreProc        guifg=#427b58 guibg=NONE    gui=NONE
  hi Repeat         guifg=#9d0006 guibg=NONE    gui=NONE
  hi SpecialChar    guifg=#9d0006 guibg=NONE    gui=NONE
  hi SpecialComment guifg=#9d0006 guibg=NONE    gui=NONE
  hi Statement      guifg=#9d0006 guibg=NONE    gui=NONE
  hi StorageClass   guifg=#ff5f00 guibg=NONE    gui=NONE
  hi Special        guifg=#ff5f00 guibg=NONE    gui=NONE
  hi String         guifg=#79740e guibg=NONE    gui=NONE
  hi Structure      guifg=#427b58 guibg=NONE    gui=NONE
  hi Todo           guifg=fg      guibg=bg      gui=bold
  hi Type           guifg=#b57614 guibg=NONE    gui=NONE
  hi Typedef        guifg=#b57614 guibg=NONE    gui=NONE
  hi Underlined     guifg=#076678 guibg=NONE    gui=underline
  hi Cursor         guifg=#282828 guibg=bg      gui=reverse
endif

" vim: et ts=8 sw=2 sts=2
