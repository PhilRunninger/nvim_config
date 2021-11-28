function! s:WriteLogo()
    let l:indent = (s:wininfo['width'] - max(map(copy(s:logo),{_,v -> strchars(v)}))) / 2
    call map(s:logo, {_,v -> repeat(' ', l:indent) . v})
    let l:lines = (s:wininfo['height'] - len(s:logo))/2
    let s:logo = map(range(l:lines),{_ -> ''}) + s:logo + map(range(l:lines),{_ -> ''})
    call append(0,s:logo)
    setlocal nomodifiable nomodified
endfunction

function! s:SetColors(colors)
    let l:i = 0
    for [l:color,l:matches] in a:colors
        for l:match in l:matches
            execute 'syntax match Splash'.l:i.' #'.l:match.'#'
        endfor
        execute 'highlight Splash'.l:i.' guifg='.l:color
        execute 'autocmd BufWipeout <buffer> highlight clear Splash'.l:i
        let l:i += 1
    endfor
endfunction

function! s:Splash()
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist noswapfile nonumber norelativenumber

    let s:wininfo = getwininfo(win_getid())[0]

    if float2nr(reltimefloat(reltime()))%2
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
        call s:SetColors([['#2fa8e4',['']], ['#6dbc61',['']], ['#91ca61',['']], ['#519e39',['']], ['#76b237',['']]])
    else
        let s:logo = [ '                                         NNNNNNNNNNNNNNNN'
                   \ , '                                 NNNmmmdhhyssoo++++ooosyhhdmmmNNN'
                   \ , '                            NNNmmhso/-.``                ``.-/+shmmNNN'
                   \ , '                        NNmmds+-``   `.-:/+ossyyyyyysso+/:-.`   ``-+sdmmNN'
                   \ , '                     NNmdy+-`   .:+shddmmmmmmmmmmmmmmmmmmmmddhs+:.   `-+ydmNN'
                   \ , '                   Nmdy/.`  ./shdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdhs/-   ./ydmN'
                   \ , '                NNmh+.  `-ohdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdho-`  .+hmNN'
                   \ , '              Nmmy:`  -+hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmh+-  `:ymmN'
                   \ , '            NNmy:` `:ydmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdy:` `:ymNN'
                   \ , '           Nmh:` `:ymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmy:` `:hmN'
                   \ , '         Nmdo`  :ymmmmmmmmmmmmmmmmmmmmmmmmmmmmmhsyyhmmmmmmmmmmmmmmmmmmmmmmmmmmmmy:  `+dmN'
                   \ , '        Nmh-  .smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd///+odmmmmmmmmmmmmmmmmmmmmmmmmmmmms.  -hmN'
                   \ , '       Nms`  :hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd/////ommmmmddhhhhdmmmmmmmmmmmmmmmmmd:  `smN'
                   \ , '      mmo  `+mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmo//+++mmdys++////+shmmmmmmmmmmmmmmmmm+`  omm'
                   \ , '     mm+  `smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdo++osmh+//+///+shmmmmmmmmmmmmmmmmmmmms`  +mm'
                   \ , '    mmo  `smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmy+sdy+/+++/+ohmmmmmmmmmmmmmmmmmmmmmmms`  omm'
                   \ , '   Nmy   ommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdhd++oo/+ohmmmmmmmmmmmmmmmmmmmmmmmmmms   ymN'
                   \ , '  Nmd.  /mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmds+y++shmmmmmmmmmmmmmmmmmmmmmmmmmmmmm/  `dmN'
                   \ , '  mm/  .dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdohyhmmmmmmmmmdddddmmmmmmmmmmmmmmmmmmd.  /mm'
                   \ , ' Nmh   smmmmmmmmmmmmh.``.:hmmmmmmmmmmmmmmm+```.+dmmmbdmmmmmmds+:.`     `.-/ohmmmmmmmmmmmmms   hmN'
                   \ , ' mm/  .mmmmmmmmmmmmmd     .mmmmmmmmmmmmmmmo     ommmbmmmmdo-  `:+syyso+-`    .smmmmmmmmmmmm.  /mm'
                   \ , ' mm`  +mmmmmmmmmmmmmm`    .mmmmmmmmmmmmmmms     ommmmmmmo`  .odmmmmmmmmmds-   /mmmmmmmmmmmmo  `dm'
                   \ , 'Nmh   hmmmmmmmmmmmmmm.    .mmmmmmmmmmmmmmmy     ommmmmh-   :dmmmmmmmmmmmmmms.:dmmmmmmmmmmmmh   ymN'
                   \ , 'Nmo  `mmmmmmmmmmmmmmm.    .mmmmmmmmmmmmmmmh     smmmmh`   :mmmmmmmmmmmmmmmmmdmmmmmmmmmmmmmmm`  omN'
                   \ , 'mm+  .mmmmmmmmmmmmmmm-    .mmmmmmmmmmmmmmmh     smmmd.   `hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm.  +mm'
                   \ , 'mm+  .mmmmmmmmmmmmmmm-    .mmmmmmmmmmmmmmmh     ymmm/    -mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm.  +mm'
                   \ , 'Nmo  `mmmmmmmmmmmmmmm-    `--:::::::::::--.     ymmm`    /mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm`  omN'
                   \ , 'Nmy   dmmmmmmmmmmmmmm:    `:::::::::::::::-     ymmh     /mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd   smN'
                   \ , 'Nmd`  smmmmmmmmmmmmmm:    -mmmmmmmmmmmmmmmh     ymmh     .mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmms  `dmN'
                   \ , ' mm-  :mmmmmmmmmmmmmm:    -mmmmmmmmmmmmmmmh     smmm`     ymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm:  -mm'
                   \ , ' Nms  `hmmmmmmmmmmmmm:    -mmmmmmmmmmmmmmmh     smmm+     .hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmh`  smN'
                   \ , '  mm.  :mmmmmmmmmmmmm:    -mmmmmmmmmmmmmmmy     ommmd-     .ymmmmmmmmmmmmmmmmmmdmmmmmmmmmm/  .mm'
                   \ , '  Nmy   smmmmmmmmmmmm-    .mmmmmmmmmmmmmmmy     +mmmmd-     `/hdmmmmmmmmmmmmhs/hmmmmmmmmmy   ymN'
                   \ , '   mm/  `hmmmmmmmmmmm.    .mmmmmmmmmmmmmmms     +mmmmmdo.     `-/syhhhhhyo/-`.smmmmmmmmmh`  /mm'
                   \ , '    mm-  -dmmmmmmmmmm`    .mmmmmmmmmmmmmmmy     :mmmmmmmdo-`              `.odmmmmmmmmmd-  -dmN'
                   \ , '    Nmd-  -dmmmmmmmmd:...-ymmmmmmmmmmmmmmmm+...-+mmmmmmmmmmhs+:-.`````.-/ohmmmmmmmmmmmd-  -dmN'
                   \ , '     Nmd-  .hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdddddmmmmmmmmmmmmmmmh-  -dmN'
                   \ , '      Nmd:  `smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmms`  :dmN'
                   \ , '       Nmm+   /dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd/   +mmN'
                   \ , '         Nmy.  .smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmms.  .ymm'
                   \ , '          Nmm+`  -ymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmy-  `+mmN'
                   \ , '            Nmd/   -smmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmms-   /dmN'
                   \ , '              Nmh/`  .odmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmdo.  `/hmN'
                   \ , '                Nmd+.  `:sdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmds:`  .+dmN'
                   \ , '                  Nmdy:`  `-oydmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmyo-`  `:ydmN'
                   \ , '                    NNmds/.  ``:+shdmmmmmmmmmmmmmmmmmmmmmmmmmmdhs+:``  ./sdmNN'
                   \ , '                       NNmdyo:.   `.-/+syyhdddmmmmmmdddhyys+/-.`   .:oydmNN'
                   \ , '                           NNmdhs+:.`    ```..........```    `.:+shdmNN'
                   \ , '                               NNNmddhyo+/:----....----:/+oyhddmNNN'
                   \ , '                                     NNNNNNmmmddddddmmmNNNNNN']
        call s:WriteLogo()
        call s:SetColors([['#32000e',['[^M ]']], ['#9ba879',[ 'hsyyh', 'd///+od', 'd/////o', 'ddhhhhd', 'o//+++', 'dys++////+sh', 'do++os', 'h+//+///+sh', 'y+sdy+/+++/+oh', 'dhd++oo/+oh', 'ds+y++sh', 'dohyh', 'bd\?']]])
    endif

    " Pressing any key (numbers or letters) will exit the splash screen.
    for l:letter in range(48,57)+range(65,90)+range(97,122)
        execute 'nnoremap <buffer><silent> '.nr2char(l:letter).' :enew'.(count(['a','i','o','A','I','O'],l:letter)==1 ? '<bar>startinsert<CR>' : '<CR>')
    endfor
endfun

set shortmess+=I
autocmd VimEnter * call s:Splash()
