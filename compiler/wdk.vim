" Vim compiler file
" Compiler:	Microsoft WDK

if exists("current_compiler")
  finish
endif
let current_compiler = "wdk"

" The errorformat for MSVC is the default.
set errorformat=%*\\d>%f(%l)\ :\ error\ %t%n:\ %m,%*\\d>%f(%l)\ :\ error\ :\ %m,%*\\d>%f(%l)\ :\ warning\ %t%n:\ %m,%*\\d>%f\ :\ error\ LNK%n:\ %m,%-G%.%#
set makeprg=build\ -cwI\ 2>&1\ >nul
