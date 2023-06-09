" Show what highlighting is used under the cursor
function! s:RevealHighlights(r,c)
    let l:highlights = map(synstack(a:r,a:c), {_,v -> {'name': synIDattr(v,'name'), 'transparent':synIDattr(synIDtrans(v),'name'), 'fg':synIDattr(synIDtrans(v),'fg'), 'bg':synIDattr(synIDtrans(v),'bg')}})
    echo string(synstack(a:r,a:c))
    if len(l:highlights)
        let lines = []
        let i = 0
        while i<len(l:highlights)
            call add(lines,
                \ (i > 0 ? repeat('  ',i) . '⤷ ' : '') .
                \ l:highlights[i].name .
                    \ '(' . l:highlights[i].transparent .
                    \ ' fg=' . l:highlights[i].fg .
                    \ ' bg=' . l:highlights[i].bg . ')')
            let i += 1
        endwhile

        let buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(buf, 0, -1, v:true, lines)
        let opts = {'width':max(map(lines,{_,v -> strchars(v)})), 'height':len(lines),
                    \ 'relative':'win', 'bufpos':[a:r,a:c], 'row':0, 'style':'minimal',
                    \ 'border':'rounded'}
        let win = nvim_open_win(buf, 0, opts)

        call timer_start(5000, {-> nvim_win_close(win, 0)})
    endif
endfunction

nnoremap <leader>s :call <SID>RevealHighlights(line('.'),col('.'))<CR>
