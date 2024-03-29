if exists("b:current_syntax")
  finish
endif

syn clear

syn match ccollabComment		"#.*$"
syn match ccollabIgnoreFile		"^.*\.csproj\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.vcproj\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.vcxproj\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.vcxproj\.filters\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.sln\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.resx\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.Designer\.cs\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.frx\(   \)\@="
syn match ccollabIgnoreFile		"^.*\.vbp\(   \)\@="
syn match ccollabIgnoreFile		"^.*\\\.entries\(   \)\@="
syn match ccollabIgnoreFile		"^.*\\\.parent\(   \)\@="
syn match ccollabIgnoreFile		"^.*\\\packages\.config\(   \)\@="
syn match ccollabIgnoreFile		"^.*\\\GlobalSuppressions\.cs\(   \)\@="

hi link ccollabComment		Comment
hi link ccollabIgnoreFile	Error

let b:current_syntax = "ccollab"
