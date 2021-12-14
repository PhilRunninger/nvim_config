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

    if float2nr(reltimefloat(reltime()))%2 || s:wininfo['height'] < 32
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
        let s:logo = [ '                          ##g6HUsjjsUH6gB#'
                   \ , '                   #BWV(~_` `_,:===,_`  _!(VWB#'
                   \ , '               #BP|" -<]edB@@@@@@@@@@@@Qde]^- _|KB#'
                   \ , '             #Pr` ~nD@@@@@@@@@@@@@@@@@@@@@@@@Dz~ `*P#'
                   \ , '           #j: !yQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Qt! _j#'
                   \ , '         #}` ?B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B] `}#'
                   \ , '       #K_ *$@@@@@@@@@@@@@@@@@@@bq6Q@@@@@@@@@@@@@@@@@0r _m#'
                   \ , '      #( _5@@@@@@@@@@@@@@@@@@@@@m}}nQ@@@@QQB@@@@@@@@@@@p_ ?#'
                   \ , '     #< rB@@@@@@@@@@@@@@@@@@@@@@E}nngBWz}}}nZB@@@@@@@@@@B? ,#'
                   \ , '    #~ x@@@@@@@@@@@@@@@@@@@@@@@@@DjWgnlc}nWB@@@@@@@@@@@@@@] !#'
                   \ , '   #? !@@@@@@@@@@@@@@@@@@@@@@@@@@@B8tzJcZB@@@@@@@@@@@@@@@@@( r#'
                   \ , '  #z -B@@@@@@@@QQ@@@@@@@@@@@@QBB@@@RH6g@@@@Q0RRgB@@@@@@@@@@B- 2#'
                   \ , '  #_ n@@@@@@@@?  _W@@@@@@@@@e  .n@@8@@@Bl<,,!!"``->lgBdp0@@@V _#'
                   \ , ' #h `Q@@@@@@@@]   u@@@@@@@@@Z   <@@@@0r`,zB@@@@Bp?` ?B6Z0@@@Q. X#'
                   \ , ' #( ^@@@@@@@@@n   V@@@@@@@@@E   ^@@@V` ~B@@@@@@@@@BjB@@@@@@@@^ ?#'
                   \ , ' #^ v@@@@@@@@@z   J@@@@@@@@@0   r@@s  `0@@@@@@@@@@@@@@@@@@@@@v >#'
                   \ , ' #^ |@@@@@@@@@w   rehUmmUhhsn   (@B_  ~@@@@@@@@@@@@@@@@@@@@@@v <#'
                   \ , ' #i ~@@@@@@@@@h   _........._   (@6   ~@@@@@@@@@@@@@@@@@@@@@@> v#'
                   \ , ' #K `B@@@@@@@@h   o@@@@@@@@@g   r@0   `$@@@@@@@@@@@@@@@@@@@@B` m#'
                   \ , '  #= x@@@@@@@@h   j@@@@@@@@@R   *@@(   "B@@@@@@@@@@@@@@@@@@@] :#'
                   \ , '  #G `O@@@@@@@w   V@@@@@@@@@6   >@@B^   ,aB@@@@@@@@EV@@@@@@Q` P#'
                   \ , '   #i ,B@@@@@@n   u@@@@@@@@@%   =@@@@e"   .<ilu}(>-=W@@@@@B^ v#'
                   \ , '    #| <Q@@@@@w~=*$@@@@@@@@@Bx!!(@@@@@@Bz|>:,,,~(jB@@@@@@Q^ (#'
                   \ , '     #] =0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0= ^#'
                   \ , '      #}` o@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@w `}#'
                   \ , '       #$< ,m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@K, >$#'
                   \ , '         #G= :S@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5< :P#'
                   \ , '           #5< ,}R@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D}, =S#'
                   \ , '             #Bn= `*e0@@@@@@@@@@@@@@@@@@@@@@0X?` =nB#'
                   \ , '                #Bor- ->vJPRQB@@@@@@BQRqJv>- -^jB#'
                   \ , '                    #gU}r=_  `.-__-.`   _r}Ug#'
                   \ , '                          ###QB$DD$BQ###']
        call s:WriteLogo()
        call s:SetColors([
            \ ['Background', '#64401c',            ['\S']],
            \ ['Ring',      ['#32200e','#c88038'], ['\(#\S*\|\S*#\)']],
            \ ['Leaves',     '#9ba879',            ['\(bq6Q\|m}}nQ\|E}nngBWz}}}nZB\|QQB\|DjWgnlc}nWB\|B8tzJcZB\|RH6g\|8\)']]
        \ ])
    endif

    " Pressing any key (numbers or letters) will exit the splash screen.
    for l:letter in range(48,57)+range(65,90)+range(97,122)
        execute 'nnoremap <buffer><silent><nowait> '.nr2char(l:letter).' :call CloseSplash('.count('aioAIO',nr2char(l:letter)).')<CR>'
    endfor
    nnoremap <buffer><silent><nowait> <Esc> :call timer_stop(g:splashTimer)<CR>

    let g:splashTimer = timer_start(5000, 'CloseSplash')
    autocmd BufWipeout <buffer> unlet g:splashTimer
endfun

function! CloseSplash(...)
    if exists('g:splashTimer')
        call timer_stop(g:splashTimer)
        enew
        if get(a:, 1, 0) == 1
            startinsert
        endif
    endif
endfunction

set shortmess+=I
autocmd VimEnter * call s:Splash()
