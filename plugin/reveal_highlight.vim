" Show what highlighting is used under the cursor {{{2
function! s:RevealHighlights(r,c)
    let l:highlights = map(synstack(a:r,a:c), {_,v -> {'name': synIDattr(v,"name"), 'transparent':synIDattr(synIDtrans(v),"name")}})
    if len(l:highlights)
        echo 'Syntax: '
        let i = 0
        while i<len(l:highlights)
            execute 'echohl ' . l:highlights[i].name
            echon l:highlights[i].name
            echohl Normal
            echon '('
            execute 'echohl ' . l:highlights[i].transparent
            echon l:highlights[i].transparent
            echohl Normal
            echon ')'
            if i < len(l:highlights)-1
                echon ' -> '
            endif
            let i += 1
        endwhile
    endif
endfunction

nnoremap <leader>s <Cmd>call <SID>RevealHighlights(line('.'),col('.'))<CR>
