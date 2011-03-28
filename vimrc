set nocompatible

syntax on

" This needs to be before the colorscheme line so TrailingWhitespace isn't
" clobbered
:autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
:au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match TrailingWhitespace /\s\+$/
:au BufWinEnter * match TrailingWhitespace /\s\+$/

if filereadable($HOME."/.vim/colors/dim.vim")
    colorscheme dim
else
    colorscheme pablo
endif

set autoindent showmatch
set noincsearch nobackup nocindent nohlsearch visualbell
set indentexpr=""
set formatoptions=""
set scrolloff=3
set tabstop=4 shiftwidth=4 expandtab shiftround
set tabpagemax=666

let b:did_ftplugin = 1
filetype indent off

" =i : add #include guards to .h file
" map =i mi1GO1G"%pgUU:s/[^a-zA-Z0-9_]/_/gIINCLUDE_"iyyI#ifndef J0"ipI#define Go"ipI#endif // `i

" =c : check perl syntax
" =x : run perl script
map =c :%w !perl -c
map =x :%w !perl

" =n : set news mode
map =n :set ro:set ic:set syntax=mail

map =d "=strftime("%d/%m/%Y")<CR>pI// Steve Thirlwall, <ESC>o//<ESC>78A=<ESC>kO//<ESC>78A=<ESC>

map =l o<ESC>0a#<ESC>79A=<ESC>

map =s /\s\+$<CR>

map =tt :set syntax=tt2<CR>

map! √ *

map =d 0I -- Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>  <ESC>:r !date +'\%a, \%-d \%b \%Y \%X \%z'<CR>kJ

if filereadable($HOME."/.dotfiles/vimrc.local")
    source ~/.dotfiles/vimrc.local
endif
