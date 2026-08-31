augroup HelpNoListChars
autocmd!
autocmd FileType help setlocal nolist
augroup END

" Highlight yank
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=400}
augroup END

" Disable auto insertion of comment and friend
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Auto indent for c/c++ files (private: will be deindented)
"    source: https://stackoverflow.com/a/7623017/13041067
augroup CIndentation
autocmd!
autocmd Filetype c,cpp set cindent
autocmd Filetype c,cpp set cinoptions+=g0
augroup END
