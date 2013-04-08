runtime! syntax/html.vim

syn keyword xjmlTagName contained doc folder idx addfile include merge
syn cluster htmlTagNameCluster add=xjmlTagName


if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

HtmlHiLink xjmlTagName          Statement
hi         xjmlTagName          guibg=#e0e0e0 guifg=Brown gui=bold

delcommand HtmlHiLink
let b:current_syntax = "xjml"
