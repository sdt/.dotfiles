# setup tmux colors
case $SOLARIZED in

    dark)
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_ATTR=dim
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_BG=black      # base02
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_FG=yellow     # yellow

        export TMUX_COLOR_STATUS_ATTR=bold
        export TMUX_COLOR_STATUS_BG=black                     # base02
        export TMUX_COLOR_STATUS_FG=green                     # base01
        ;;

    light)
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_ATTR=dim
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_BG=white      # base2
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_FG=yellow     # yellow

        export TMUX_COLOR_STATUS_ATTR=bold
        export TMUX_COLOR_STATUS_BG=white                     # base2
        export TMUX_COLOR_STATUS_FG=cyan                      # base1
        ;;

    *)
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_ATTR=bold
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_BG=cyan
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_FG=black

        export TMUX_COLOR_STATUS_ATTR=bold
        export TMUX_COLOR_STATUS_BG=blue
        export TMUX_COLOR_STATUS_FG=white
        ;;

esac
