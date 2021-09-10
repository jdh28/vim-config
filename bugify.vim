" useful mapping for making Bugzilla links

nmap <Leader>b ciw<a href="https://bugs/bugzilla/show_bug.cgi?id=><ESC>Pa"><ESC>pa</a<ESC>
vmap <Leader>b :s!\(\<\d\{4,5\}\>\)!<a href="https://bugs/bugzilla/show_bug.cgi?id=\1">\1</a>!g<CR>
