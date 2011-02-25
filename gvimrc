set columns=80

if filereadable($HOME."/.dotfiles/gvimrc.local")
    source ~/.dotfiles/gvimrc.local
endif
