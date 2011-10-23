#!/bin/bash

# setup tmux colors
case $SOLARIZED in

    dark)
        tmux set window-status-current-attr dim
        tmux set window-status-current-bg black      # base02
        tmux set window-status-current-fg yellow     # yellow

        tmux set status-attr bold
        tmux set status-bg black                     # base02
        tmux set status-fg green                     # base01
        ;;

    light)
        tmux set window-status-current-attr dim
        tmux set window-status-current-bg white      # base2
        tmux set window-status-current-fg yellow     # yellow

        tmux set status-attr bold
        tmux set status-bg white                     # base2
        tmux set status-fg cyan                      # base1
        ;;

    *)
        tmux set status-bg blue
        tmux set status-fg white
        tmux set status-right-fg yellow
        tmux set window-status-current-bg cyan
        tmux set window-status-current-fg black
        ;;

esac
