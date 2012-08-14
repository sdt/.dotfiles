set nocompatible
syntax on

set runtimepath+=~/.dotfiles/vim/general
set runtimepath+=~/.dotfiles/vim/bufexplorer
set runtimepath+=~/.dotfiles/vim/solarized
set runtimepath+=~/.dotfiles/vim/vim-perl

au BufNewFile,BufRead *.tt2 setf tt2html
au BufNewFile,BufRead *.tt  setf tt2html

filetype plugin on
runtime macros/matchit.vim

" Turn off the annoying continual highlight of matching parens
let loaded_matchparen=1

" Highlight trailing whitespace - http://vim.wikia.com/wiki/VimTip396
" Make sure this is done before the colorscheme loads
autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
au InsertLeave * match TrailingWhitespace /\s\+$/
au BufWinEnter * match TrailingWhitespace /\s\+$/

" Auto-detect solarized from the SOLARIZED env var
if $SOLARIZED == ''
    colorscheme dim
else
    colorscheme sdt_solarized
endif

set autoindent showmatch
set noincsearch nobackup nocindent nohlsearch visualbell
set indentexpr=""
set formatoptions=""
set scrolloff=3
set tabstop=4 shiftwidth=4 expandtab shiftround smarttab
set tabpagemax=666
set confirm
set errorfile=.vimerrors.err
set backupskip=/tmp/*,/private/tmp/*
set fillchars+=vert:\ ,fold:-
set lcs+=tab:>_

" I added these years ago to avoid some unwanted new indenting behaviour
" These make the ftplugin-based stuff not work (like matchit)
" let b:did_ftplugin = 1
" filetype indent off

let mapleader="="

" http://blogs.perl.org/users/davewood/2012/06/open-module-under-cursor-in-vim.html
au FileType perl command! -nargs=1 PerlModuleSource :e `perldoc -lm <args>`
au FileType perl setlocal isfname+=:
au FileType perl noremap <leader>pm :PerlModuleSource <cfile><cr>

" =i : add #include guards to .h file
" map <Leader>i mi1GO<CR><ESC>1G"%pgUU:s/[^a-zA-Z0-9_]/_/g<CR>IINCLUDE_<ESC>"iyyI#ifndef <ESC>J0"ipI#define <ESC>Go<ESC>"ip<ESC>I#endif // <ESC>`i

" =c : check perl syntax
" =x : run perl script
" map <Leader>c :%w !perl -c<CR>
map <Leader>c :! perl -MVi::QuickFix=.vimerrors.err -c %<CR><CR>:cg<CR>:cl<CR>
map <Leader>x :%w !perl<CR>

" =d : insert date line into debian changelog
map <Leader>d "=strftime("%d/%m/%Y")<CR>pI// Steve Thirlwall, <ESC>o//<ESC>78A=<ESC>kO//<ESC>78A=<ESC>

" =s : search for trailing whitespace
map <Leader>s /\s\+$<CR>
" =S : delete all trailing whitespace
map <Leader>S :%s/\s\+$//<CR>

" =tt : switch to tt2 syntax
map <Leader>tt :set syntax=tt2<CR>

" =dc : insert date line into debian changelog
map <Leader>dc 0I -- Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>  <ESC>:r !date +'\%a, \%-d \%b \%Y \%X \%z'<CR>kJ

" =dd : insert Data::Dumper line
map <Leader>dd Ouse Data::Dumper::Concise;<CR>print STDERR Dumper(

" =pa/A insert perl AUTHOR line
map <Leader>pa 0I=head1 AUTHOR<CR><CR>Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au><CR><ESC>
map <Leader>pA 0I=head1 AUTHOR<CR><CR>Stephen Thirlwall <sdt@dr.com><CR><ESC>

" =v buffer list
map <Leader>v :ls<CR>:b

" =- last buffer
map <Leader>- :n#<CR>

" ==
map <Leader>= :BufExplorer<CR>

" =v buffer list
map <Leader>n :call ListBuffers()<CR>:b

" =2 pairing mode
map <Leader>2 :set invcursorline invcursorcolumn invnumber<CR>

" =t8 8-space tabs
map <Leader>t8 :set ts=8 sw=8 noet<CR>

" =md Make directory of current file
map <Leader>md :!mkdir -p $( dirname % )<CR>

" =<tab> Toggle :set list
map <Leader><tab> :set list!<CR>

" =pp Toggle :set paste
map <Leader>pp :set paste!<CR>

" =pod Create initial pod for .pm
map <Leader>pod Go<CR>__END__<CR><CR>=head1 NAME<CR><CR><ESC>1G0wyt;Gpo<CR>=cut<ESC>

if filereadable($HOME."/.dotfiles/vimrc.local")
    source ~/.dotfiles/vimrc.local
endif

if filereadable("./.vimrc.local")
    sandbox source ./.vimrc.local
endif
