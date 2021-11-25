fun! Splash()
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist noswapfile nonumber norelativenumber

    let l:wininfo = getwininfo(win_getid())[0]
    let l:logo = [  '           .             .'
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
                \ , '||  \||'
                \ , '||   \||'
                \ , '||    \||'
                \ , '||     \||'
                \ , '||      \||'
                \ , '||       \||'
                \ , ' ⎺⎽|        \|⎽⎺'
                \ , '   ⎺⎽|         \|⎽⎺'
                \ , '     ⎺⎽|          \|⎽⎺'
                \ , '       ⎺⎽|           \|⎽⎺'
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
    if l:wininfo['width'] >= 150
        call map(l:logo, {i,v -> v.l:name[i]})
    endif

    " Center the logo in the window.
    let l:indent = (l:wininfo['width'] - max(map(copy(l:logo),{_,v -> strchars(v)}))) / 2
    call map(l:logo, {_,v -> repeat(' ', l:indent) . v})
    let l:padding = (l:wininfo['height'] - len(l:logo))/2
    let l:logo = map(range(l:padding),{_ -> ''}) + l:logo + map(range(l:padding),{_ -> ''})
    call append(0,l:logo)
    setlocal nomodifiable nomodified

    " Setup the colors.
    syn match Splash0 //
    syn match Splash1 //
    syn match Splash2 //
    syn match Splash3 //
    syn match Splash4 //
    syn match Splash5 //

    let l:colors = ['#2fa8e4','#2993c2','#6dbc61','#91ca61','#519e39','#76b237']
    let l:hlOn = join(map(copy(l:colors),{i,v -> 'highlight Splash'.i.' guifg='.v}),'|')
    let l:hlOff = join(map(copy(l:colors),{i,v -> 'highlight clear Splash'.i}),'|')
    execute l:hlOn

    augroup SplashScreen
        autocmd!
        execute 'autocmd ColorScheme <buffer> '.l:hlOn
        execute 'autocmd BufWipeout <buffer> '.l:hlOff
    augroup END

    " Pressing any key (numbers or letters) will exit the splash screen.
    for l:letter in range(48,57)+range(65,90)+range(97,122)
        execute 'nnoremap <buffer><silent> '.nr2char(l:letter).' :enew'.(count(['a','i','o','A','I','O'],l:letter)==1 ? '<bar>startinsert<CR>' : '<CR>')
    endfor
endfun

set shortmess+=I
autocmd VimEnter * call Splash()
