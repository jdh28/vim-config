syn keyword bsdlKeywords   attribute signal is of generic entity use port string constant end
syn keyword bsdlConstant   PHYSICAL_PIN_MAP COMPONENT_CONFORMANCE PIN_MAP PHYSICAL_PIN_MAP PIN_MAP_STRING
syn keyword bsdlConstant   TAP_SCAN_IN TAP_SCAN_OUT TAP_SCAN_MODE TAP_SCAN_CLOCK TAP_SCAN_RESET
syn keyword bsdlConstant   COMPLIANCE_PATTERNS INSTRUCTION_LENGTH INSTRUCTION_OPCODE INSTRUCTION_CAPTURE INSTRUCTION_PRIVATE IDCODE_REGISTER BOUNDARY_LENGTH

syn keyword bsdlValues     true false BOTH in out linkage bit bit_vector

syn region  bsdlComment    start="--" end="$"
syn region  bsdlString     start=+"+  skip=+\\\\\|\\"+  end=+"+

if !exists("did_is_syntax_inits")
  command -nargs=+ HiLink hi def link <args>

  HiLink bsdlComment       Comment
  HiLink bsdlString        String
  HiLink bsdlKeywords      Statement
  HiLink bsdlConstant      PreProc
  HiLink bsdlValues        Identifier

  delcommand HiLink
endif

let b:current_syntax = "bsdl"

" vim: ts=8
