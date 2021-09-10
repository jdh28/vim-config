set tw=0
set linebreak
set wrap
set encoding=utf-8
let b:EnhCommentifyCommentOpen = '<!!--'
let b:EnhCommentifyCommentClose = '-->'

vmap <Leader>s c<span class=""></span><ESC>6hP`[2hi

setlocal makeprg=msbuild\ /nologo\ /v:q\ /p:BuildFormat=XJHelp\ /p:SuppressCheckExternalLinks=True\ /t:Check\ \\\|\ sed\ -e\ \"s/\[.*\]$//\"
setlocal errorformat=%f(%l):\ warning\ :\ %m,%f(%l):\ error\ :\ %m
setlocal spell

runtime textedit.vim
