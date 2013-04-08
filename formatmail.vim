" Version $Revision: 1.4 $
runtime ftplugin/mail.vim
set tw=72
1,3d
1d
1put
1s/^> Sent:/On/e
1s/\s*$//e
2s/^> From: \(.*\) \[mailto:\(.*\)\]\s*$/, \1 <\2> wrote:/e
1
/^> To: /d
1
/^> Cc: /d
1
/^> Subject: /d
1join!
exe "norm! o\<ESC>"
1
exe "norm gqq"
3
