syn region cppPreProcImport start="^\s*#\s*import\>" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup
syn region cppPreProcUsing start="^\s*#\s*using\>" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup
hi link cppPreProcImport Macro
hi link cppPreProcUsing Macro

syn keyword	cRepeat        each in
syn keyword cppStructure   ref value sealed property get set override event delegate abstract
syn keyword cppStatement   gcnew
syn keyword cppAccess      internal
syn keyword cppStructure   interface
syn keyword cppType        uint literal
