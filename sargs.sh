sargs() {

    local xargs_args=""
    while getopts 'n:' OPTION; do
        case $OPTION in

        n) 
            xargs_args+="-n $OPTARG"
            bval="$OPTARG"
            ;;

        ?) 
            printf "Usage: %s: [-n num] args\n" $(basename $0) >&2
            exit 2
            ;;

        esac
    done
    shift $(($OPTIND - 1))

    iselect -m -a -e | xargs -r -d '\n' $xargs_args $@;
}
