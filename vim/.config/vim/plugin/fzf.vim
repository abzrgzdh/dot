let g:fzf_layout = { 'down': '30%' }

autocmd VimEnter * command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)

" nnoremap <leader>f :Files<CR>
" nnoremap <leader>F :GFiles<CR>

" nnoremap <leader>rg :Rg<Cr>
" nnoremap <leader>h :Helptags<Cr>
