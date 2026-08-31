" https://stackoverflow.com/a/76951708/13041067
setlocal isfname+=(,)
setlocal isfname+={,}
setlocal includeexpr=substitute(v:fname,'\\$(\\(.\\{-}\\))','\\=getenv(submatch(1))','g')
