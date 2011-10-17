" Vim plugin to list buffers alphabetically
" Last Change: 17 Oct 2011
" Maintainer: Stephen Thirlwall <sdt@dr.com>

"-----------------------------------------------------------------------------
" Standard preamble

if exists("g:loaded_buflist") | finish | endif
let g:loaded_buflist = 1
let s:save_cpo = &cpo
set cpo&vim

"-----------------------------------------------------------------------------

function! ListBuffers()
    let bufList = s:GetBufferList()
    call sort(bufList, 's:BufCompare')
    for bufInfo in bufList
        echo printf('%3d', bufInfo['bufId']) . ' ' . bufInfo['bufName']
    endfor
endfunction

function! s:GetBufferList()
    let bufCount = bufnr("$")
    let bufId = 1
    let bufList = []
    while bufId <= bufCount
        if (bufexists(bufId) && buflisted(bufId))
            let bufInfo = { 'bufId':bufId, 'bufName':bufname(bufId) }
            call add(bufList, bufInfo)
        endif
        let bufId += 1
    endwhile
    return bufList
endfunction

function! s:BufCompare(lhs, rhs)
    let lhsName = a:lhs['bufName']
    let rhsName = a:rhs['bufName']
    return lhsName < rhsName ? -1 : lhsName > rhsName ? +1 : 0
endfunction

"-----------------------------------------------------------------------------
" Standard postamble

let &cpo = s:save_cpo
