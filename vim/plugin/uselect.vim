" Vim plugin to exec fv/gv/lv from within vim itself
" Last Change: 16 Oct 2011
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
" :fv <pattern>
"
" Loads file selector for files with filename matching pattern.
" Search starts from current directory.

command -nargs=1 FV call USelect_FV('<args>')
ca fv FV

function! USelect_FV(pattern)
    let cmd='ack -a -f | fgrep ' . a:pattern . ' | sort | uselect'
    call _USelect_LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" :gv <pattern>
"
" Loads file selector for files containing pattern.

command -nargs=1 GV call USelect_GV('<args>')
ca gv GV

function! USelect_GV(pattern)
    let cmd='ack --heading --break ' . a:pattern
    let cmd.= " | uselect -s '!/^\\d+[:-]/'"
    call _USelect_LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" :lv <pattern>
"
" Like fv, but searches globally using locate.

command -nargs=1 LV call USelect_LV('<args>')
ca lv LV

function! USelect_LV(pattern)
    let cmd='locate ' . a:pattern . " | perl -nlE 'say if -f' | uselect"
    call _USelect_LoadFilesFromCommand(cmd)
endfunction

"-----------------------------------------------------------------------------
" _USelect_LoadFilesFromCommand(command)
"   command: shell command which returns a list of filenames, one per line
"
" Executes command, and opens each file in a new buffer. Files already opened
" are not re-opened.
"
function! _USelect_LoadFilesFromCommand(command)
    let files=system(a:command)
    let filelist=split(files, '\n')
    for filename in filelist
        if ! bufloaded(filename)
            execute ':e ' . filename
        endif
    endfor
    execute ':redraw!'
endfunction

"-----------------------------------------------------------------------------
" Standard postamble

let &cpo = s:save_cpo
