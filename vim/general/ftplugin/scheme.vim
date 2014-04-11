" Scheme-specific plugin file

"-- Begin common header --------------------------------------------------------
if exists("b:did_custom_ftplugin") | finish | endif
let b:did_custom_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------

nnoremap <buffer> <Leader>c :w !mit-scheme<CR>
nnoremap <buffer> <Leader>x :w !mit-scheme --quiet<CR>
set ts=2 sw=2

"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
