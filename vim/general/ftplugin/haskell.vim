" Haskell-specific plugin file

"-- Begin common header --------------------------------------------------------
if exists("b:did_custom_ftplugin") | finish | endif
let b:did_custom_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------

nnoremap <buffer> <Leader>c :!ghc -c %<CR>
nnoremap <buffer> <Leader>x :!runhaskell %<CR>

set ts=2 sw=2

" =pa : create package line from filename
nnoremap <Leader>pa 1GO<ESC>"%P:s/^\(.*\/\)\?src\///<CR>:s/\.hs$//<CR>:s/\//./ge<CR>Imodule <ESC>A where<ESC>

"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
