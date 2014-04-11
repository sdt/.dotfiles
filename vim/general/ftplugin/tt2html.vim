" Vim filetype plugin file
" Language: TT2 (Template toolkit)

" Only do this when not done yet for this buffer
if exists("b:did_custom_ftplugin") | finish | endif

" Just use the HTML plugin for now.
runtime! ftplugin/html.vim
