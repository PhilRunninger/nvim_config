command! -nargs=? Langton :call <SID>Langton(<args>)

" s:charSet defines the transition from one       .---> toggle even row
" character to the next. The key is the           |.---> toggle odd row
" starting character (two cells), and the         ||.---> turn off even row
" value is a string of different ending           |||.---> turn off odd row
" characters, depending on the type of            ||||.---> turn on even row
" transition and the cell row being changed.      |||||.---> turn on odd row
"                                                 ||||||
"      For example, starting with this ---> '█': '▄▀▄▀██'
let s:charSet = {'█': '▄▀▄▀██', '▀': ' █ ▀▀█', '▄': '█ ▄ ██', ' ': '▀▄  ▀▄'}

function! s:Random(...)
    let num = map(range(3), {_ -> fmod(reltimefloat(reltime()),1) * 1.0e6})
    let num = fmod(num[0]*num[1]*num[2], 2038074743) / 2038074743.0
    return a:0 ? float2nr(num*a:1) : num
endfunction

function! s:Langton(count = 1)
    tabnew
    setlocal buftype=nofile bufhidden=wipe
    setlocal nonumber signcolumn=no nolist nocursorline nocursorcolumn
    let b:height = 2 * getwininfo(win_getid())[0]['height']
    let b:width = getwininfo(win_getid())[0]['width']
    while get(b:, 'interrupt', 0) != 27
        let b:interrupt = getchar(0)
        execute "setlocal statusline=Langton's\\ Ant\\ \\ ".a:count
        normal! ggdG
        call append(0, map(range(b:height/2), {_ -> repeat(' ', b:width)}))
        normal! gg
        let b:pos = map(range(a:count), {_ -> [s:Random(b:height), s:Random(b:width), s:Random(4)]})  " [row, col, direction]
        while b:interrupt != 32 && b:interrupt != 27 && len(b:pos) > 0
            let b:interrupt = getchar(0)
            for i in range(len(b:pos))
                let cell = s:Flip(b:pos[i])
                let b:pos[i] = s:TurnAndMove(cell, b:pos[i])
            endfor
            let l:u = map(copy(b:pos), {_,v -> [v[0],v[1]]})
            let l:u = map(copy(l:u), {_,v -> count(l:u, v)})
            for i in range(len(l:u)-1, 0, -1)
                if l:u[i] > 1
                    for r in range(11)
                        for c in range(float2nr(sqrt(100-r*r)))
                            call s:Flip([(b:pos[i][0]-r+b:height) % b:height, (b:pos[i][1]-c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]-r+b:height) % b:height, (b:pos[i][1]+c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]+r+b:height) % b:height, (b:pos[i][1]-c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]+r+b:height) % b:height, (b:pos[i][1]+c+b:width) % b:width, 0], 'off')
                        endfor
                    endfor
                    call remove(b:pos, i)
                    execute "setlocal statusline=Langton's\\ Ant\\ \\ ".len(b:pos)."/".a:count
                endif
            endfor
            redraw!
        endwhile
    endwhile
    bwipeout
endfunction

function! s:Flip(pos, mode='toggle')
    let idx = index(['toggle','off','on'], a:mode)*2 + (a:pos[0]%2)
    let line = getline(1+a:pos[0]/2)
    let cell = strcharpart(s:charSet[strcharpart(line, a:pos[1], 1)], idx, 1)
    let line = strcharpart(line, 0, a:pos[1]) . cell . strcharpart(line, a:pos[1]+1)
    call setline(1+a:pos[0]/2, line)
    return cell
endfunction

function! s:TurnAndMove(cell, pos)
    let cellIsOn = (a:cell == '█') ||
                 \ (a:cell == '▀' && (a:pos[0] % 2 == 0)) ||
                 \ (a:cell == '▄' && (a:pos[0] % 2 == 1))
    let direction = (a:pos[2] + (cellIsOn ? 1 : 3)) % 4
    return [(a:pos[0] + b:height + [-1,0,1,0][direction]) % b:height,
         \  (a:pos[1] + b:width + [0,1,0,-1][direction]) % b:width,
         \  direction]
endfunction
