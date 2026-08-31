" Checks to see
function! CtagGen() abort
    let dir = finddir('.git/..', expand('%:p:h').';')
    if empty(dir) == 1
        echohl WarningMsg
        echomsg "Warning: Could not find the project root. (Tags is not generated)"
        echohl None
        return
    endif
    let cmd = 'ctags -R --tag-relative=yes --extra=+f -f' . dir . '/.tags ' . '--languages=-javascript,sql '
    call system(cmd)
    if v:shell_error
        echohl ErrorMsg
        echomsg "Ctags: FAILED!"
        echohl None
    else
        echohl MoreMsg
        echomsg "Ctags: DONE!"
        echohl None
    endif
endfunction


nnoremap <leader>t :call CtagGen()<cr>
