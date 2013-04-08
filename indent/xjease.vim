" Vim indent file

if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

let b:STRUCTURE_START = 'SWITCH,DO,FOR,CASE,DEFAULT'
let b:STRUCTURE_MID = 'ELSE,ELSIF,WHILE,UNTIL'
let b:PREAMBLE_SECTIONS = 'CIRCUIT\ NAME,DEVICE\ NAME,BOARD\ NAME,POWER\ LIST,JTAG\ LIST,DEVICE\ LIST,IGNORE\ LIST,UNFITTED\ LIST,CONNECTION\ LIST,JTAG\ CHAIN,CONNECTOR,MAPPING,SEQUENCES,SEQUENCE,TEST\ LIST,PINS,DISABLE\ DEVICE,TEST\ COVERAGE'

let s:STRUCTURE_START_LIST = '=' . substitute(b:STRUCTURE_START, ',', ',=', 'g')
let b:STRUCTURE_START_RE = substitute(b:STRUCTURE_START, ',', '|', 'g')
let s:STRUCTURE_MID_LIST = '=' . substitute(b:STRUCTURE_MID, ',', ',=', 'g')
let b:STRUCTURE_MID_RE = substitute(b:STRUCTURE_MID, ',', '|', 'g')
let s:PREAMBLE_SECTIONS_LIST = '=' . substitute(b:PREAMBLE_SECTIONS, ',', ',=', 'g')
let b:PREAMBLE_SECTIONS_RE = substitute(b:PREAMBLE_SECTIONS, ',', '|', 'g')

let s:FUNCTION_DEF_RE = '\v^\s*\w+\(.{-}\)\s*\(.{-}\)[^;]*$'

setlocal indentexpr=XJEaseGetIndent(v:lnum)
setlocal indentkeys=!^F,o,O,=END;
exe "setlocal indentkeys+=" . s:STRUCTURE_START_LIST
exe "setlocal indentkeys+=" . s:STRUCTURE_MID_LIST
exe "setlocal indentkeys+=" . s:PREAMBLE_SECTIONS_LIST

" Only define the function once.
if exists("*XJEaseGetIndent")
   finish
endif

fun! XJEaseGetIndent(lnum)
    let b:jh = s:PREAMBLE_SECTIONS_LIST
    let this_line = getline(a:lnum)

    " Find a non-blank, non-comment line above the current line.
    let lnum = a:lnum
    while lnum > 0
        let lnum = prevnonblank(lnum - 1)
        let previous_line = getline(lnum)
        let previous_line = substitute(previous_line, '//.*', '', '')
        let previous_line = substitute(previous_line, '/\*.*\*/', '', 'g')
        if previous_line =~ '\S'
            break
        endif
    endwhile

    " Hit the start of the file, use zero indent.
    if lnum == 0
        return 0
    endif

    let ind = indent(lnum)

	" remove comments from this_line too
	let this_line = substitute(this_line, '//.*', '', '')
	let this_line = substitute(this_line, '/\*.*\*/', '', 'g')

    " Add
    if previous_line =~ '\v^\s*(<IF>.+<THEN>[^;]*$|<(' . b:STRUCTURE_START_RE . '|' . b:STRUCTURE_MID_RE . ')>)'
        let ind = ind + &sw
    elseif previous_line =~ '\v^\s*<(' . b:PREAMBLE_SECTIONS_RE . ')>'
        let ind = ind + &sw
    elseif previous_line =~ s:FUNCTION_DEF_RE
        " function definition
        " it is common to have // ------ comments around function definitions
        " - keep these at same level as the function definition
        if this_line !~ '^//'
            let ind = ind + &sw
        endif
    endif

    " Subtract
    if this_line =~ '\v^\s*<(END;|(' . b:STRUCTURE_MID_RE . ')>)'
        let ind = ind - &sw
    endif

    let b:jh = b:jh . ind
    return ind
endfun
