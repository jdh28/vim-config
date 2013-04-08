if exists("s:done_xjtag")
   finish
endif
let s:done_xjtag = 1

set path=.,include/,../../utils/include,c:/Program\\\ Files/Microsoft\\\ SDK/include,c:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio/vc98/include/,C:/Program\\\ Files/WINDDK/2600.1106/inc
set tags=tags,../../utils/tags,c:/Program\\\ Files/Microsoft\\\ SDK/include/tags,c:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio/vc98/include/tags,C:/Program\\\ Files/WINDDK/2600.1106/inc/tags

autocmd BufReadPost debug_config.h
			\ syn region cUnDefine start="^\s*#\s*undef\>" skip="\\$"
			\            end="$" end="//"me=s-1 contains=ALLBUT,@cPreProcGroup |
			\ hi link cUnDefine cString
