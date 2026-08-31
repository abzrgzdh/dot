"" If already loaded, we're done...
"if exists("loaded_vimdic")
"    finish
"endif
"let loaded_vimdic = 1

"=====[ INTERFACE ]==================

" :VimDic or :1VimDic => in a split
" :2VimDic or 3VimDic or ... => in a tab
command! -nargs=0 -count=1 VimDic call VimDictionary(<count>)
nnoremap <leader>? :VimDic<cr>
const s:dictionaryprg = "def --no-color"  " A shell script in path

"=====[ IMPLEMENTATION ]==================


function! VimDictionary (N)
  let l:cword = expand("<cword>")

  const l:bufname_prefix = "vimdic: "
  let l:bufname = l:bufname_prefix .. l:cword

  " Switch to the buffer if it exists already
  if bufloaded(l:bufname)
    exe "buffer " .. l:bufname
    return
  endif

  " If we're in a vimdic buffer then delete it before creating a new buffer
  if match(bufname("%"), "vimdic: ") >= 0
    bdelete!
  endif

  if a:N > 1
    tabnew
  else
    new
  endif

  set buftype=nofile
  set bufhidden="unload"
  nnoremap <buffer> <silent> q :bdelete!<cr>

  exe "file " .. l:bufname

  " Populate the buffer with the output of the vimdic.sh shell command
  :exe "r!" s:dictionaryprg .. " " .. l:cword

  " Delete the first empty line and jump to that location
  0d

  " Jump to the first instance of the requested word
  call search(l:cword)  " why search instance is not highlighted
endfunction
