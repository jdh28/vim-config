if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal isfname-=,
setlocal path=.,scripts
setlocal tw=0
setlocal formatoptions=croq

nnoremap <buffer> gF :e <cfile><CR>
