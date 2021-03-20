" Confirmation upon quitting to preserve window setup for sessions.
function s:QueryQuit()
    if tabpagenr('$') > 1 || winnr('$') > 1
        let choice = confirm("Quit all?", "&Yes\n&No\n&Cancel", 1)
        if choice == 1
            quitall
        elseif choice == 2
            quit
            echo "Use <C-W>c next time!"
        endif
    else
        quit
    endif
endfunction

cnoreabbrev <silent> q call <SID>QueryQuit()
