" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match    iniHeading        "\[.*\]"
syn match    iniVariableDef    "\(.*\)="
syn region   iniString         start=+"+ skip=+\\"+ end=+"+ contains=iniVariableSub
syn match    iniVariableSub    "%[^%]*%"
syn match    iniComment        ";.*$"


hi def link iniComment     Comment
hi def link iniHeading     Special         
hi def link iniVariableDef Identifier
hi def link iniString      String
hi def link iniVariableSub Identifier
