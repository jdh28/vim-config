" John's .vimrc
" $Revision: 1.35 $

filetype plugin indent on
if &t_Co > 2 || has("gui_running")
	syntax on
endif

set nocompatible		" Use Vim defaults
set bs=indent,eol,start
set ai					" set autoindenting on
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
set noruler
set ts=4
set shiftwidth=4
set nobackup
set writebackup
set hidden
set wildmenu
set wildmode=list:longest
set shiftround
set tags=tags
set clipboard=unnamed
set lazyredraw
set nojoinspaces
set scrolloff=2
set shortmess=flmnxToOI
set hlsearch
set listchars=eol:$,tab:>-
set cpoptions-=a

if has("win32")
	set grepprg=grep\ -nI\ $*\ \\\\|\ sed\ -f\ \"~/vimfiles/grepfilter.sed\"
else
	set grepprg=grep\ -nI\ $*\ \\\\|\ sed\ -f\ \"$HOME/.vim/grepfilter.sed\"
endif

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel'
behave mswin
set selectmode=         " selections in visual mode (overrides behave mswin)
set mousemodel=extend   " right mouse extends selection, left selects

" backspace and cursor keys wrap to previous/next line
set backspace=2
set whichwrap+=<,>,[,]

" extend selection with shift and left mouse button
map <S-LeftMouse>     <RightMouse>
map <S-LeftDrag>      <RightDrag>
map <S-LeftRelease>   <RightRelease>

" right mouse button behaves as middle button (i.e. pastes)
map  <RightMouse>     <MiddleMouse>
imap <RightMouse>     <MiddleMouse>

if has("win32")
	set shellpipe=\|\ tee
endif

let mapleader = ','

" ---------- CVS plugin ----------------------------------------------

let CVSCommandDeleteOnHide = 1
let CVSCommandDiffOpt = ''

" ---------- 2html script --------------------------------------------

let html_use_css = 1
let html_no_display_credit = 0

" ---------- Sessions ------------------------------------------------
" Automatically save session files if Auto_session is set to 1

autocmd VimLeavePre *
  \ if (exists("g:Auto_session") && Auto_session != 0) |
  \     exe "mksession! Session.vimsession" |
  \ endif

set sessionoptions=buffers,curdir,folds,globals,localoptions,options,resize,winpos,winsize

" ---------- Filetypes -----------------------------------------------

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" System include files: always open read-only
augroup sysincludes
au!
au BufReadPost c:/program\ files/visual\ studio/vc98/include/*,c:/winddk/2600.1106/inc/*,c:/program\ files/Platform\ sdk/include/*
		\ set readonly |
		\ set bufhidden=delete |
		\ view
augroup END

" Source the current buffer - used to load Sessions
fun! SourceCurrent()
	let l:session = expand("%")
	bdel
	exe "source " . l:session
endf

" ---------- Mappings ------------------------------------------------

nmap <F2>      /^\(<<<<<<<\\|=======\\|>>>>>>>\)<CR>
imap <F3>      <C-O>:set invlist<CR>
map  <F3>      :set invlist<CR>
imap <F4>      <C-O>:set invhls<CR>
map  <F4>      :set invhls<CR>
imap <F5>      <ESC><F5>
map  <F5>      :new<CR>:only<CR>"*P:set ft=mail<CR>1G
imap <S-F5>    <ESC><S-F5>
map  <S-F5>    :new<CR>:only<CR>"*P:runtime formatmail.vim<CR>
imap <C-F5>    <ESC><C-F5>
map  <C-F5>    1GVG"zd:bd!<CR>:let @*=@z<CR>

map  <F7>      <C-W>}
imap <F7>      <C-O><C-W>}i
map  <S-F7>    :pclose<CR>
imap <S-F7>    <C-O>:pclose<CR>

map  <F8>     :vimgrep \<<cword>\> *<CR>
imap <F8>     <ESC><F8>
map  <S-F8>   :vimgrep <cword> 
imap <S-F8>   <ESC><F8>

map  <F9>     :bufdo :update<CR>:make<CR>
imap  <F9>    <ESC><F9>
map  <F11>    :cn<CR>zv
map  <S-F11>  :cp<CR>zv
map  <F12>    :crewind<CR>

inoremap <C-space> <C-N>

" Alt+] displays tag in preview window
map <M-]> :exe "silent! ptag " . expand("<cword>")<CR>
map <M-[> :exe "silent! pclose"<CR>

" CTRL-Tab is Next window
noremap  <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w

" Y yanks to end of line, rather than the whole line (yy)
map  Y         yg_

" Don't use Ex mode, use Q for formatting
map  Q         gq

" backspace in Visual mode deletes selection
vnoremap <BS> d

" proper Windows <C-Del> command
fu! Windows_C_Del()
	if (strlen(getline(".")) == col("."))
		execute "normal! gJ"
	else
		execute "normal! dw"
	endif
endf

" windows style navigation
imap <C-Del>   <C-O>:call Windows_C_Del()<CR>
imap <C-BS>    <C-W>
map  <C-Left>  b
map  <C-Right> w
imap <C-Left>  <C-O>b
imap <C-Right> <C-O>w

" Smart home key
fun! s:SmartHome()
    if col('.') != match(getline('.'), '\S')+1
        norm ^
    else
        :call cursor(line('.'),2)
        norm h
    endif
endfun

inoremap <silent><home> <C-O>:call <SID>SmartHome()<CR>
nnoremap <silent><home> :call <SID>SmartHome()<CR>
vnoremap <silent><home> :call <SID>SmartHome()<CR>

" ctrl+arrow keys scroll the screen up and down without moving the cursor
nmap <C-Up>   <C-Y>
nmap <C-Down> <C-E>
imap <C-Up>   <C-O><C-Y>
imap <C-Down> <C-O><C-E>

" Insert GUIDS
if has("win32")
imap <silent> <C-G> <C-R>=substitute(system('PrintGuid'), "[\r\n]*$", "", "")<CR>
nmap <C-G> "=substitute(system('PrintGuid'), "[\r\n]*$", "", "")<CR>P
endif


" Commentify
let g:EnhCommentifyUserBindings = 'yes'
let g:EnhCommentifyPretty = 'yes'
let g:EnhCommentifyRespectIndent = 'yes'
let g:EnhCommentifyMultiPartBlocks = 'yes'
vmap <Leader>x <Plug>VisualTraditional
nmap <Leader>x <Plug>Traditional

" Insert copyright
:imap <CS-C> John Hall <john.hall@xjtag.com><CR>Copyright (c) Midas Yellow Ltd. All rights reserved.<CR>

" ---------- Highlighting -------------------------------------------

colors mydarkblue
"set background=

"hi Identifier ctermfg=gray
"hi Comment    ctermfg=cyan
"hi Folded     guibg=#d9e9fb guifg=#404040

hi Folded     guifg=#d9e9fb guibg=black

let g:yacc_uses_cpp=1

" ---------- Status bar stuff ----------------------------------------

fu! Options()
  let opt=""
  " autoindent
  if &ai|   let opt=opt." ai"   |endif
  "  expandtab
  if &et|   let opt=opt." et"   |endif
  "  paste
  if &paste|let opt=opt." paste"|endif
  "  shiftwidth
  let opt=opt." sw=".&shiftwidth
  "  tabstop
  let opt=opt." ts=".&tabstop
  "  textwidth - show always!
  let opt=opt." tw=".&tw
  return opt
endf

set statusline=%1*\ [%n]%*\ %(%M%R%H%)\ %(%<%*%f%)\ %y%=%2*%{Options()}\ \%3*<%l,%v>%*\ 
set laststatus=2

" User1: colour for buffer number
hi User1 cterm=NONE ctermfg=Blue ctermbg=white guifg=SlateBlue guibg=gray80
" User2: colour for modes
hi User2 cterm=NONE ctermfg=DarkGreen ctermbg=white guifg=SeaGreen guibg=gray80
" User3: colour for position
hi User3 cterm=NONE ctermfg=DarkBlue ctermbg=white guifg=SlateBlue guibg=gray80

hi StatusLine cterm=NONE ctermfg=Black ctermbg=white gui=NONE guifg=black guibg=gray80
hi StatusLineNC ctermbg=Gray gui=NONE guibg=gray90
