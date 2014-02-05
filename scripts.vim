" This file is used automatically by vim to detect the filetype from the
" file's contents.

if did_filetype()	" filetype already set..
	finish		" ..don't do these checks
endif

let s:line1 = getline(1)
let s:line2 = getline(2)

if s:line1 =~ '^\$' || s:line2 =~ '^\$'
	setfiletype xjtag_cmdline_script
elseif s:line1 =~ '^### FILE UPLOAD PREVIEW' && expand("%:t") =~ 'edit-list.*\.txt$'
	setfiletype ccollab
endif

unlet s:line1 s:line2
