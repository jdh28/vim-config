" vim600: set foldmethod=marker:
" $Id: cvscommand.vim,v 1.2 2002/10/08 10:00:59 jdh28 Exp $
"
" Vim plugin to assist in working with CVS-controlled files.
"
" Last Change:   $Date: 2002/10/08 10:00:59 $
" Maintainer:    Bob Hiestand <bob@hiestandfamily.org>
" License:       This file is placed in the public domain.
"
" Section: Documentation {{{1
"
" Provides functions to invoke various CVS commands on the current file.
" The output of the commands is captured in a new scratch window.  For
" convenience, if the functions are invoked on a CVS output window, the
" original file is used for the cvs operation instead after the window is
" split.  This is primarily useful when running CVSCommit and you need to see
" the changes made, so that CVSDiff is usable and shows up in another window.
"
" These functions are exported into the global environment, meaning they are
" directly accessed without prepending '<PLUG>'.  This is because the author
" directly accesses several of them without using the mappings in order to
" pass parameters.
"
" Several of these act immediately, such as
"
" CVSAdd        Performs "cvs add" on the current file.
"
" CVSAnnotate   Performs "cvs annotate" on the current file.  If not given an
"               argument, uses the most recent version of the file on the current
"               branch.  Otherwise, the argument is used as a revision number.
"
" CVSCommit     This is a two-stage command.  The first step opens a buffer to
"               accept a log message.  When that buffer is written, it is
"               automatically closed and the file is committed using the
"               information from that log message.  If the file should not be
"               committed, just destroy the log message buffer without writing
"               it.
"
" CVSDiff       With no arguments, this performs "cvs diff" on the current
"               file.  With one argument, "cvs diff" is performed on the
"               current file against the specified revision.  With two
"               arguments, cvs diff is performed between the specified
"               revisions of the current file.  This command uses the
"               'CVSCommandDiffOpt' variable to specify diff options.  If that
"               variable does not exist, then 'wbBc' is assumed.  If you wish
"               to have no options, then set it to the empty string.
"
" CVSEdit       Performs "cvs edit" on the current file.
"
" CVSLog        Performs "cvs log" on the current file.
"
" CVSReview     Retrieves a particular version of the current file.  If no
"               argument is given, the most recent version of the file on
"               the current branch is retrieved.  The specified revision is
"               retrieved into a new buffer.
"
" CVSStatus     Performs "cvs status" on the current file.
"
" CVSUnedit     Performs "cvs unedit" on the current file.
"
" CVSUpdate     Performs "cvs update" on the current file.
"
" CVSVimDiff    With no arguments, this prompts the user for a revision and
"               then uses vimdiff to display the differences between the current
"               file and the specified revision.  If no revision is specified,
"               the most recent version of the file on the current branch is used.
"               With one argument, that argument is used as the revision as
"               above.  With two arguments, the differences between the two
"               revisions is displayed using vimdiff.
"
"               With either zero or one argument, the original buffer is used
"               to perform the vimdiff.  When the other buffer is closed, the
"               original buffer will be returned to normal mode.
"
" By default, a mapping is defined for each command.  User-provided mappings
" can be used instead by mapping to <Plug>CommandName, for instance:
"
" nnoremap ,ca <Plug>CVSAdd
"
" The default mappings are as follow:
"
"   <Leader>ca CVSAdd
"   <Leader>cn CVSAnnotate
"   <Leader>cc CVSCommit
"   <Leader>cd CVSDiff
"   <Leader>ce CVSEdit
"   <Leader>cl CVSLog
"   <Leader>cr CVSReview
"   <Leader>cs CVSStatus
"   <Leader>ct CVSUnedit
"   <Leader>cu CVSUpdate
"   <Leader>cv CVSVimDiff
"
" Options:
"
" Several variables are checked by the script to determine behavior as follow:
"
" CVSCommandDeleteOnHide
"   This variable, if set to a non-zero value, causes the temporary CVS result
"   buffers to automatically delete themselves when hidden.
"
" CVSCommandDiffOpt
"   This variable, if set, determines the options passed to the diff command
"   of CVS.  If not set, it defaults to 'wbBc'.
"
" CVSCommandNameMarker
"   This variable, if set, configures the special attention-getting characters
"   that appear on either side of the cvs buffer type in the buffer name.  If
"   not set, it defaults to '_'.
"
" CVSCommandSplit
"   This variable controls the orientation of the buffer split when executing
"   the CVSVimDiff command.  If set to 'horizontal', the resulting buffers
"   will be on top of one another.

" Section: Plugin header {{{1

if exists("loaded_cvscommand")
   finish
endif
let loaded_cvscommand = 1

" Section: Utility functions {{{1

" Function: s:CVSResolveLink() {{{2
" Fully resolve the given file name to remove shortcuts or symbolic links.

function! s:CVSResolveLink(fileName)
  let resolved = resolve(a:fileName)
  if resolved != a:fileName
    let resolved = s:CVSResolveLink(resolved)
  endif
  return resolved
endfunction

" Function: s:CVSChangeToCurrentFileDir() {{{2
" Go to the directory in which the current CVS-controlled file is located.
" If this is a CVS command buffer, first switch to the original file.

function! s:CVSChangeToCurrentFileDir()
  let oldCwd=getcwd()
  let fileName=s:CVSResolveLink(@%)
  let newCwd=fnamemodify(fileName, ':h')
  if strlen(newCwd) > 0
    execute 'cd' escape(newCwd, ' ')
  endif
  return oldCwd
endfunction

" Function: s:CVSCreateCommandBuffer(cmd, cmdname, filename) {{{2
" Creates a new scratch buffer and captures the output from execution of the
" given command.  The name of the scratch buffer is returned.

function! s:CVSCreateCommandBuffer(cmd, cmdname, filename)
  let nameMarker = s:CVSGetOption("CVSCommandNameMarker", '_')
  let origBuffNR=bufnr("%")
  let bufName=a:filename . ' ' . nameMarker . a:cmdname . nameMarker
  let counter=0
  let currentBufName = bufName
  while buflisted(currentBufName)
    let counter=counter + 1
    let currentBufName=bufName . ' (' . counter . ')'
  endwhile
  let currentBufName = escape(currentBufName, ' *\')

  if s:CVSEditFile(currentBufName) == -1
    return ""
  endif

  set buftype=nofile
  set noswapfile
  set filetype=
  if s:CVSGetOption("CVSCommandDeleteOnHide", 0)
    set bufhidden=delete
  endif
  let b:cvsOrigBuffNR=origBuffNR
  silent execute a:cmd
  $d
  1
  return currentBufName
endfunction

" Function: s:CVSBufferCheck() {{{2
" Attempts to locate the original file to which CVS operations were applied.

function! s:CVSBufferCheck()
  if exists("b:cvsOrigBuffNR")
    if bufexists(b:cvsOrigBuffNR)
      execute "sbuffer" . b:cvsOrigBuffNR
      return 1
    else
      " Original buffer no longer exists.
      return -1 
    endif
  else
    " No original buffer
    return 0
  endif
endfunction

" Function: s:CVSToggleDeleteOnHide() {{{2
" Toggles on and off the delete-on-hide behavior of CVS buffers

function! s:CVSToggleDeleteOnHide()
  if exists("g:CVSCommandDeleteOnHide")
    unlet g:CVSCommandDeleteOnHide
  else
    let g:CVSCommandDeleteOnHide=1
  endif
endfunction

" Function: s:CVSGetOption(name, default) {{{2
" Grab a user-specified option to override the default provided.  Options are
" searched in the window, buffer, then global spaces.

function! s:CVSGetOption(name, default)
  if exists("w:" . a:name)
    execute "return w:".a:name
  elseif exists("b:" . a:name)
    execute "return b:".a:name
  elseif exists("g:" . a:name)
    execute "return g:".a:name
  else
    return a:default
  endif
endfunction

" Function: s:CVSEditFile(name) {{{2
" Wrapper around the 'edit' command to provide some helpful error text if the
" current buffer can't be abandoned.
" Returns: 0 if successful, -1 if an error occurs.

function! s:CVSEditFile(name)
  let v:errmsg = ""
  execute 'edit' a:name
  if v:errmsg != ""
    if &modified && !&hidden
      echoerr "Unable to open command buffer because 'nohidden' is set and the current buffer is modified (see :help 'hidden')."
    else
      echoerr "Unable to open command buffer" v:errmsg
    endif
    return -1
  endif
endfunction

" Function: s:CVSDoCommand(cvscmd, cmdName) {{{2
" General skeleton for CVS function execution.
" Returns: name of the new command buffer containing the command results

function! s:CVSDoCommand(cmd, cmdName)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let fileName=@%
  let realFileName = fnamemodify(s:CVSResolveLink(fileName), ':t')
  let oldCwd=s:CVSChangeToCurrentFileDir()
  let fullCmd = '0r!' . a:cmd . ' "' . realFileName . '"'
  let resultBufferName=s:CVSCreateCommandBuffer(fullCmd, a:cmdName, fileName)
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

" Section: CVS functions {{{1

" Function: s:CVSAdd() {{{2
function! s:CVSAdd()
  return s:CVSDoCommand('cvs add', 'cvsadd')
endfunction

" Function: s:CVSAnnotate(...) {{{2
function! s:CVSAnnotate(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let currentLine=line(".")
  let oldCwd=s:CVSChangeToCurrentFileDir()

  if a:0 == 0
    let revision=system("cvs status " . escape(s:CVSResolveLink(@%), " *?\\"))
    if(v:shell_error)
      echo "Unable to obtain status for " . expand("%")
      return
    endif
    let revision=substitute(revision, '^\_.*Working revision:\s*\(\d\+\%(\.\d\+\)\+\)\_.*$', '\1', "")
  else
    let revision=a:1
  endif

  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs -q annotate -r ' . revision . ' "' . s:CVSResolveLink(@%) . '"', 'cvsannotate', expand("%"))
  if resultBufferName != "" 
    exec currentLine
    set filetype=CVSAnnotate
  endif

  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

" Function: s:CVSCommit() {{{2
function! s:CVSCommit()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck ==  -1
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let originalBuffer=bufnr("%")
  let nameMarker = s:CVSGetOption("CVSCommandNameMarker", '_')
  let messageFileName = escape(tempname().nameMarker.'logmessage'.nameMarker, ' ?*\')

  let fileName=@%
  let realFilePath=s:CVSResolveLink(fileName)
  let newCwd=fnamemodify(realFilePath, ':h')
  let realFileName=fnamemodify(realFilePath, ':t')

  execute 'au BufWritePost *' . nameMarker . 'logmessage' . nameMarker . '* call s:CVSFinishCommit("' . messageFileName . '", "' . newCwd . '", "' . realFileName . '", "' . fileName . '") | au! * ' messageFileName
  execute 'au BufDelete' messageFileName 'au! * ' messageFileName

  if s:CVSEditFile(messageFileName) == -1
    execute 'au! *' messageFileName
  else
    let b:cvsOrigBuffNR=originalBuffer
  endif
endfunction

" Function: s:CVSDiff(...) {{{2
function! s:CVSDiff(...)
  if a:0 == 1
    let revOptions = '-r' . a:1
    let caption = 'cvsdiff ' . a:1 . ' -> current'
  elseif a:0 == 2
    let revOptions = '-r' . a:1 . ' -r' . a:2
    let caption = 'cvsdiff ' . a:1 . ' -> ' . a:2
  else
    let revOptions = ''
    let caption = 'cvsdiff'
  endif

  let cvsdiffopt=s:CVSGetOption('CVSCommandDiffOpt', 'wbBc')

  if cvsdiffopt == ""
    let diffoptionstring=""
  else
    let diffoptionstring=" -" . cvsdiffopt . " "
  endif

  let resultBufferName = s:CVSDoCommand('cvs diff ' . diffoptionstring . revOptions , caption)
  if resultBufferName != ""
    set filetype=diff
  endif
  return resultBufferName
endfunction

" Function: s:CVSEdit() {{{2
function! s:CVSEdit()
  return s:CVSDoCommand('cvs edit', 'cvsedit')
endfunction

" Function: s:CVSFinishCommit(messageFile, targetDir, targetFile) {{{2
function! s:CVSFinishCommit(messageFile, targetDir, targetFile, fileName)
  if filereadable(a:messageFile)
    let oldCwd=getcwd()
    if strlen(a:targetDir) > 0
      execute 'cd' escape(a:targetDir, ' ')
    endif
    let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs commit -F "' . a:messageFile . '" "'. a:targetFile . '"', 'cvscommit', a:fileName)
    execute 'cd' escape(oldCwd, ' ')
    execute 'bw' escape(a:messageFile, ' *?\')
    silent execute '!rm' a:messageFile
    return resultBufferName
  else
    echo "Can't read message file; no commit is possible."
    return ""
  endif
endfunction

" Function: s:CVSLog() {{{2
function! s:CVSLog()
  let resultBufferName=s:CVSDoCommand('cvs log', 'cvslog')
  if resultBufferName != ""
    set filetype=rcslog
  endif
  return resultBufferName
endfunction

" Function: s:CVSRevert() {{{2
function! s:CVSRevert()
  return s:CVSDoCommand('cvs update -C', 'cvsrevert')
endfunction

" Function: s:CVSReview(...) {{{2
function! s:CVSReview(...)
  if a:0 == 0
    let versiontag="current"
    let versionOption=""
  else
    let versiontag=a:1
    let versionOption=" -r " . versiontag . " "
  endif

  let origFileType=&filetype

  let resultBufferName = s:CVSDoCommand('cvs -q update -p' . versionOption, 'cvsstatus -- ' .versiontag)

  let &filetype=origFileType
  return resultBufferName
endfunction

" Function: s:CVSStatus() {{{2
function! s:CVSStatus()
  return s:CVSDoCommand('cvs status', 'cvsstatus')
endfunction

" Function: s:CVSUnedit() {{{2
function! s:CVSUnedit()
  return s:CVSDoCommand('cvs unedit', 'cvsunedit')
endfunction

" Function: s:CVSUpdate() {{{2
function! s:CVSUpdate()
  return s:CVSDoCommand('cvs update', 'update')
endfunction

" Function: s:CVSVimDiff(...) {{{2
function! s:CVSVimDiff(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  " Establish split before leaving original buffer
  let splitModifier="vertical"
  if s:CVSGetOption('CVSCommandSplit', 'vertical') == 'horizontal'
    let splitModifier = ''
  endif

  let originalBuffer=bufnr("%")

  let isUsingSource=1

  if(a:0 == 0)
    let resultBufferName=s:CVSReview()
  elseif(a:0 == 1)
    let resultBufferName=s:CVSReview(a:1)
  else
    let isUsingSource=0
    let resultBufferName=s:CVSReview(a:1)
    set buftype=
    w!
    execute "au BufDelete" resultBufferName "call delete(\"".resultBufferName ."\") | au! BufDelete" resultBufferName
    execute "buffer" originalBuffer
    let originalBuffer=bufnr(resultBufferName)
    let resultBufferName=s:CVSReview(a:2)
  endif

  if isUsingSource
    " Provide for restoring state of original buffer
    execute "au BufDelete" resultBufferName "call setbufvar(" b:cvsOrigBuffNR ", \"&diff\", 0)"
    execute "au BufDelete" resultBufferName "call setbufvar(" b:cvsOrigBuffNR ", \"&foldcolumn\", 0)"
    execute "au BufDelete" resultBufferName "au! BufDelete " escape(resultBufferName, ' *?\')
  endif

  execute "silent leftabove" splitModifier "diffsplit" escape(bufname(originalBuffer), ' *?\')
  execute bufwinnr(originalBuffer) "wincmd w"
  return resultBufferName
endfunction

" Section: Command definitions {{{1
com! CVSAdd call s:CVSAdd()
com! -nargs=? CVSAnnotate call s:CVSAnnotate(<f-args>)
com! CVSCommit call s:CVSCommit()
com! -nargs=* CVSDiff call s:CVSDiff(<f-args>)
com! CVSEdit call s:CVSEdit()
com! CVSLog call s:CVSLog()
com! -nargs=? CVSRevert call s:CVSRevert(<f-args>)
com! -nargs=? CVSReview call s:CVSReview(<f-args>)
com! CVSStatus call s:CVSStatus()
com! CVSUnedit call s:CVSUnedit()
com! CVSUpdate call s:CVSUpdate()
com! -nargs=* CVSVimDiff call s:CVSVimDiff(<f-args>)

" Section: Plugin command mappings {{{1
nnoremap <unique> <Plug>CVSAdd :CVSAdd<CR>
nnoremap <unique> <Plug>CVSAnnotate :CVSAnnotate<CR>
nnoremap <unique> <Plug>CVSCommit :CVSCommit<CR>
nnoremap <unique> <Plug>CVSDiff :CVSDiff<CR>
nnoremap <unique> <Plug>CVSEdit :CVSEdit<CR>
nnoremap <unique> <Plug>CVSLog :CVSLog<CR>
nnoremap <unique> <Plug>CVSRevert :CVSRevert<CR>
nnoremap <unique> <Plug>CVSReview :CVSReview<CR>
nnoremap <unique> <Plug>CVSStatus :CVSStatus<CR>
nnoremap <unique> <Plug>CVSUnedit :CVSUnedit<CR>
nnoremap <unique> <Plug>CVSUpdate :CVSUpdate<CR>
nnoremap <unique> <Plug>CVSVimDiff :CVSVimDiff<CR>

" Section: Default mappings {{{1
if !hasmapto('<Plug>CVSAdd')
  nmap <unique> <Leader>ca <Plug>CVSAdd
endif
if !hasmapto('<Plug>CVSAnnotate')
  nmap <unique> <Leader>cn <Plug>CVSAnnotate
endif
if !hasmapto('<Plug>CVSCommit')
  nmap <unique> <Leader>cc <Plug>CVSCommit
endif
if !hasmapto('<Plug>CVSDiff')
  nmap <unique> <Leader>cd <Plug>CVSDiff
endif
if !hasmapto('<Plug>CVSEdit')
  nmap <unique> <Leader>ce <Plug>CVSEdit
endif
if !hasmapto('<Plug>CVSLog')
  nmap <unique> <Leader>cl <Plug>CVSLog
endif
if !hasmapto('<Plug>CVSRevert')
  nmap <unique> <Leader>cq <Plug>CVSRevert
endif
if !hasmapto('<Plug>CVSReview')
  nmap <unique> <Leader>cr <Plug>CVSReview
endif
if !hasmapto('<Plug>CVSStatus')
  nmap <unique> <Leader>cs <Plug>CVSStatus
endif
if !hasmapto('<Plug>CVSUnedit')
  nmap <unique> <Leader>ct <Plug>CVSUnedit
endif
if !hasmapto('<Plug>CVSUpdate')
  nmap <unique> <Leader>cu <Plug>CVSUpdate
endif
if !hasmapto('<Plug>CVSVimDiff')
  nmap <unique> <Leader>cv <Plug>CVSVimDiff
endif

" Section: Menu items {{{1
amenu <silent> &Plugin.CVS.&Add      <Plug>CVSAdd
amenu <silent> &Plugin.CVS.A&nnotate <Plug>CVSAnnotate
amenu <silent> &Plugin.CVS.&Commit   <Plug>CVSCommit
amenu <silent> &Plugin.CVS.&Diff     <Plug>CVSDiff
amenu <silent> &Plugin.CVS.&Edit     <Plug>CVSEdit
amenu <silent> &Plugin.CVS.&Log      <Plug>CVSLog
amenu <silent> &Plugin.CVS.Revert    <Plug>CVSRevert
amenu <silent> &Plugin.CVS.&Review   <Plug>CVSReview
amenu <silent> &Plugin.CVS.&Status   <Plug>CVSStatus
amenu <silent> &Plugin.CVS.Unedi&t   <Plug>CVSUnedit
amenu <silent> &Plugin.CVS.&Update   <Plug>CVSUpdate
amenu <silent> &Plugin.CVS.&VimDiff  <Plug>CVSVimDiff
