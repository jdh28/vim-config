" Vim syntax file

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  "finish
endif

syn clear

syn region  uascriptString        start=+"+ skip=+\\\"+ end=+"+ oneline contains=uascriptKeystroke,uascriptAbsPath
syn region  uascriptAtString      start=+@"+ skip=+\\\"+ end=+"+ oneline contains=uascriptKeystroke,uascriptAbsPath
syn region  uascriptRegex         start=+\/+ skip=+\\\/+ end=+\/+ oneline
syn match   uascriptAction        "^\s*+\?\w\+\(<[^>]\+>\)\?"
syn match   uascriptActionAsync   "^\s*+\?&\w\+\(<[^>]\+>\)\?"
syn match   uascriptCheck         "^\s*+\?!\w\+\(<[^>]\+>\)\?"
syn match   uascriptComment       "#.*$"
syn match   uascriptFunction      "^\s*\.call\>" nextgroup=uascriptFunctionName skipwhite
syn match   uascriptFunction      "^\.function\>" nextgroup=uascriptFunctionName skipwhite
syn match   uascriptFunction      "^\.end\>"
syn match   uascriptTimeout       "@\d\+$"
syn match   uascriptKeystroke     contained "\[[A-Z0-9+]\+\]"
syn match   uascriptAbsPath       contained "|\S\+|"
syn match   uascriptAbsPathAlone  "|\S\+|" contains=uascriptVariable
syn match   uascriptVariable      "\$[A-Za-z0-9_]\+"
syn match   uascriptPrivateAccess "\<m_\w\+"
syn region  uascriptIf            start="\.if" end="\.endif" keepend contains=uascriptIfKeyword,uascriptIfCond,uascriptString,uascriptAtString,uascriptRegex,uascriptAction,uascriptActionAsync,uascriptCheck,uascriptComment,uascriptFunction,uascriptFunction,uascriptFunction,uascriptTimeout,uascriptAbsPathAlone,uascriptVariable,uascriptPrivateAccess
syn match   uascriptIfKeyword     contained "\.if" nextgroup=uascriptIfCond skipwhite
syn match   uascriptIfKeyword     contained "\.else"
syn match   uascriptIfKeyword     contained "\.endif"
syn match   uascriptIfCond        contained "\<Check\S\+"
syn match   uascriptFunctionName  contained "[A-Za-z0-9_]\+"

hi def link uascriptComment       Comment
hi def link uascriptString        String
hi def link uascriptFunction      Statement
hi def link uascriptIfKeyword     Statement
hi def link uascriptTimeout       PreProc
hi def link uascriptVariable      Identifier
hi def link uascriptFunctionName  Identifier
hi def link uascriptPrivateAccess Error
hi          uascriptAtString      guifg=#ff6080
hi          uascriptRegex         guifg=#c0a0ff
hi          uascriptAction        guifg=LightGreen
hi          uascriptActionAsync   guifg=DarkGreen
hi          uascriptCheck         guifg=Orange
hi def link uascriptIfCond        uascriptCheck
hi          uascriptKeystroke     gui=bold guifg=#ffc0c0
hi          uascriptAbsPath       gui=bold guifg=#c000c0
hi          uascriptAbsPathAlone  gui=bold guifg=#c000c0

let b:current_syntax = "uascript"

" vim: ts=8 sw=2

