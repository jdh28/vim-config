" Vim syntax file

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn clear

syn region  uascriptString       start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region  uascriptAtString     start=+@"+ skip=+\\\\\|\\'+ end=+"+ oneline
syn match   uascriptAction       "^\s*\w\+\(<[\w\.]\+>\)\?"
syn match   uascriptActionAsync  "^\s*&\w\+\(<[\w\.]\+>\)\?"
syn match   uascriptCheck        "^\s*!\w\+\(<[\w\.]\+>\)\?"
syn match   uascriptComment      "#.*$"
syn match   uascriptFunction     "^\.call"
syn match   uascriptFunction     "^\.function"
syn match   uascriptFunction     "^\.end"
syn match   uascriptTimeout      "@\d\+$"


hi def link uascriptComment       Comment
hi def link uascriptString        String
hi def link uascriptFunction      Statement
hi def link uascriptTimeout       PreProc
hi          uascriptAtString      guifg=#ff6080
hi          uascriptAction        guifg=LightGreen
hi          uascriptActionAsync   guifg=DarkGreen
hi          uascriptCheck         guifg=Orange

let b:current_syntax = "uascript"

" vim: ts=8 sw=2

