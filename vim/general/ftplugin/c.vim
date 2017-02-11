" Language-specific plugin file

"-- Begin common header --------------------------------------------------------
if exists("b:did_custom_ftplugin") | finish | endif
let b:did_custom_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------


" =i : add #include guards to .h file
nnoremap <Leader>i mi1GO<C-R>%<ESC>:s!^.*/!!e<CR>gUU:s/[^A-Z0-9_]/_/g<CR>IINCLUDE_<ESC>0"iyWI#ifndef <ESC>o#define <C-R>i<ESC>Go#endif // <C-R>i<ESC>`i


"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
