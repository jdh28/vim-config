g/^?/d
g/^retrieving revision /d
g/^U /d
g/^RCS file: /d
g/^Merging differences between/s/.*between \(.*\) and \(.*\) into \(.*\)/\3: \1 -> \2/
g/^cvs server: /s/.*scheduling \(.*\) for removal/\1: delete/
g/^cvs update:/s/^cvs update/error/
g/^C /s/^C \(.*\)/\1: conflict/

if version < 600
  syntax clear
endif

syn match mergelogConflict  /^.*conflict$/
syn match mergelogConflict  /^error:/
syn match mergelogNoise1    /^.*[[:digit:]\.]\+ -> [[:digit:]\.]\+$/
syn match mergelogNoise2    /^.*delete$/

hi def link mergelogConflict Error
hi def link mergelogError    Error
hi def link mergelogNoise1   Comment
hi def link mergelogNoise2   Comment

let b:current_syntax = "cvsmergelog"
