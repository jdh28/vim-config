if exists("b:current_syntax")
  finish
endif

syn match    editorconfigHeading        "\[.*\]"
syn match    editorconfigVariableDef    "\(.*\)="
syn region   editorconfigString         start=+"+ skip=+\\"+ end=+"+
syn match    editorconfigComment        "#.*$"
syn keyword  editorconfigBoolean true false
syn keyword  editorconfigKeyword none suggestion warning error


hi def link editorconfigComment     Comment
hi def link editorconfigHeading     Special         
hi def link editorconfigVariableDef Identifier
hi def link editorconfigString      String
hi def link editorconfigVariableSub Identifier
hi def link editorconfigBoolean     Keyword
hi def link editorconfigKeyword     Constant
