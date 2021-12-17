function! s:WriteText(screen)
    let l:indent = (s:wininfo['width'] - a:screen['width']) / 2
    call map(a:screen['text'], {_,v -> repeat(' ', l:indent) . v})
    let l:margin = (s:wininfo['height'] - a:screen['height']) / 2
    let l:text = map(range(l:margin),{_ -> ''}) + a:screen['text'] + map(range(l:margin),{_ -> ''})
    call append(0,l:text)
    setlocal nomodifiable nomodified
endfunction

" a:colors is a list of lists in this format
" [[[guifg], [pattern,...]], ...] for one foreground color always or
" [[[light, dark], [pattern,...]], ...] if you want different guifg
" colors for dark and light backgrounds
function! s:SetColors(colors)
    let l:index = 0
    for [l:color,l:matches] in a:colors
        for l:match in l:matches
            execute 'syntax match Splash'.l:index.' /'.l:match.'/'
        endfor
        execute 'highlight Splash'.l:index.' guifg='.(&background=='light' ? l:color[0] : l:color[-1])
        execute 'autocmd BufWipeout <buffer> highlight clear Splash'.l:index
        let l:index += 1
    endfor
endfunction

function! s:Splash()
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist noswapfile nonumber norelativenumber

    let s:wininfo = getwininfo(win_getid())[0]
    call map(s:screens, {_,f -> readfile(f)})
    call map(s:screens, {_,f ->
        \ {'colors':eval(f[0]),
        \  'height':len(f)-1,
        \  'width':max(map(copy(f[1:]), {_,l -> strchars(l)})),
        \  'text':f[1:]} })
    call filter(s:screens, {_,s -> s['height']<s:wininfo['height'] && s['width']<s:wininfo['width']})

    if empty(s:screens)
        return
    endif

    let l:screen = s:screens[float2nr(reltimefloat(reltime())) % len(s:screens)]
    call s:WriteText(l:screen)
    call s:SetColors(l:screen['colors'])

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

let s:screens = globpath(expand(expand('<sfile>:p:h').'/screens/'),'*.txt',1,1)
set shortmess+=I
autocmd VimEnter * call s:Splash()
