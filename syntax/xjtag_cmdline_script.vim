" Vim syntax file

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn keyword	xjtagscriptTodo	contained TODO FIXME XXX
syn match	xjtagscriptComment	"^#.*" contains=xjtagscriptTodo
syn region	xjtagscriptString	start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region	xjtagscriptString	start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline

syn match   xjtagscriptStartEnd "^[\$.].*"
syn match   xjtagscriptIgnoreError "^\s*\*.*"
syn match   xjtagscriptError       "^\s*!.*"
syn match   xjtagscriptBadOutput   "^\s*\^.*"
syn match   xjtagscriptOutput      "^\s*<.*"
syn match   xjtagscriptInput       "^>.*"

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link xjtagscriptComment	Comment
hi def link xjtagscriptTodo	Todo
hi def link xjtagscriptString	String

hi xjtagscriptStartEnd guifg=DarkCyan
hi xjtagscriptIgnoreError guifg=Red
hi xjtagscriptError guifg=Red gui=bold
hi xjtagscriptBadOutput guifg=LightRed
hi xjtagscriptOutput guifg=gray50
hi xjtagscriptInput guifg=White gui=bold

let b:current_syntax = "xjtag_cmdline_script"

" vim: ts=8 sw=2

