" Vim ftdetect plugin file
" Language: T4 template files
" Maintainer:	Guy Oliver <guy.oliver@gmail.com>
"
" $LastChangedDate $
" $Rev $

au BufRead,BufNewFile *.tt 	set filetype=t4
au BufRead,BufNewFile *.ttinclude 	set filetype=t4
au BufRead,BufNewFile *.tti 	set filetype=t4
