function! Pylint() abort
    setlocal makeprg=pylint\ --output-format=parseable\ %
    if exists(":Make")
        :w | Make
    else
        :w | make
    endif
endfunction

augroup PyLint
    autocmd!
    autocmd BufEnter,BufRead,BufReadPre,BufWinEnter,FileType python
                \ nnoremap <buffer> <silent> <leader>l :call Pylint()<CR>
augroup END


function! PythonFormatter() abort
    " Hand your saved buffer to formatter, otherwise you'll lose your changes
    :silent write

    " Specify formatter (Current Options: black, autopep8)
    let l:formatter = 'black'

    if l:formatter == 'black'
        :call system('black ' . expand('%'))
    elseif l:formatter == 'autopep8'
        :call system('autopep8 --in-place --aggressive --aggressive ' . expand('%'))
    endif

    " Grab status code of code formatter
    let l:format_status = 1
    if v:shell_error != 0
        let l:format_status = 0
    endif

    " Sort import statements
    :call system('isort --ws ' . expand('%'))

    :silent! e!

    " Inform user about the status of format operation
    if l:format_status == 1
        echo "[" . toupper(l:formatter) . "]: DONE!"
    else
        echo "[" . toupper(l:formatter) ."]: FAILED!" 
    endif
endfunction

augroup PythonFormat
    autocmd!
    autocmd BufEnter,BufWrite,BufWritePre,FileType python
        \ nnoremap <silent> <leader>= :call PythonFormatter()<CR>
augroup END
