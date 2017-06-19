augroup filetypedetect
au BufNewFile,BufRead *.bsdl,*.bsd,*.bsm    setf bsdl
au BufNewFile,BufRead *.csgen               setf cs
au BufNewFile,BufRead *.xjml                setf xjml
au BufNewFile,BufRead *.xje,*.xjpm,*.pdd    setf xjease
au BufNewFile,BufRead *.vbp                 setf vbp
au BufNewFile,BufRead *.wxs,*.wxi,*.targets setf xml
au BufNewFile,BufRead *.log                 setf log
au BufNewFile,BufRead *.\(cs\|vc\|wix\)proj setf xml
au BufNewFile,BufRead .editorconfig         setf editorconfig
au BufNewFile,BufRead testlist.txt          setf testlist
au BufNewFile,BufRead TestList.txt          setf testlist
au BufNewFile,BufRead *.git/worktrees/*/COMMIT_EDITMSG	setf gitcommit
augroup END
