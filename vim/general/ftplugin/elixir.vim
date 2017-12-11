" Elixir-specific plugin file

"-- Begin common header --------------------------------------------------------
if exists("b:did_custom_ftplugin") | finish | endif
let b:did_custom_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------

nnoremap <Leader>x :w<CR>:!elixir %<CR>
nnoremap <Leader>r :w<CR>:!mix run %<CR>
nnoremap <Leader>e 1GO#!/usr/bin/env elixir<ESC>j"%pF.DA do<ESC>0~Idefmodule <ESC>O<ESC>Go<CR>end<ESC>k

"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
