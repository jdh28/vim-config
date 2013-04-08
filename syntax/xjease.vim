" Vim syntax file
" Language:     XJEase
" Maintainer:   John Hall <john.hall@xjtag.com>

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  " finish
endif

syn keyword xjeasePreamble   AUTHOR BOARD BYPASS CHAIN CIRCUIT COMPAT_VERSION CONNECT CONNECTOR CONSTANT DESCRIPTION DEVICE FILENAME FILES FREQUENCY GROUND HIGH IN INPUT INTERNAL_PULLS JTAG LIST MAPPING NAME NETLIST NOWARN PACKAGE PINMAP PINS POWER RTCK TCK TDI TDO TMS USE TEST_RESET OVERRIDE_TMS SEQUENCES SEQUENCE TMS_RESET

syn keyword xjeaseStatement  ALERT CALL CASE CHECKCHAIN DECLARE DEFAULT DO ELSE ELSIF END EXIT FOR IF RETURN RUNSTAPL RUNSVF SWITCH THEN TO SET UNTIL WHILE HOLDOFF
syn keyword xjeaseConstant   BIDIR FALSE GND HI LO LOW OFF ON OPEN READ TRUE WRITE Z
syn keyword xjeaseBuiltinVar BOARD_NAME CIRCUIT_NAME DEVICE_REF NOW
syn keyword xjeaseBuiltin    FCLOSE FEOF FERROR FLOCK FLUSH FOPEN FORMAT FSEEK FTELL FUNLOCK FWRITE
syn keyword xjeaseBuiltin    ASC BIN CHAR CONNTEST FGETI FGETS GETKEY HEX LOG PINNUM PRINT PRINT_FORMAT RANDOM READABLE RUNSVF SAFE SEED SLEEP SYSTEM WAITKEY WIDTHOF WRITEABLE
syn keyword xjeaseRawJtag    IR DR IRSCAN DRSCAN INJTAGSTATE JTAGSTATE
syn keyword xjeaseParser     BSDL EDIF PADSPCB PROTEL RINF
syn keyword xjeasePinMap     BYTEBLASTER MULTIICE XILINX XJTAG
syn keyword xjeaseType       CONST FILE INT STRING WIDTH
syn keyword xjeaseConntest   BACKWARDS DIRECTION FORWARDS MAX_NETS NET_TEST WAIT
syn keyword xjeaseDeprecated FREAD

syn keyword xjeaseTodo       contained TODO

syn region  xjeaseComment    start="//" end="$" contains=xjeaseTodo
syn region  xjeaseComment    start="/\*" end="\*/" contains=xjeaseTodo

syn region  xjeaseString     start=+"+  skip=+\\\\\|\\"+  end=+"+
syn match   xjeaseCharConst  /'.'/

syn match   xjeaseIdentifier /\<[_A-Za-z][_A-Za-z0-9]*/
syn match   xjeaseNumConst   /\d\+/

" need special syntax elements for the TEST LIST so we can indent it properly
syn match   xjeaseTLStart    /\<TEST LIST/ contained
syn match   xjeaseTLEnd      /\<END;/ contained
syn match   xjeaseTLSetName  /".\+"/ contained
syn match   xjeaseTLSetEnd   /\<END;/ contained
syn region  xjeaseTLSet      contained matchgroup=xjeaseTLSetName start="\".\+\"" matchgroup=xjeaseTLSetEnd end="END;" contains=xjeaseTLSetName,xjeaseTLSetEnd,xjeaseComment
syn region  xjeaseTestList   matchgroup=xjeaseTLStart start="TEST LIST" matchgroup=xjeaseTLEnd end="END;" contains=xjeaseTLStart,xjeaseTLEnd,xjeaseTLSet,xjeaseComment

syn match xjeasePreambleParts  /\(\<JTAG CHAIN\>\)\|\(\<FUNCTIONAL TEST\>\)\|\(\<DEVICE NAME\>\)\|\(\<DISABLE DEVICE\>\)\|\(\<TEST COVERAGE\>\)\|\(\<\(POWER\|JTAG\|DEVICE\|IGNORE\|CONNECTION\|UNFITTED\) LIST\>\)/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_is_syntax_inits")
  if version < 508
    let did_is_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink xjeasePreamble      Statement
  HiLink xjeasePreambleParts Statement
  HiLink xjeaseStatement     Statement
  HiLink xjeaseBuiltin       Statement
  HiLink xjeaseRawJtag       Statement
  HiLink xjeaseParser        Identifier
  HiLink xjeaseConstant      PreProc
  HiLink xjeaseConntest      PreProc
  HiLink xjeasePinmap        xjeaseConstant
  HiLink xjeaseBuiltinVar    xjeaseConstant
  HiLink xjeaseType          Type
  HiLink xjeaseComment       Comment
  HiLink xjeaseTodo          Todo
  HiLink xjeaseString        String
  HiLink xjeaseCharConst     Constant
  HiLink xjeaseNumConst      Constant
  HiLink xjeaseIdentifier    Normal
  HiLink xjeaseDeprecated    Error
  HiLink xjeaseTestList      Normal
  HiLink xjeaseTLStart       xjeaseStatement
  HiLink xjeaseTLEnd         xjeaseStatement
  HiLink xjeaseTLSetName     xjeaseString
  HiLink xjeaseTLSetEnd      xjeaseStatement

  delcommand HiLink
endif

let b:current_syntax = "xjease"

" vim: ts=8
