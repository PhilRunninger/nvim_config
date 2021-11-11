" Test results will appear as comments at the top of the test file.
function! EasyAlignStressTest(...)
    let l:rows = get(a:, '1', 100)
    let l:columns = get(a:, '2', 10)
    let l:maxwidth = get(a:, '3', 50)
    let l:run = 1
    while l:run == 1
        normal! gg0
        if search('^"EOF','w') == 0
            call append(line('$'),['"EOF - Test data appear below this line.',''])
            call search('^"EOF','w')
        endif
        normal! jdG
        let l:rows = str2nr(input('Row Count: ', l:rows))
        let l:columns = str2nr(input('Column Count: ', l:columns))
        let l:maxwidth = str2nr(input('Max Column Width: ', l:maxwidth))
        let l:textRows = map(range(1,l:rows),
                \ {_,r -> join(map(range(1,l:columns),
                    \ {_,c -> repeat(nr2char(48+c%75), float2nr((1+sin(c*r*0.017453))*c))[:(l:maxwidth-1)]}), '|')})
        call append(line('$'),l:textRows)
        let l:time=reltime()
        redraw!
        execute '/^"EOF/+1,$call easy_align#align(0,0,"command","* |")'
        let l:time=reltimefloat(reltime(l:time))
        call append(0, printf('" %6d rows x %6d columns: %f seconds', l:rows, l:columns, l:time))
        normal! gg
        redraw!
        let l:run = confirm('Another test? ', "&Yes\n&No", 1)
    endwhile
endfunction

command! -nargs=* EasyAlignStressTest call EasyAlignStressTest(<f-args>)
