if exists("s:done_xjtag_au")
   finish
endif
let s:done_xjtag_au = 1

au BufReadPost c:/projects/xjtag*/dev/src/* ru xjtag.vim
