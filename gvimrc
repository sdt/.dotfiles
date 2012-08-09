function! FontExists(fontname)
    let x=system("fc-list | grep -q '" . a:fontname . "'")
    return v:shell_error == 0
endfunction

if has("macunix")
    set guifont=inconsolata:h15
elseif has("unix")
    set guifont=Inconsolata\ 12
endif

set columns=80
set guioptions=egmrL
set guitablabel=%t%m
set mouse=
set showtabline=2

" ^A selects all
map <C-A> ggVG

" ^C yanks to clipboard in visual-select mode
vmap <C-C> "+y

" ^C-A does ^A ^C, but keeps cursor position
map <C-A><C-C> :%y+<CR>

" ^V pastes in insert mode and command-mode
" (insert mode needs special handling to override ^V)
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
cmap <C-V> <C-R>+

" ^-tab rotates through tabs
map <C-Tab> :tabn<cr>

if filereadable($HOME."/.dotfiles/gvimrc.local")
    source ~/.dotfiles/gvimrc.local
endif
