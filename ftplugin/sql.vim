" Documentation {{{1
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

" Mappings {{{1
nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRun('word')<CR>
nnoremap <buffer> <leader><F5> :call <SID>GetConnectionInfo()<CR>
imap <buffer> <F5> <Esc><F5>
imap <buffer> <S-F5> <Esc><S-F5>
imap <buffer> <C-F5> <Esc><C-F5>

function! s:SQLRun(object) " {{{1
    if !exists('b:sqlParmKey')
        call s:GetConnectionInfo()
    endif

    call s:WriteTempFile(a:object)
    call s:GotoResultsBuffer(expand('%:t:r'), b:sqlParmKey, b:sqlTempFile)
    call s:RunQuery()
endfunction


function! s:GetConnectionInfo() " {{{1
    let l:choice = 0
    if !empty(s:sqlParms)
        let l:prompt = ['Select a parameter set. Cancel to create a new one.']
        let l:names = sort(keys(s:sqlParms))
        let l:prompt += map(range(1,len(l:names)), {_,i -> i . ') ' . l:names[i-1] . ': ' . s:sqlParms[l:names[i-1]]})
        let l:choice = inputlist(l:prompt)
    endif

    if !empty(s:sqlParms) && l:choice > 0 && l:choice <= len(l:names)
        let b:sqlParmKey = l:names[l:choice-1]
    else
        let b:sqlParmKey = input('Enter a name for the connection: ')
        let s:sqlParms[b:sqlParmKey] = input('Enter the slqcmd parameters "' . b:sqlParmKey . '" will use: ')
        if b:sqlParmKey != ''
            call writefile([string(s:sqlParms)], s:sqlParmsFile)
        endif
    endif
endfunction

function! s:WriteTempFile(object) " {{{1
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

function! s:GotoResultsBuffer(sqlQueryBuffer, sqlParmKey, sqlTempFile) " {{{1
    let l:bufferName = a:sqlQueryBuffer . ' @ ' . a:sqlParmKey
    let l:bufNum = bufnr(l:bufferName, 1)
    let l:winnr = bufwinnr(l:bufferName)
    if l:winnr == -1
        execute 'silent split ' . l:bufferName
        silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv statusline=Query\ Results:\ %f
        nnoremap <buffer> <F5> <Cmd>call <SID>RunQuery()<CR>
    else
        execute l:winnr . 'wincmd w'
    endif
    let b:sqlParmKey = a:sqlParmKey
    let b:sqlTempFile = a:sqlTempFile
endfunction

function! s:RunQuery() " {{{1
    " We're in the Results buffer now.
    let l:start = reltime()
    silent normal! ggdG _
    echon 'Querying...  '
    redraw!
    silent execute 'r! sqlcmd ' . s:sqlParms[b:sqlParmKey] . ' -s"|" -W -i ' . b:sqlTempFile
    echon 'Fixing line breaks...  '
    redraw!
    call s:JoinLines()
    echon 'Aligning columns...  '
    redraw!
    call s:AlignColumns()

    if exists(':CSVInit')
        let b:delimiter = '|'
        CSVInit!
    endif

    echon 'Finished in ' .  split(reltimestr(reltime(l:start)))[0] . ' seconds.'
endfunction

function! s:JoinLines() " {{{1
    let l:start = 2
    while l:start < line('$')
        call cursor(l:start,1)
        let l:end = search('^\s*(\d\+ rows affected)', 'cW') - 2
        if l:end < l:start
            break
        endif
        let l:required = count(getline(l:start), '|')
        while l:start < l:end
            let l:rows = 0
            let l:count = count(getline(l:start), '|')
            while l:count < l:required
                let l:rows += 1
                let l:count += count(getline(l:start + l:rows), '|')
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

function! s:AlignColumns() " {{{1
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

function! SqlParameters() " {{{1
    return exists('b:sqlParmKey') ? b:sqlParmKey : '<not selected>'
endfunction

" Start Here {{{1
setlocal statusline=Parameter\ Set:\ %{SqlParameters()}\ \|\ %f

let s:sqlParmsFile = expand('<sfile>:p:h').'/.sqlParameters'
let s:sqlParms = {}
if filereadable(s:sqlParmsFile)
    execute 'let s:sqlParms = ' . readfile(s:sqlParmsFile)[0]
endif

let b:sqlTempFile = tempname()

" vim: foldmethod=marker
