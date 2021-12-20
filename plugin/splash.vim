function! s:WriteText(screen)
    let l:mult = index(['l','c','r'], a:screen['align'], 0, 1)
    let l:padding = l:mult * (s:wininfo['width'] - a:screen['width']) / 2
    call map(a:screen['text'], {_,v -> repeat(' ', l:padding) . v})

    let l:mult = index(['t','c','b'], a:screen['valign'], 0, 1)
    let l:padding = l:mult * (s:wininfo['height'] - a:screen['height']) / 2
    let l:text = map(range(l:padding),{_ -> ''}) + a:screen['text']

    call append(0,l:text)
    normal! gg
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
    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist fillchars=eob:\  noswapfile nonumber norelativenumber

    let s:wininfo = getwininfo(win_getid())[0]
    let screens = []
    for f in s:files
        let data = readfile(f)
        try
            let attr = eval(json_decode(data[0]))
            let data = data[1:]
        catch
            let attr = {'align':'c', 'valign':'c', 'colors':[]}
        endtry
            let screen = extend({'height':len(data), 'width':max(map(copy(data), {_,d -> strchars(d)})), 'text':data}, attr)
        let screens += [screen]
    endfor
    call filter(screens, {_,s -> s['height']<s:wininfo['height'] && s['width']<s:wininfo['width']})

    if empty(screens)
        return
    endif

    let screen = screens[float2nr(reltimefloat(reltime())) % len(screens)]
    call s:WriteText(screen)
    call s:SetColors(screen['colors'])

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

let s:files = globpath(expand(expand('<sfile>:p:h').'/screens/'),'*.txt',0,1)
set shortmess+=I
autocmd VimEnter * if argc()==0 && line2byte('$') == -1 && !&insertmode | call s:Splash() | endif
