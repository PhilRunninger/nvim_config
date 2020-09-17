" Show what highlighting is used under the cursor {{{2
function! s:RevealHighlights(r,c)
    let l:highlights = map(synstack(a:r,a:c), {_,v -> {'name': synIDattr(v,'name'), 'transparent':synIDattr(synIDtrans(v),'name'), 'fg':synIDattr(synIDtrans(v),'fg'), 'bg':synIDattr(synIDtrans(v),'bg')}})
    echo string(synstack(a:r,a:c))
    if len(l:highlights)
        echo 'Syntax for: '.expand('<cword>').'  at location '.a:r.','.a:c
        echo ''
        let i = 0
        while i<len(l:highlights)
            execute 'echohl ' . l:highlights[i].name
            echon l:highlights[i].name
            echohl Normal
            echon '('
            execute 'echohl ' . l:highlights[i].transparent
            echon l:highlights[i].transparent
            echohl Normal
            echon ' fg=' . l:highlights[i].fg . ' bg=' . l:highlights[i].bg
            echon ')'
            if i < len(l:highlights)-1
                echo repeat('  ',i).' -> '
            endif
            let i += 1
        endwhile
    endif
endfunction

nnoremap <leader>s <Cmd>call <SID>RevealHighlights(line('.'),col('.'))<CR>
