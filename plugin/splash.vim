function! s:WriteLogo()
    let l:indent = (s:wininfo['width'] - max(map(copy(s:logo),{_,v -> strchars(v)}))) / 2
    call map(s:logo, {_,v -> repeat(' ', l:indent) . v})
    let l:lines = (s:wininfo['height'] - len(s:logo))/2
    let s:logo = map(range(l:lines),{_ -> ''}) + s:logo + map(range(l:lines),{_ -> ''})
    call append(0,s:logo)
    setlocal nomodifiable nomodified
endfunction

" a:colors is a list of lists in this format
" [[name, guifg, [pattern,...]], ...] for one foreground color always or
" [[name, [light, dark], [pattern,...]], ...] if you want different guifg
" colors for dark and light backgrounds
function! s:SetColors(colors)
    for [l:name, l:color,l:matches] in a:colors
        for l:match in l:matches
            execute 'syntax match '.l:name.' /'.l:match.'/'
        endfor
        execute 'highlight '.l:name.' guifg='.(type(l:color)==v:t_list ? (&background=='light' ? l:color[0] : l:color[1]) : l:color)
        execute 'autocmd BufWipeout <buffer> highlight clear '.l:name
    endfor
endfunction

function! s:Splash()
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist noswapfile nonumber norelativenumber

    let s:wininfo = getwininfo(win_getid())[0]

    if float2nr(reltimefloat(reltime()))%2 || s:wininfo['height'] < 55
        let s:logo = [  '           .             .'
                    \ , '         ⎽⎺\            |⎺⎽'
                    \ , '       ⎽⎺\           |⎺⎽'
                    \ , '     ⎽⎺\          |⎺⎽'
                    \ , '   ⎽⎺\         |⎺⎽'
                    \ , ' ⎽⎺\\        |⎺⎽'
                    \ , '|\\       ||'
                    \ , '|\\      ||'
                    \ , '|\\     ||'
                    \ , '|\\    ||'
                    \ , '|\\   ||'
                    \ , '|\\  ||'
                    \ , '|\\ ||'
                    \ , '||\\||'
                    \ , '|| \||'
                    \ , '||  \||'
                    \ , '||   \||'
                    \ , '||    \||'
                    \ , '||     \||'
                    \ , '||      \||'
                    \ , '||       \||'
                    \ , ' ⎺⎽|        \|⎽⎺'
                    \ , '   ⎺⎽|         \|⎽⎺'
                    \ , '     ⎺⎽|          \|⎽⎺'
                    \ , '       ⎺⎽|           \|⎽⎺'
                    \ , '         ⎺⎽|            \|⎽⎺']
        let l:name = [  '', '', '', '', '', ''
                    \ , '                                                                            ...'
                    \ , '                                                                           shhhy'
                    \ , '                                                                           +ssso'
                    \ , '                                                       `...`          ....  ```    ````   `...`     `....`'
                    \ , '    `o- `-/+++o+:`       .:/+++//:.       .:++++++/-`  .yyyy:        oyyyo oyyys   yyys./syhhhy+``:syyhhhys:'
                    \ , '    `h+/+:.````-sy.    .oo:.`````-++`   `os/.````.-oy+` /hhhh.      /hhhy` shhhy   hhhhhyo++shhhsshyo++shhhho'
                    \ , '    `hs.        `yy   -y/`         +o  .ys`         -hs` ohhhs`    .hhhh-  shhhy   hhhho.    :hhhhy.    :hhhh-'
                    \ , '    `ho          +h.  yy...........-h. oh.           /h/ `yhhh+   `shhh:   shhhy   hhhh/     `hhhh+     `hhhh/'
                    \ , '    `ho          +h. `hs////////////+. hy            .hs  .yhhh-  +hhh+    shhhy   hhhh/      hhhh/     `hhhh/'
                    \ , '    `ho          +h. `ho               hy            .hs   :hhhy`:hhhs`    shhhy   hhhh/      hhhh/     `hhhh/'
                    \ , '    `ho          +h.  sy`              oh.           /h/    +hhh+yhhy.     shhhy   hhhh/      hhhh/     `hhhh/'
                    \ , '    `ho          +h.  .ys.          `  `ys`         -hs`     shhhhhh-      shhhy   hhhh/      hhhh/     `hhhh/'
                    \ , '    `ho          +h.   `+s+-.```.-/o/   `+s/.`````-+s/`      `yhhhh/       shhhy   hhhh/      hhhh/     `hhhh/'
                    \ , '     +:          -+`     `-/+++++/-`      `-///////-`         .::::        :////   ////-      ////-      ////.'
                    \ , '', '', '', '', '', '']
        if s:wininfo['width'] >= 150
            call map(s:logo, {i,v -> v.l:name[i]})
        endif
        call s:WriteLogo()
        call s:SetColors([
            \ ['N0', '#2fa8e4', ['']],
            \ ['N1', '#6dbc61', ['']],
            \ ['N2', '#91ca61', ['']],
            \ ['N3', '#519e39', ['']],
            \ ['N4', '#76b237', ['']]
        \ ])
    else
        let s:logo = [  '                                        ######B8$OWpSKmKSpWO$8B######'
                    \ , '                                  ####BRmni*!-                 -!*inmEB####'
                    \ , '                              ###Qqnr:`       .,=~^*r???r*^~=,.       `:rnpQ###'
                    \ , '                           ##BWi!`    ."^iVK6gB@@@@@@@@@@@@@@@@86KVi^".    `=imB##'
                    \ , '                       ###b]=    _*nq8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QZnr_    :]%###'
                    \ , '                     ##R];   .=VE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EV^.   `]E###'
                    \ , '                  ##Bw`   .~V0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@02>.   ~wQ##'
                    \ , '                ##Ql`   ,l0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0c,   `l8##'
                    \ , '               #8}`   ^PB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BS^.  `]8##'
                    \ , '             ##V`  .r6@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Or.  `nB#'
                    \ , '           ##6!  .v8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\`````\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8i.  `d##'
                    \ , '          #Bl`  .6@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|     \@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O~  `}B#'
                    \ , '        ##g<   nB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|      |@@@@@@/````\@@@@@@@@@@@@@@@@@@@BV.  >0##'
                    \ , '       ##6`  .V@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|   \  |@@/```      ``\@@@@@@@@@@@@@@@@@@6.  `d##'
                    \ , '      ##q`  .q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@`.   | |@/   _     ___/@@@@@@@@@@@@@@@@@@@Z-  `p##'
                    \ , '     ##e`  =g@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\  | |/   /    .`@@@@@@@@@@@@@@@@@@@@@@@@8=  `w##'
                    \ , '    ##q`  :g@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\_| /   /   .`@@@@@@@@@@@@@@@@@@@@@@@@@@@8:  `5##'
                    \ , '   ##g`  .E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\/   / _.`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@R-  `0##'
                    \ , '   ##r   w@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/   /.`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@h   r##'
                    \ , '  ##m   r@@@@@@@@@@@@@@$ZKKbQ@@@@@@@@@@@@@@@@@@RpKPOB@@@@@| .`/@@@@@@@QRHXznnVoPdgB@@@@@@@@@@@@@@@@@r   a##'
                    \ , '  #B`  .6@@@@@@@@@@@@@@!    .}@@@@@@@@@@@@@@@@@-    _w@@@@|/@@@@@@gj`             -!vUQ@@@@@@@@@@@@@E.  !B#'
                    \ , ' ##h   v@@@@@@@@@@@@@@@|     :R@@@@@@@@@@@@@@@@>     "B@@@@@@@@0]`  .>nZ8B@@BgZ}~.    `w@@@@@@@@@@@@@i   X##'
                    \ , ' ##?   G@@@@@@@@@@@@@@@}     `R@@@@@@@@@@@@@@@@r     =@@@@@@@@X`  .?D@@@@@@@@@@@@0}-  `a@@@@@@@@@@@@@q   r##'
                    \ , ' #B:  _Q@@@@@@@@@@@@@@@n     -8@@@@@@@@@@@@@@@@v     =@@@@@@8*   -S@@@@@@@@@@@@@@@@8|,X@@@@@@@@@@@@@@Q,  :B#'
                    \ , ' #D`  <@@@@@@@@@@@@@@@@j     -8@@@@@@@@@@@@@@@@]     ~@@@@@g=   .Z@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^  `E#'
                    \ , '##Z   ?@@@@@@@@@@@@@@@@w     -8@@@@@@@@@@@@@@@@}     <@@@@Q~    ]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(   p##'
                    \ , '##H   |@@@@@@@@@@@@@@@@K     -8@@@@@@@@@@@@@@@@n     r@@@@i    `D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@v   K##'
                    \ , '##b   r@@@@@@@@@@@@@@@@K     `rviii]}}]]xiiiv((:     r@@@8`    :B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?   W##'
                    \ , ' #g:  !@@@@@@@@@@@@@@@@q                             r@@@5     :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@`  ,0#'
                    \ , ' ##!  .0@@@@@@@@@@@@@@@Z     ,$QQQQBBBBBBBBBQQQ}     r@@@X     `0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g`  !##'
                    \ , ' ##]   o@@@@@@@@@@@@@@@Z     ,B@@@@@@@@@@@@@@@@n     ^@@@Z      V@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@s   x##'
                    \ , ' ##b.  ^@@@@@@@@@@@@@@@Z     ,B@@@@@@@@@@@@@@@@}     <@@@Q:     ,g@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^  `W##'
                    \ , '  ##?   X@@@@@@@@@@@@@@Z     ,Q@@@@@@@@@@@@@@@@x     !@@@@P.     ,E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a   ?##'
                    \ , '  ##R.  :Q@@@@@@@@@@@@@S     -8@@@@@@@@@@@@@@@@v     =@@@@@V.     `zB@@@@@@@@@@@@@@@@@@$8@@@@@@@@@@Q=  .E##'
                    \ , '   ##n   v@@@@@@@@@@@@@m     `N@@@@@@@@@@@@@@@@?     ,B@@@@@X.      :Vg@@@@@@@@@@@@B6n~!8@@@@@@@@@@i   l##'
                    \ , '    #B^   t@@@@@@@@@@@@y     `R@@@@@@@@@@@@@@@@r     -8@@@@@@0(       `=(nXG55Pjl(~- `?8@@@@@@@@@@w`  ^B#'
                    \ , '    ##8:  `P@@@@@@@@@@@}     `0@@@@@@@@@@@@@@@@x     `O@@@@@@@@W\_                 _vO@@@@@@@@@@@G`  :8##'
                    \ , '     ##N,  `m@@@@@@@@@@c:-_-!X@@@@@@@@@@@@@@@@@8?-__-!6@@@@@@@@@@B6z\>-,.    .-=rnWB@@@@@@@@@@@@P`  ,D##'
                    \ , '      ##Q<   iB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@]   ~8##'
                    \ , '        #Q?   `B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B}   ?Q#'
                    \ , '         ##2.  `R@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@R`  .V##'
                    \ , '          ##6!  `}Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Ql`  =6##'
                    \ , '           ##Bn   `wB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Be`   *B##'
                    \ , '             ##$r.  `]g@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8}`  .rD##'
                    \ , '               ##Or.  `?%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@d?`  .*d##'
                    \ , '                 ##Rv.   =n0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@gn=   .|E##'
                    \ , '                   ##8V=   `~nR@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8n~`   =V8##'
                    \ , '                     ###6].    ~}qQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QZ}~`   ,]6###'
                    \ , '                        ###6l~.   `!|ybQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Qdjv!`    !l6###'
                    \ , '                            ###Wu*_     `-~r]VhWE08QBBBBQQ80EWmV]?~-`     _^cWB##'
                    \ , '                               ####$mlr=-          ~~~~~~~          .=rlm$####'
                    \ , '                                    ####B0WXn]?^!:---___---:!<rxnXW0B####'
                    \ , '                                          ###########B###########']
        call s:WriteLogo()
        call s:SetColors([
            \ ['Background', '#64401c',            ['\S']],
            \ ['Ring',      ['#32200e','#c88038'], ['\(#\S*\|\S*#\)']],
            \ ['Leaves',     '#9ba879',            ['[\\|`/][|\/ `._]*[\/\\\|`]']]
        \ ])
    endif

    " Pressing any key (numbers or letters) will exit the splash screen.
    for l:letter in range(48,57)+range(65,90)+range(97,122)
        execute 'nnoremap <buffer><silent><nowait> '.nr2char(l:letter).' :enew'.(count(['a','i','o','A','I','O'],l:letter)==1 ? '<bar>startinsert<CR>' : '<CR>')
    endfor
endfun

set shortmess+=I
autocmd VimEnter * call s:Splash()
