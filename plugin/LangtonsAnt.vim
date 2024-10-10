command! -nargs=* Langton :call <SID>Langton(<f-args>)

function! s:Random(...)
    if a:0 && (type(a:1) != v:t_number || a:1 < 1)
        throw 'Error in call Random(' . a:1 . ') - optional argument must be a positive integer.'
    endif

    if a:0
        return luaeval('math.random(' . a:1 . ') - 1')
    else
        return luaeval('math.random()')
    endif
endfunction

function! s:Langton(count = 1, explosionRadius=10)
    tabnew
    setlocal buftype=nofile bufhidden=wipe
    setlocal nonumber norelativenumber signcolumn=no nolist nocursorline nocursorcolumn
    let b:height = 2 * getwininfo(win_getid())[0]['height']
    let b:width = getwininfo(win_getid())[0]['width']
    while get(b:, 'interrupt', 0) != 27
        let b:interrupt = getchar(0)
        execute "setlocal statusline=Langton's\\ Ant\\ \\ ".a:count."\\ \\ [Space:\\ restart\\ \\ Esc:\\ quit]"
        normal! ggdG
        call append(0, map(range(b:height/2), {_ -> repeat(' ', b:width)}))
        normal! gg
        let b:pos = map(range(a:count), {_ -> [s:Random(b:height), s:Random(b:width), s:Random(4)]})  " [row, col, direction]
        while b:interrupt != 32 && b:interrupt != 27 && len(b:pos) > 0
            let b:interrupt = getchar(0)
            for i in range(len(b:pos))
                let cellIsOn = s:Flip(b:pos[i])
                let b:pos[i] = s:TurnAndMove(cellIsOn, b:pos[i])
            endfor
            let collisions = map(copy(b:pos), {_,v -> [v[0],v[1]]})
            let collisions = map(copy(collisions), {_,v -> count(collisions, v)})
            for i in range(len(collisions)-1, 0, -1)
                if collisions[i] > 1
                    for r in range(a:explosionRadius+1)
                        for c in range(float2nr(sqrt(a:explosionRadius*a:explosionRadius - r*r)))
                            call s:Flip([(b:pos[i][0]-r+b:height) % b:height, (b:pos[i][1]-c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]-r+b:height) % b:height, (b:pos[i][1]+c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]+r+b:height) % b:height, (b:pos[i][1]-c+b:width) % b:width, 0], 'off')
                            call s:Flip([(b:pos[i][0]+r+b:height) % b:height, (b:pos[i][1]+c+b:width) % b:width, 0], 'off')
                        endfor
                    endfor
                    call remove(b:pos, i)
                    execute "setlocal statusline=Langton's\\ Ant\\ \\ ".len(b:pos)."/".a:count."\\ \\ [Space:\\ restart\\ \\ Esc:\\ quit]"
                endif
            endfor
            redraw!
        endwhile
    endwhile
    bwipeout
endfunction

function! s:Flip(pos, mode='toggle')
    let line = getline(1+a:pos[0]/2)
    let cell = strcharpart(line, a:pos[1], 1)
    let idx = index(['toggle','off','on'], a:mode)*2 + (a:pos[0] % 2)
    let charSet = {'█': '▄▀▄▀██', '▀': ' █ ▀▀█', '▄': '█ ▄ ██', ' ': '▀▄  ▀▄'}
    let line = strcharpart(line, 0, a:pos[1]) . strcharpart(charSet[cell],idx,1) . strcharpart(line, a:pos[1]+1)
    call setline(1+a:pos[0]/2, line)
    return (cell == '█') ||
         \ (cell == '▀' && (a:pos[0] % 2 == 0)) ||
         \ (cell == '▄' && (a:pos[0] % 2 == 1))
endfunction

function! s:TurnAndMove(cellIsOn, pos)
    let direction = (a:pos[2] + (a:cellIsOn ? 1 : 3)) % 4
    return [(a:pos[0] + b:height + [-1,0,1,0][direction]) % b:height,
         \  (a:pos[1] + b:width + [0,1,0,-1][direction]) % b:width,
         \  direction]
endfunction
