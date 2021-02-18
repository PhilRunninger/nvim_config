" This script gives you the commands and functions necessary to run SQLServer
" queries (and even DML and DDL statements) from within Vim. The following
" key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" F5 - submit the visual selection to SQLServer
" Ctrl+F5 - use sp_help to describe the table under the cursor
" <leader>F5 - select/create sqlcmd parameter set for logins
" F5 (in the SQl-Results buffer) - rerun the same query
"
" sqlcmd parameters are stored as a Vim dictionary in the .sqlParameters file
" in this file's folder. It is .gitignored to keep that information private.
" The values in the key-value pairs contain whatever parameters are needed to
" connect to the database, for example: `-S server -d database`
"
" Prerequisites
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
"   - EasyAlign is a handy plugin for aligning the text into columns. This is
"     nice, but not necessary.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim is another nice plugin that, among MANY other things, provides
"     nice highlighting for the columns of data. Again, nice, but not needed.
"         https://github.com/chrisbra/csv.vim

function! s:SQLRun(object)
    if !exists('s:sqlParameters')
        call s:GetConnectionInfo()
    endif

    call s:WriteTempFile(a:object)
    call s:RunQuery(a:object != 'word')
endfunction

function! s:GetConnectionInfo()
    let l:choice = 0
    let l:connections = {}
    if filereadable(s:parametersFile)
        execute 'let l:connections = ' . readfile(s:parametersFile)[0]
        let l:list = map(range(1,len(keys(l:connections))), {_,i -> i . ') ' . keys(l:connections)[i-1] . ': ' . l:connections[keys(l:connections)[i-1]]})
        let l:choice = inputlist(insert(l:list,'Select a parameter set. Cancel to create a new one.',0))
    endif

    if !empty(l:connections) && l:choice > 0 && l:choice <= len(keys(l:connections))
        let s:sqlParameters = l:connections[keys(l:connections)[l:choice-1]]
        execute 'setlocal statusline=SQL\ Parameter\ Set:\ ' . escape(keys(l:connections)[l:choice-1], ' ')
    else
        let l:name = input('Enter a name for the connection: ')
        let s:sqlParameters = input('Enter the slqcmd parameters to use: ')
        let l:connections[l:name] = s:sqlParameters
        call writefile([string(l:connections)], s:parametersFile)
        execute 'setlocal statusline=SQL\ Parameter\ Set:\ ' . escape(l:name, ' ')
    endif
endfunction

function! s:WriteTempFile(object)
    let l:iskeyword = &iskeyword
    let l:z = @z
    if a:object == 'paragraph'
        execute "'{,'}write! " . s:sqlTempFile
    elseif a:object == 'selection'
        normal! gv"zy
        call writefile(split(@z,'\n'), s:sqlTempFile)
    elseif a:object == 'word'
        set iskeyword+=46
        set iskeyword+=91
        set iskeyword+=93
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], s:sqlTempFile)
    else
        execute "1,$write! " . s:sqlTempFile
    endif
    let &iskeyword = l:iskeyword
    let @z = l:z
endfunction

function! s:RunQuery(align)
    let s:sqlResults = bufnr('SQL-Results', 1)
    execute 'silent buffer ' . s:sqlResults
    silent normal! ggdG _
    silent execute 'r! sqlcmd ' . s:sqlParameters . ' -s"|" -W -i ' . s:sqlTempFile
    silent 1delete _
    call s:JoinLines()
    call s:AlignColumns(a:align)
    silent setlocal buftype=nofile noswapfile nowrap ft=csv
endfunction

function! s:JoinLines()
    let l:start = 1
    while l:start < line('$')
        call cursor(l:start,1)
        let l:end = search('^\s*(\d\+ rows affected)', 'cW') - 2
        if l:end < l:start
            break
        endif
        let l:required = strchars(substitute(getline(l:start), '[^|]', '', 'g'))
        while l:start < l:end
            let l:rows = 0
            let l:count = strchars(substitute(getline(l:start), '[^|]', '', 'g'))
            while l:count < l:required
                let l:rows += 1
                let l:count += strchars(substitute(getline(l:start + l:rows), '[^|]', '', 'g'))
            endwhile
            if l:rows > 0
                execute l:start.','.(l:start + l:rows).'join!'
                let l:end -= l:rows
            else
                let l:start += 1
            endif
        endwhile
        let l:start = l:end + 3
    endwhile
    silent execute '%s/'.nr2char(13).'$//e'
endfunction

function! s:AlignColumns(align)
    if a:align && exists(':EasyAlign')
        let l:start = 1
        call cursor(l:start,1)
        let l:end = search('^\s*(\d\+ rows affected)', 'cW')
        while l:end > 0
            if l:end - l:start - 3 <= get(g:, 'sqlAlignLimit', 50)
                silent execute l:start . ',' . (l:end-1) . 'call easy_align#align(0,0,"command","* |")'
            endif
            let l:start = l:end+1
            call cursor(l:start,1)
            let l:end = search('^\s*(\d\+ rows affected)', 'W')
        endwhile
    endif
    silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)/\1\r/e'
endfunction

let s:sqlTempFile = get(s:, 'sqlTempFile', tempname())
let s:parametersFile = expand('<sfile>:p:h').'/.sqlParameters'

nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRun('word')<CR>
nnoremap <buffer> <leader><F5> :call <SID>GetConnectionInfo()<CR>

augroup SQLResultsMapping
    autocmd!
    autocmd BufEnter SQL-Results nnoremap <buffer> <F5> <Cmd>:call <SID>RunQuery(1)<CR>
augroup END
