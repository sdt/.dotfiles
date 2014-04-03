set nocompatible
let mapleader="="

" Prepend our runtime paths so we override the defaults
set runtimepath=
set runtimepath+=~/.dotfiles/vim/general
set runtimepath+=~/.dotfiles/vim/bufexplorer
set runtimepath+=~/.dotfiles/vim/vim-perl
set runtimepath+=~/.dotfiles/vim/solarized
set runtimepath+=~/.dotfiles/vim/vim-scala
set runtimepath+=~/.dotfiles/vim/after
set runtimepath+=$VIMRUNTIME

" Force template toolkit filetypes
augroup template_toolkit
	autocmd!
	autocmd BufNewFile,BufRead *.tt2 setf tt2html
	autocmd BufNewFile,BufRead *.tt  setf tt2html
augroup END

filetype plugin on
runtime macros/matchit.vim
syntax on

" Turn off the annoying continual highlight of matching parens
let loaded_matchparen=1

" Highlight trailing whitespace - http://vim.wikia.com/wiki/VimTip396
" Make sure this is done before the colorscheme loads
augroup trailing_whitespace
	autocmd!
	autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
	autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match TrailingWhitespace /\s\+$/
	autocmd BufWinEnter * match TrailingWhitespace /\s\+$/
augroup END

" Auto-detect solarized from the SOLARIZED env var
if $SOLARIZED == ''
    colorscheme dim
else
    colorscheme sdt_solarized
endif

" BufExplorer settings
let g:bufExplorerShowRelativePath=1

" uselect settings
let g:uselect_bin = "~/.dotfiles/uselect/uselect"

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
set modelines=5

" I added these years ago to avoid some unwanted new indenting behaviour
" These make the ftplugin-based stuff not work (like matchit)
" let b:did_ftplugin = 1
" filetype indent off

" =i : add #include guards to .h file
" nnoremap <Leader>i mi1GO<CR><ESC>1G"%pgUU:s/[^a-zA-Z0-9_]/_/g<CR>IINCLUDE_<ESC>"iyyI#ifndef <ESC>J0"ipI#define <ESC>Go<ESC>"ip<ESC>I#endif // <ESC>`i

" =c : check syntax
" =x : run script
augroup eXex_and_Check_macros
	autocmd!

    autocmd FileType html       set ts=2 sw=2
    autocmd FileType javascript set ts=4 sw=4
augroup END

" =d : insert date line into debian changelog
nnoremap <Leader>d "=strftime("%d/%m/%Y")<CR>pI// Steve Thirlwall, <ESC>o//<ESC>78A=<ESC>kO//<ESC>78A=<ESC>

" =s : search for trailing whitespace
nnoremap <Leader>s /\s\+$<CR>
" =S : delete all trailing whitespace
nnoremap <Leader>S :%s/\s\+$//<CR>

" =tt : switch to tt2 syntax
nnoremap <Leader>tt :set syntax=tt2<CR>

" =dc : insert date line into debian changelog
nnoremap <Leader>dc 0I -- Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>  <ESC>:r !date +'\%a, \%-d \%b \%Y \%X \%z'<CR>kJ

" =- last buffer
nnoremap <Leader>- :n#<CR>

" == open bufexplorer menu
nnoremap <Leader>= :BufExplorer<CR>

" =2 pairing mode
nnoremap <Leader>2 :set invcursorline invcursorcolumn invnumber<CR>

" =t8 8-space tabs
nnoremap <Leader>t8 :set ts=8 sw=8 noet<CR>

" =md Make directory of current file
nnoremap <Leader>md :!mkdir -p $( dirname % )<CR>

" =<tab> Toggle visible whitespace
nnoremap <Leader><tab> :set list!<CR>

" =pp Toggle :set paste
nnoremap <Leader>pp :set paste!<CR>

" =fv fv word under cursor
nnoremap <Leader>fv :FC<CR>

" =gv gv word under cursor
nnoremap <Leader>gv :GC<CR>

" =lv lv word under cursor
nnoremap <Leader>lv :LC<CR>

if filereadable($HOME."/.dotfiles/local/vimrc")
    source ~/.dotfiles/local/vimrc
endif

if filereadable("./.vimrc.local")
    sandbox source ./.vimrc.local
endif
