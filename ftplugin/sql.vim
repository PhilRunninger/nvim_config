" This script gives you the abliity to run SQLServer queries from within Vim.
" The following key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" F5 (in visual mode) - submit the visual selection to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" Ctrl+F5 - use sp_help to describe the table under the cursor
" <leader>F5 - select or create new sqlcmd parameter set for command line
" F5 (in the query results buffer) - rerun the same query
"
" sqlcmd parameters are stored as a Vim dictionary in the .sqlParameters file
" in this file's folder. It is .gitignored to keep that information private.
" The dictionary's values contain whatever parameters are needed to connect
" to the database, such as: `-S server -d database -U userid -P password`
"
" Prerequisite and Bonuses
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
"   - EasyAlign aligns the text into columns, but only if it's installed.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim is another nice plugin that, among MANY other things, provides
"     nice highlighting for the columns of data. Again, nice, but not needed.
"         https://github.com/chrisbra/csv.vim

nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRun('word')<CR>
nnoremap <buffer> <leader><F5> :call <SID>GetConnectionInfo()<CR>
imap <buffer> <F5> <Esc><F5>
imap <buffer> <S-F5> <Esc><S-F5>
imap <buffer> <C-F5> <Esc><C-F5>

function! s:SQLRun(object)
    let l:start = reltime()
    if !exists('b:sqlName')
        call s:GetConnectionInfo()
    endif

    call s:WriteTempFile(a:object)
    call s:RunQuery()
    echo 'Finished in ' .  split(reltimestr(reltime(start)))[0] . ' seconds.'
endfunction

let s:sqlParametersFile = expand('<sfile>:p:h').'/.sqlParameters'
let s:sqlParameterSets = {}
if filereadable(s:sqlParametersFile)
    execute 'let s:sqlParameterSets = ' . readfile(s:sqlParametersFile)[0]
endif

function! s:GetConnectionInfo()
    let l:choice = 0
    if !empty(s:sqlParameterSets)
        let l:prompt = ['Select a parameter set. Cancel to create a new one.']
        let l:names = sort(keys(s:sqlParameterSets))
        let l:prompt += map(range(1,len(l:names)), {_,i -> i . ') ' . l:names[i-1] . ': ' . s:sqlParameterSets[l:names[i-1]]})
        let l:choice = inputlist(l:prompt)
    endif

    if !empty(s:sqlParameterSets) && l:choice > 0 && l:choice <= len(l:names)
        let b:sqlName = l:names[l:choice-1]
    else
        let b:sqlName = input('Enter a name for the connection: ')
        let s:sqlParameterSets[b:sqlName] = input('Enter the slqcmd parameters "' . b:sqlName . '" will use: ')
        call writefile([string(s:sqlParameterSets)], s:sqlParametersFile)
    endif
endfunction

let b:sqlTempFile = tempname()

function! s:WriteTempFile(object)
    let l:z = @z
    if a:object == 'paragraph'
        call writefile(getline(line("'{"),line("'}")), b:sqlTempFile)
    elseif a:object == 'selection'
        normal! gv"zy
        call writefile(split(@z,'\n'), b:sqlTempFile)
    elseif a:object == 'word'
        let l:iskeyword = &iskeyword
        set iskeyword+=46
        set iskeyword+=91
        set iskeyword+=93
        normal! "zyiw
        let &iskeyword = l:iskeyword
        call writefile(["sp_help '" . @z ."';"], b:sqlTempFile)
    else
        call writefile(getline(1,line('$')), b:sqlTempFile)
    endif
    let @z = l:z
endfunction

function! s:RunQuery()
    let l:command = 'sqlcmd ' . s:sqlParameterSets[b:sqlName] . ' -s"|" -W -i ' . b:sqlTempFile
    let s:sqlResults = bufnr('SQL Query Results: ' . b:sqlName, 1)
    execute 'silent buffer ' . s:sqlResults
    silent normal! ggdG _
    redraw!
    silent execute 'r! ' . l:command
    redraw!
    call s:JoinLines()
    redraw!
    call s:AlignColumns()
    silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv statusline=%f
    execute 'nnoremap <buffer> <F5> <Cmd>:buffer ' . bufnr('#') . '\|call <SID>RunQuery()<CR>'
endfunction

function! s:JoinLines()
    let l:start = 2
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

function! s:AlignColumns()
    if exists(':EasyAlign')
        silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)/\r\1\r/e'
        silent execute '%s/^\s\+$//e'
        normal! gg
        let l:start = search('^.\+$','W')
        while l:start > 0
            let l:end = line("'}") - 1
            if l:end - l:start - 1 <= get(g:, 'sqlAlignLimit', 100)
                silent execute l:start . ',' . l:end . 'call easy_align#align(0,0,"command","* |")'
            endif
            normal! }
            let l:start = search('^.\+$','W')
        endwhile
    endif
    silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)\(\n^$\)\?/\1\r/e'
    silent 1delete _
endfunction

setlocal statusline=Parameter\ Set:\ %{SqlStatusLine()}\ \|\ %f

function! SqlStatusLine()
    return exists('b:sqlName') ? b:sqlName : '<not selected>'
endfunction
