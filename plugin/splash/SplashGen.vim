" vim: foldmethod=marker
" This script is part of an ever-improving process to generate colored splash
" screens. It uses K-Means clustering to reduce many colors down to an
" essential few. (16 or so is probably good enough.) The whole process uses
" Python and this Vim script.
"
" 1. Go to https://www.text-image.com/convert/pic2html.cgi to generate HTML
"    text from the supplied picture.
" 2. Copy the inner HTML of the $('pre') element, and paste in a new buffer.
" 3. :SplashGenGetAllColors    to put the color codes into the Python
"    code's input file.
" 4. :term python SplashGenKMeans.py    to cluster the color codes. If you
"    want more or fewer than 16 colors, edit the Python code. 36 is the max
"    without changing s:characters too.
" 5. Copy the 1st line and paste it into the s:newColors list.
" 6. Copy the generated function calls and paste them into SplashGenConvert.
" 7. Save and source this script. Go back into the file containing the HTML.
" 8. :SplashGenConvert
" 9. Clean up the image and the give it a try.

" Low-level code lives here.  {{{1
    function! s:SplashGenGetAllColors()
        let l:colors=[]
        let l:allText = join(getline(1,line('$')),'')
        let [l:color,l:start,l:end] = matchstrpos(l:allText,'color="\zs[^"]\{-}\ze"')
        while l:end != -1
            if l:color =~ '^#'
                call add(l:colors, printf('%d,%d,%d',str2nr('0x'.l:color[1:2],16),str2nr('0x'.l:color[3:4],16),str2nr('0x'.l:color[5:6],16)))
            else
                call add(l:colors,l:color)
            endif
            let [l:color,l:start,l:end] = matchstrpos(l:allText,'color="\zs[^"]\{-}\ze"',l:end)
        endwhile
        edit SplashGenPoints.csv
        normal! 1GdG
        call append(0,l:colors)
        sort u
        normal! /^[^,]*$\<CR>
    endfunction

    function! s:SubstituteCharacters()
        for l:i in range(len(s:newColors))
            let ok = search('<font color="'.s:newColors[l:i],'w')
            while ok
                execute 'normal vitr'.s:characters[l:i].'dst'
                let ok = search('<font color="'.s:newColors[l:i],'w')
            endwhile
            redraw!
        endfor
        call append(0, "{'align':'c','valign':'c','colors':[" .
                      \ join(map(copy(s:newColors), {i,c -> printf("[['%s'],['%s']]",c,s:characters[i])}),',') .
                      \ "]}")
    endfunction

    function! s:ChangeColor(oldColor, newColor)
        execute 'silent %s/'.a:oldColor.'/'.a:newColor.'/ge'
    endfunction

    command! SplashGenGetAllColors call s:SplashGenGetAllColors()
    command! SplashGenConvert call s:SplashGenConvert()
" }}} 1

let s:characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'  " 36 colors (clusters) is the maximum.
let s:newColors = [ '#419039','#f1f2f1','#182117','#828282','#5ec861','#444544','#a3a3a3','#31692a','#80e58f','#6adf33','#090d09','#d8d8d8','#bebfbe','#253d23','#50ab4c','#616161',
                  \ '#ffffff'] " Keep #ffffff here so the background characters can be removed.

function! s:SplashGenConvert()
    execute '%s/<br>/\r/g'
    " Paste generated function calls from Python output below this line.

    call s:ChangeColor('white', '#ffffff') " Keep #ffffff here so the background characters can be removed.
    call s:SubstituteCharacters()  " This must be the last statement.
endfunction
