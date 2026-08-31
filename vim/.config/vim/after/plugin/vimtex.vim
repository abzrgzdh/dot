let g:tex_flavor='latex'

let g:vimtex_view_method='skim'

let g:vimtex_quickfix_mode=0

let g:tex_conceal='abdmg'

let g:vimtex_complete_enabled=1

"let g:vimtex_fold_enabled=1

" Skim settings (MacOS)
"
" Skim Sync Settings:
"     PDF-Tex Sync Support:
"     Preset: Custom
"     Command: nvim
"     Arguments: --headless -c "VimtexInverseSearch %line '%file'"
"
" Value 1 allows forward search after every successful compilation
let g:vimtex_view_skim_sync = 1
" Value 1 allows change focus to skim after command `:VimtexView` is given
let g:vimtex_view_skim_activate = 1

" Supress VimTeX warnings in quickfix view (:copen)
let g:vimtex_quickfix_ignore_filters = [
    \"Underfull",
    \"Overfull",
    \"specifier changed to",
    \"You have requested",
    \"Missing number, treated as zero.",
    \"There were undefined references",
    \"Citation %.%# undefined",
    \"without twoside option",
    \]
