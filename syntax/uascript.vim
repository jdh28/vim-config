" Vim syntax file

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  "finish
endif

syn clear

syn region  uascriptString       start=+"+ skip=+\\\"+ end=+"+ oneline contains=uascriptKeystroke,uascriptAbsPath
syn region  uascriptAtString     start=+@"+ skip=+\\\"+ end=+"+ oneline contains=uascriptKeystroke,uascriptAbsPath
syn region  uascriptRegex        start=+\/+ skip=+\\\/+ end=+\/+ oneline
syn match   uascriptAction       "^\s*\w\+\(<[^>]\+>\)\?"
syn match   uascriptActionAsync  "^\s*&\w\+\(<[^>]\+>\)\?"
syn match   uascriptCheck        "^\s*!\w\+\(<[^>]\+>\)\?"
syn match   uascriptComment      "#.*$"
syn match   uascriptFunction     "^\s*\.call\s\+\S\+"
syn match   uascriptFunction     "^\.function"
syn match   uascriptFunction     "^\.end"
syn match   uascriptTimeout      "@\d\+$"
syn match   uascriptKeystroke    contained "\[[A-Z0-9+]\+\]"
syn match   uascriptAbsPath      contained "|\S\+|"
syn match   uascriptAbsPathAlone "|\S\+|"


hi def link uascriptComment       Comment
hi def link uascriptString        String
hi def link uascriptFunction      Statement
hi def link uascriptTimeout       PreProc
hi          uascriptAtString      guifg=#ff6080
hi          uascriptRegex         guifg=#c0a0ff
hi          uascriptAction        guifg=LightGreen
hi          uascriptActionAsync   guifg=DarkGreen
hi          uascriptCheck         guifg=Orange
hi          uascriptKeystroke     gui=bold guifg=#ffc0c0
hi          uascriptAbsPath       gui=bold guifg=#c000c0
hi          uascriptAbsPathAlone  gui=bold guifg=#c000c0

let b:current_syntax = "uascript"

" vim: ts=8 sw=2

