" Perl-specific overrides

"-- Begin common header --------------------------------------------------------
if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo-=C
"-- End common header ----------------------------------------------------------

" The <buffer> in the macros below makes the macros local to the buffer in
" which they were defined, which is want we want if we have different filetypes
" in different buffers in the same session.
" http://learnvimscriptthehardway.stevelosh.com/chapters/11.html

" =pm Edit perl module under cursor
" http://blogs.perl.org/users/davewood/2012/06/open-module-under-cursor-in-vim.html
command! -nargs=1 PMSource :e `perldoc -lm <args>`
setlocal isfname+=:
nnoremap <buffer> <leader>pm :PMSource <cfile><cr>

" =c check syntax (requires Vi::QuickFix module)
nnoremap <buffer> <Leader>c :! perl -MVi::QuickFix=.vimerrors.err -c %<CR><CR>:cg<CR>:cl<CR>

" =x execute
nnoremap <buffer> <Leader>x :%w !perl<CR>

" =pod Create initial pod for .pm
nnoremap <Leader>pod Go<CR>__END__<CR><CR>=head1 NAME<CR><CR><ESC>1G0wyt;Gpo<CR>=cut<ESC>

" =dd : insert Data::Dumper line
nnoremap <Leader>dd ouse Data::Dumper::Concise; print STDERR Dumper(

" =dp : insert Data::Printer line
nnoremap <Leader>dp ouse Data::Printer; p<SPACE>

"-- Begin common footer --------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
"-- End common footer ----------------------------------------------------------
