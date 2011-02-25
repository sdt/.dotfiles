function! FontExists(fontname)
    let x=system("fc-list | grep -q '" . a:fontname . "'")
    return v:shell_error == 0
endfunction

if FontExists("Fixedsys Excelsior 3.01")
    set guifont=Fixedsys\ Excelsior\ 3.01-L\ 12
else
    set guifont=DejaVu\ Sans\ Mono\ 11
endif

set columns=80

if filereadable($HOME."/.dotfiles/gvimrc.local")
    source ~/.dotfiles/gvimrc.local
endif
