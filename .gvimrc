" John's .gvimrc
" $Revision: 1.7 $

set mousehide
set mousefocus

set lines=50
set columns=110
set guioptions=grmpi

set title titlestring=%t\ -\ VIM

if has("win32")
	set guifont=Consolas:h9,Andale_Mono:h9
	set printfont=Consolas:h9
else
	set guifont=Monospace\ 11
	set printfont=Monospace\ 11
endif
