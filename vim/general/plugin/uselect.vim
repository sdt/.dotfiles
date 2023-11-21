" Vim plugin to exec fv/gv/lv from within vim itself
" Last Change: 16 Oct 2012
" Maintainer: Stephen Thirlwall <sdt@dr.com>

"-----------------------------------------------------------------------------
" Standard preamble
if exists("g:loaded_uselect")
    finish
endif
let g:loaded_uselect = 1

let s:save_cpo = &cpo
set cpo&vim

"-----------------------------------------------------------------------------
" Configuration variables
"
" g:uselect_bin - path to uselect binary (default "uselect")
"
if !exists("g:uselect_bin")
    let g:uselect_bin = "uselect"
endif

"-----------------------------------------------------------------------------
" :FV <pattern>
"
" Loads file selector for files with filename matching pattern.
" Search starts from current directory.

command -nargs=1 FV call s:doFV('<args>')

"-----------------------------------------------------------------------------
" :FC
"
" Calls FV with the word under the cursor.

command -nargs=0 FC call s:doFV(expand('<cword>'))  " maybe want <cfile> ?

function! s:doFV(pattern)
    let cmd='ag -l | fgrep -- ' . shellescape(a:pattern) . ' | sort | ' . g:uselect_bin . ' -s ' . shellescape('fv ' . a:pattern)
    call s:LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" :GV <pattern>
"
" Loads file selector for files containing pattern.

command -nargs=1 GV call s:doGV('<args>')

"-----------------------------------------------------------------------------
" :GC
"
" Calls GV with the word under the cursor.

command -nargs=0 GC call s:doGV(expand('<cword>'))

function! s:doGV(pattern)
    let cmd='ag --heading --break -- ' . shellescape(a:pattern) . " | " . g:uselect_bin . " -i -m '^\\d+[:-]' -s " . shellescape('gv ' . a:pattern)
    call s:LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" :LV <pattern>
"
" Like fv, but searches globally using locate.

command -nargs=1 LV call s:doLV('<args>')

"-----------------------------------------------------------------------------
" :LC
"
" Calls LV with the word under the cursor.

command -nargs=0 LC call s:doLV(expand('<cword>'))  " maybe want <cfile> ?

function! s:doLV(pattern)
    let cmd='locate -- ' . shellescape(a:pattern) . " | perl -nlE 'say if -f' | " . g:uselect_bin . ' -s ' . shellescape('lv ' . a:pattern)
    call s:LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" s:LoadFilesFromCommand(command)
"   command: shell command which returns a list of filenames, one per line
"
" Executes command, and opens each file in a new buffer. Files already opened
" are not re-opened.
"
function! s:LoadFilesFromCommand(command)
    let files=system(a:command . ' 2>/dev/null')
    let filelist=split(files, '\n')
    for filename in filelist
        execute ':e ' . filename
    endfor
    " HACK: The command-line history is broken after executing uselect - the
    " up/down arrow keys don't work. This seems to fix it.
	" EDIT: Turns out system() is not intended for interactive commands.
	" Given uselect takes pains to force interactive mode, even when its stdin
	" has been redirected, this might be an exception.
    execute ':!'
endfunction

"-----------------------------------------------------------------------------
" Standard postamble

let &cpo = s:save_cpo
