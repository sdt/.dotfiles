set nocompatible
syntax on

au BufNewFile,BufRead *.tt2 setf tt2
au BufNewFile,BufRead *.tt  setf tt2

:filetype plugin on
:runtime macros/matchit.vim

" Turn off the annoying continual highlight of matching parens
let loaded_matchparen=1

" Highlight trailing whitespace - http://vim.wikia.com/wiki/VimTip396
" Make sure this is done before the colorscheme loads
:autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
:au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match TrailingWhitespace /\s\+$/
:au BufWinEnter * match TrailingWhitespace /\s\+$/

" Use the dim colorscheme if we have it
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

" I added these years ago to avoid some unwanted new indenting behaviour
" These make the ftplugin-based stuff not work (like matchit)
" let b:did_ftplugin = 1
" filetype indent off

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

map =tt :set syntax=tt2html<CR>

map! √ *

map =d 0I -- Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>  <ESC>:r !date +'\%a, \%-d \%b \%Y \%X \%z'<CR>kJ

map =pa 0I=head1 AUTHOR<CR><CR>Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au><CR><ESC>
map =pA 0I=head1 AUTHOR<CR><CR>Stephen Thirlwall <sdt@dr.com><CR><ESC>

if filereadable($HOME."/.dotfiles/vimrc.local")
    source ~/.dotfiles/vimrc.local
endif
