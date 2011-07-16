function! FontExists(fontname)
    let x=system("fc-list | grep -q '" . a:fontname . "'")
    return v:shell_error == 0
endfunction

if FontExists("Fixedsys Excelsior 3.01")
    " X version of the fixed sys font
    set guifont=Fixedsys\ Excelsior\ 3.01-L\ 12
elseif FontExists("FixedSys")
    " Mac version of the fixed sys font
    set guifont=Fixedsys\ :h15
else
    set guifont=liberation\ mono\ 12
endif

set columns=80
set guioptions=egmrL
set guitablabel=%t%m
set showtabline=2

colorscheme solarized

if filereadable($HOME."/.dotfiles/gvimrc.local")
    source ~/.dotfiles/gvimrc.local
endif
