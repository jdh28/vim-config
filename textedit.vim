set wrap
set linebreak

noremap j gj
noremap k gk
noremap <Down> g<Down>
noremap <Up> g<Up>
noremap 0 g0
noremap $ g$
noremap <Home> g0
noremap <End> g$

noremap gj j
noremap gk k
noremap g<Down> <Down>
noremap g<Up> <Up>
noremap g0 0
noremap g$ $

inoremap <Down> <C-O>g<Down>
inoremap <Up> <C-O>g<Up>
inoremap <Home> <C-O>g0
inoremap <End> <C-O>g$
