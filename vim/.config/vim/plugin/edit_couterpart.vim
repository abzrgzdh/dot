
" " switch between the header/source counterpart
" function! Edit_Counterpart() abort
"     let l:ext = expand('%:e')
"     " OpenFOAM
"     if ext ==# 'c'
"         if filereadable(expand('%:r') . '.h')
"             e %:r.h
"         endif
"     elseif ext ==# 'C'
"         if filereadable(expand('%:r') . '.H')
"             e %:r.H
"         endif
"     elseif ext ==# 'h'
"         if filereadable(expand('%:r') . '.c')
"             e %:r.c
"         endif
"     elseif ext ==# 'H'
"         if filereadable(expand('%:r') . '.C')
"             e %:r.C
"         endif
"     endif
" endfunction
" nnoremap <silent> <CR> :call Edit_Counterpart()<CR>

