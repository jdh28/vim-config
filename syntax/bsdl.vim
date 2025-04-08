syn case ignore

syn keyword bsdlKeywords   attribute signal is of generic entity use port string constant end to downto
syn keyword bsdlConstant   PHYSICAL_PIN_MAP COMPONENT_CONFORMANCE PIN_MAP PHYSICAL_PIN_MAP PIN_MAP_STRING PORT_GROUPING
syn keyword bsdlConstant   TAP_SCAN_IN TAP_SCAN_OUT TAP_SCAN_MODE TAP_SCAN_CLOCK TAP_SCAN_RESET
syn keyword bsdlConstant   COMPLIANCE_PATTERNS INSTRUCTION_LENGTH INSTRUCTION_OPCODE INSTRUCTION_CAPTURE INSTRUCTION_PRIVATE IDCODE_REGISTER USERCODE_REGISTER
syn keyword bsdlConstant   REGISTER_ACCESS BOUNDARY_LENGTH BOUNDARY_REGISTER ASSEMBLED_BOUNDARY_LENGTH BOUNDARY_SEGMENT
syn keyword bsdlConstant   RUNBIST_EXECUTION INTEST_EXECUTION SYSCLOCK_REQUIREMENTS REGISTER_MNEMONICS REGISTER_FIELDS REGISTER_ASSEMBLY REGISTER_ASSOCIATION
syn keyword bsdlConstant   BSDL_EXTENSION DESIGN_WARNING
syn keyword bsdlConstant   AIO_COMPONENT_CONFORMANCE AIO_EXTEST_PULSE_EXECUTION AIO_EXTEST_TRAIN_EXECUTION AIO_PIN_BEHAVIOR EXTEST_TOGGLE_CELLS EXTEST_TOGGLE_CELLS

syn keyword bsdlValues     true false BOTH in out inout linkage LINKAGE_INOUT LINKAGE_BUFFER LINKAGE_IN LINKAGE_OUT LINKAGE_MECHANICAL POWER_0 POWER_POS POWER_NEG VREF_IN VREF_OUT bit bit_vector

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
