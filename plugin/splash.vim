function! s:WriteText(screen, wininfo)
    let l:padding = stridx('lcr', a:screen['align']) * (a:wininfo['width'] - a:screen['width']) / 2
    call map(a:screen['text'], {_,v -> repeat(' ', l:padding) . v})

    let l:padding = stridx('tcb', a:screen['valign']) * (a:wininfo['height'] - a:screen['height']) / 2
    let l:text = map(range(l:padding),{_ -> ''}) + a:screen['text']

    call append(0,l:text)
    normal! gg
    setlocal nomodifiable nomodified
endfunction

" a:colorSpecs is a list of lists of lists in this format
" [[[guifg], [pattern,...]], ...] for one foreground color always or
" [[[light, dark], [pattern,...]], ...] if you want different guifg
" colors for light and dark backgrounds
function! s:SetColors(colorSpecs)
    let l:index = 0
    for [l:colors,l:matches] in a:colorSpecs
        for l:match in l:matches
            execute 'syntax match Splash'.l:index.' /'.l:match.'/'
        endfor
        execute 'highlight Splash'.l:index.' guifg='.(&background=='light' ? l:colors[0] : l:colors[-1])
        execute 'autocmd BufWipeout <buffer> highlight clear Splash'.l:index
        let l:index += 1
    endfor
endfunction

function! s:Splash(...)
    let l:screens = []
    for l:file in (a:0 && !empty(a:1)) ? [a:1] : split(s:AllSplashFiles(0,0,0), "\n")
        let l:attr = {'align':'c', 'valign':'c', 'colors':[]}
        let l:data = readfile(printf('%s/%s.txt', s:splashDir,l:file))
        try
            let l:attr = extend(eval(l:data[0]), l:attr, 'keep')
            let l:data = l:data[1:]
        catch
        finally
            let l:screens += [extend({'height':len(l:data), 'width':max(map(copy(l:data), {_,d -> strchars(d)})), 'text':l:data}, l:attr, 'keep')]
        endtry
    endfor
    let l:wininfo = getwininfo(win_getid())[0]
    call filter(l:screens, {_,s -> s['height']<l:wininfo['height'] && s['width']<l:wininfo['width']})

    if empty(l:screens)
        echo 'Splash: window too small'
        return
    endif

    let l:screen = l:screens[float2nr(reltimefloat(reltime())) % len(l:screens)]

    enew
    setlocal signcolumn=no bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist fillchars=eob:\  noswapfile nonumber norelativenumber
    call s:WriteText(l:screen, l:wininfo)
    call s:SetColors(l:screen['colors'])

    let g:timer = timer_start(5000, function('s:CloseSplash'))
    nnoremap <buffer><silent><nowait> <Space> :call timer_stop(g:timer)<CR>
    autocmd BufWipeout <buffer> call timer_stop(g:timer) | unlet! g:timer
    nnoremap <buffer><silent><nowait> <Esc> :call <SID>CloseSplash()<CR>
endfun

function! s:CloseSplash(...)
    execute empty(filter(range(bufnr('$')),{_,v -> buflisted(v)})) ? 'enew' : 'bprevious'
endfunction

function s:AllSplashFiles(ArgLead,CmdLine,CursorPos)
    return join(map(readdir(s:splashDir, {f -> f =~ '\.txt$'}), {_,f -> fnamemodify(f, ':r')}),"\n")
endfunction

let s:splashDir = expand(expand('<sfile>:p:h').'/splash/')
set shortmess+=I
command -nargs=? -complete=custom,<SID>AllSplashFiles Splash call <SID>Splash('<args>')
autocmd VimEnter * if argc()==0 && line2byte('$') == -1 && !&insertmode | call s:Splash() | endif
