" Go-specific plugin file

"-- Begin common header --------------------------------------------------------
if exists("b:did_custom_ftplugin") | finish | endif
let b:did_custom_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------

set noexpandtab
set ts=4 sw=0

nnoremap <Leader>c :! go build %<cr>
nnoremap <Leader>f :% !gofmt -s<cr>
nnoremap <Leader>x :! go run %<cr>

"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
