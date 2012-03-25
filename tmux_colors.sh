# Color component of foreground colour+attr pair
export SOLARIZED_BASE03_FG=black
export SOLARIZED_BASE02_FG=black
export SOLARIZED_BASE01_FG=green
export SOLARIZED_BASE00_FG=yellow
export SOLARIZED_BASE0_FG=blue
export SOLARIZED_BASE1_FG=cyan
export SOLARIZED_BASE2_FG=white
export SOLARIZED_BASE3_FG=white
export SOLARIZED_YELLOW_FG=yellow
export SOLARIZED_ORANGE_FG=red
export SOLARIZED_RED_FG=red
export SOLARIZED_MAGENTA_FG=magenta
export SOLARIZED_VIOLET_FG=magenta
export SOLARIZED_BLUE_FG=blue
export SOLARIZED_CYAN_FG=cyan
export SOLARIZED_GREEN_FG=green

# Attr component of foreground color+attr pair
export SOLARIZED_BASE03_ATTR=bright
export SOLARIZED_BASE02_ATTR=dim
export SOLARIZED_BASE01_ATTR=bright
export SOLARIZED_BASE00_ATTR=bright
export SOLARIZED_BASE0_ATTR=bright
export SOLARIZED_BASE1_ATTR=bright
export SOLARIZED_BASE2_ATTR=dim
export SOLARIZED_BASE3_ATTR=bright
export SOLARIZED_YELLOW_ATTR=dim
export SOLARIZED_ORANGE_ATTR=bright
export SOLARIZED_RED_ATTR=dim
export SOLARIZED_MAGENTA_ATTR=dim
export SOLARIZED_VIOLET_ATTR=bright
export SOLARIZED_BLUE_ATTR=dim
export SOLARIZED_CYAN_ATTR=dim
export SOLARIZED_GREEN_ATTR=dim

# Background colors don't have attributes in curses (do they?)
export SOLARIZED_BASE02_BG=black
export SOLARIZED_BASE2_BG=white
export SOLARIZED_YELLOW_BG=yellow
export SOLARIZED_RED_BG=red
export SOLARIZED_MAGENTA_BG=magenta
export SOLARIZED_BLUE_BG=blue
export SOLARIZED_CYAN_BG=cyan
export SOLARIZED_GREEN_BG=green

set_tmux_color() {
    local var_base=$1
    local fg_color=$2
    local bg_color=$3

    eval "export TMUX_COLOR_${var_base}_BG=\$SOLARIZED_${bg_color}_BG"
    eval "export TMUX_COLOR_${var_base}_FG=\$SOLARIZED_${fg_color}_FG"
    eval "export TMUX_COLOR_${var_base}_ATTR=\$SOLARIZED_${fg_color}_ATTR"
}

# setup tmux colors
case $SOLARIZED in

    dark)
        set_tmux_color STATUS                   BASE01  BASE02
        set_tmux_color WINDOW_STATUS_CURRENT    YELLOW  BASE02
        ;;

    light)
        set_tmux_color STATUS                   BASE1   BASE2
        set_tmux_color WINDOW_STATUS_CURRENT    YELLOW  BASE2
        ;;

    *)
        # Non-solarized colors
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_ATTR=bold
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_BG=cyan
        export TMUX_COLOR_WINDOW_STATUS_CURRENT_FG=black

        export TMUX_COLOR_STATUS_ATTR=bold
        export TMUX_COLOR_STATUS_BG=blue
        export TMUX_COLOR_STATUS_FG=white
        ;;

esac
