nmap <buffer> <leader>p 0Rpick<ESC>0
nmap <buffer> <leader>r 0Rreword<ESC>0
nmap <buffer> <leader>e 0Redit<ESC>0
nmap <buffer> <leader>s 0Rsquash<ESC>0
nmap <buffer> <leader>f 0Rfixup<ESC>0
nmap <buffer> <leader>x 0Rexec<ESC>0

%s/^pick \S\@=/pick   /e
%s/^fixup \S\@=/fixup  /e
set nohls
