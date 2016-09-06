set tw=0
set linebreak
set wrap
let b:EnhCommentifyCommentOpen = '<!!--'
let b:EnhCommentifyCommentClose = '-->'

vmap <Leader>s c<span class=""></span><ESC>6hP`[2hi

setlocal makeprg=msbuild\ /nologo\ /v:q\ /t:Check\ \\\|\ sed\ -e\ \"s/\[.*\]$//\"
setlocal errorformat=%f(%l):\ warning\ :\ %m,%f(%l):\ error\ :\ %m

runtime textedit.vim
