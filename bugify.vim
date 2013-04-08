" useful mapping for making Bugzilla links

nmap <Leader>b ciw<a href="http://bugs/bugzilla/show_bug.cgi?id=><ESC>Pa"><ESC>pa</a<ESC>
vmap <Leader>b :s,\(\<\d\{4\}\>\),<a href="http://bugs/bugzilla/show_bug.cgi?id=\1">\1</a>,g<CR>
