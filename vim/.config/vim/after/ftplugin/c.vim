" nnoremap <leader>= :w <bar>call system("clang-format -style=file -i " . expand('%')) <bar> silent! edit<CR>

setlocal commentstring=//\ %s
" setlocal noexpandtab
" setlocal ts=8 sw=8

setlocal path=**
setlocal path+=/opt/homebrew/Cellar/llvm/16.0.6/include/c++/v1/,/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/



function! CFormatter() abort
    " Hand your saved buffer to formatter, otherwise you'll lose your changes
    :silent write

    :call system('clang-format -i ' . expand('%'))

    " Grab status code of code formatter
    let l:format_status = 1
    if v:shell_error != 0
        let l:format_status = 0
    endif

    :silent! e!

    " Inform user about the status of format operation
    if l:format_status == 1
        echo "[" . toupper('clang-format') . "]: DONE!"
    else
        echo "[" . toupper('clang-format') ."]: FAILED!" 
    endif
endfunction

nnoremap <buffer> <silent> <leader>= :call CFormatter()<CR>
