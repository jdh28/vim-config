if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

let s:line1 = getline(1)
let s:line2 = getline(2)

if s:line1 =~ '^\$' || s:line2 =~ '^\$'
	setfiletype xjtag_cmdline_script
	finish
end

setlocal tw=80
setlocal formatoptions=croq
