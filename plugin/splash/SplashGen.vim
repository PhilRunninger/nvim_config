" vim: foldmethod=marker
" This script is part of an ever-improving process to generate colored splash
" screens. It uses K-Means clustering to reduce many colors down to an
" essential few. (16 or so is probably good enough.) The whole process uses
" Python and this Vim script.
"
" 1. Go to https://www.text-image.com/convert/pic2html.cgi to generate HTML
"    text from the supplied picture.
" 2. Copy the inner HTML of the $('pre') element, and paste in a new buffer.
" 3. Run :SplashGenGetAllColors to put the color codes into the Python
"    code's input file.
" 4. Go to the s:SplashGenConvert function, and follow steps 4a and 4b.
" 5. Save and source this script. Go back into the file containing the HTML.
" 6. Run :SplashGenConvert
" 7. You may need to tweak the text a bit. Clean it up and see how it looks.

" Low-level code lives here.  {{{1
    function! s:SplashGenGetAllColors()
        let l:colors=[]
        let l:allText = join(getline(1,line('$')),'')
        let [l:color,l:start,l:end] = matchstrpos(l:allText,'style="color:\zs[^"]\{-}\ze"')
        while l:end != -1
            if l:color =~ '^#'
                call add(l:colors, printf('%d,%d,%d',str2nr('0x'.l:color[1:2],16),str2nr('0x'.l:color[3:4],16),str2nr('0x'.l:color[5:6],16)))
            elseif l:color == 'black'
                call add(l:colors,'0,0,0')
            elseif l:color == 'gray'
                call add(l:colors,'128,128,128')
            elseif l:color == 'silver'
                call add(l:colors,'192,192,192')
            elseif l:color == 'white'
                call add(l:colors,'225,225,225')
            else
                call add(l:colors,l:color)
            endif
            let [l:color,l:start,l:end] = matchstrpos(l:allText,'style="color:\zs[^"]\{-}\ze"',l:end)
        endwhile
        edit SplashGenPoints.csv
        normal! 1GdG
        call append(0,l:colors)
        sort u
        normal! /^[^,]*$\<CR>
    endfunction

    function! s:SubstituteCharacters(characters)
        for l:i in range(len(s:newColors))
            let ok = search('<b style="color:'.s:newColors[l:i].'"','w')
            while ok
                execute 'normal vitr'.a:characters[l:i].'dst'
                let ok = search('<b style="color:'.s:newColors[l:i].'"','w')
            endwhile
            redraw!
        endfor
        call append(0, "{'align':'c','valign':'c','colors':[" .
                      \ join(map(copy(s:newColors), {i,c -> printf("[['%s'],['%s']]",c,a:characters[i])}),',') .
                      \ "]}")
    endfunction

    function! s:ChangeColor(oldColor, newColor)
        execute 'silent %s/'.a:oldColor.'/'.a:newColor.'/ge'
    endfunction

    command! SplashGenGetAllColors call s:SplashGenGetAllColors()
    command! SplashGenConvert call s:SplashGenConvert()
" }}} 1


function! s:SplashGenConvert()
    call s:ChangeColor('black',  '#000000')
    call s:ChangeColor('gray',   '#808080')
    call s:ChangeColor('silver', '#c0c0c0')
    call s:ChangeColor('white',  '#ffffff')
    " .--------------------------------------------------------------.
    " | 4a. Remove any leftover code between this and the closing    |
    " |     comment blocks.                                          |
    " | 4b. With your cursor between the blocks, run this command.   |
    " |          :r! python SplashGenKMeans.py k                     |
    " |     where k is the number of clusters, up to 62.             |
    " '--------------------------------------------------------------'

    " .--------------------------------------------------------------.
    " | Closing comment block.                                       |
    " '--------------------------------------------------------------'
    call s:SubstituteCharacters('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')  " This must be the last statement.
endfunction
