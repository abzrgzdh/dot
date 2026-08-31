setlocal ts=2
setlocal sw=2
setlocal expandtab
setlocal wrap


let markdown_fenced_languages = [ 'html', 'python', 'vim', 'cpp', 'c', 'sh' ]

let b:surround_{char2nr('c')} = "```\r```"
