set nocompatible
let mapleader="="
let perl_include_pod=1

" Prepend our runtime paths so we override the defaults
set runtimepath=
set runtimepath+=~/.dotfiles/vim/bufexplorer
set runtimepath+=~/.dotfiles/vim/dockerfile.vim
set runtimepath+=~/.dotfiles/vim/vim-perl
set runtimepath+=~/.dotfiles/vim/solarized
set runtimepath+=~/.dotfiles/vim/vim-elixir
set runtimepath+=~/.dotfiles/vim/vim-scala
set runtimepath+=~/.dotfiles/vim/vim-clojure-static
set runtimepath+=~/.dotfiles/vim/elm.vim
set runtimepath+=~/.dotfiles/vim/vim-vue-plugin
set runtimepath+=~/.dotfiles/vim/6502 " *.s / *.inc -> 6502
set runtimepath+=~/.dotfiles/vim/general
set runtimepath+=~/.dotfiles/vim/after
set runtimepath+=$VIMRUNTIME

" Force template toolkit filetypes
augroup template_toolkit
	autocmd!
	autocmd BufNewFile,BufRead *.tt2 setf tt2html
	autocmd BufNewFile,BufRead *.tt  setf tt2html
augroup END

" Workaround ubuntu vim issue
" Bug: https://bugs.launchpad.net/ubuntu/+source/vim/+bug/572627
" Fix: http://stackoverflow.com/questions/3383502/pathogen-does-not-load-plugins
filetype off
syntax on
filetype plugin on

runtime macros/matchit.vim

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


" syn bindings
augroup filetype
  autocmd BufNewFile,BufRead *.psgi set filetype=perl
  autocmd BufNewFile,BufRead *.json set syntax=javascript
"TODO: check if we need these - these may replace the ones in general/ftplugin
"  autocmd BufNewFile,BufRead *.tt2 set syntax=tt2html
"  autocmd BufNewFile,BufRead *.tt set syntax=tt2html
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
set nomodeline " for now - see CVE-2019-12735
set modelines=5

" I added these years ago to avoid some unwanted new indenting behaviour
" These make the ftplugin-based stuff not work (like matchit)
" let b:did_ftplugin = 1
" filetype indent off

" Disable control-A incrementing - this goes off by accident sometimes in tmux
nnoremap <c-a> <Nop>
" =s : search for trailing whitespace
nnoremap <Leader>s /\s\+$<CR>
" =S : delete all trailing whitespace
nnoremap <Leader>S :%s/\s\+$//<CR>

" =tt : switch to tt2 syntax
nnoremap <Leader>tt :set syntax=tt2<CR>

" =ts : insert date line into debian changelog
nnoremap <Leader>ts 0I -- Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>  <ESC>:r !date +'\%a, \%-d \%b \%Y \%X \%z'<CR>kJ

" =- last buffer
nnoremap <Leader>- :n#<CR>

" == open bufexplorer menu
nnoremap <Leader>= :BufExplorer<CR>

" =ga git add current file
nnoremap <Leader>ga :!clear && git add %<CR>

" =gd git diff current file
nnoremap <Leader>gd :!clear && git diff %<CR>
"
" =gd git status
nnoremap <Leader>gs :!clear && git st<CR>

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

" =rs reload syntax
nnoremap <Leader>rs :syntax sync fromstart<CR>

" =pN resize tmux pane to N pages (81 * N - 1)
nnoremap <Leader>p1 :!tmux resize-pane -x 80<cr>
nnoremap <Leader>p2 :!tmux resize-pane -x 161<cr>
nnoremap <Leader>p3 :!tmux resize-pane -x 242<cr>

if filereadable($HOME."/.dotfiles/local/vimrc")
    source ~/.dotfiles/local/vimrc
endif

if filereadable("./.vimrc.local")
    sandbox source ./.vimrc.local
endif
