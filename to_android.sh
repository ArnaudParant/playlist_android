#!/bin/bash

## Global configuration

# At least works for oneplus one phone
SSD="storage/emulated/0/"

function usage()
{
    echo -e "Usage:\t$0 xfps_playlist_path xfps_output_path local_root remote_root"
    echo -e "\t -s, --ssd :\t convert path to store on ssd"
}

# urlencode <strin>
function urlencode()
{
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-/]) printf "$c" ;;
            *) printf '%s' "$c" | xxd -p -c1 |
                   while read c; do printf '%%%s' "$c"; done ;;
        esac
    done
}

function options()
{
    POS="0"
    for ARG in "$@"; do

        if [ "$ARG" == "--ssd" ] || [ "$ARG" == "-s" ]; then PREFIX="$SSD"
        else

            if [ "$POS" -eq "0" ]; then PLAYLIST="$ARG"
            elif [ "$POS" -eq "1" ]; then OUTPUT="$ARG"
            elif [ "$POS" -eq "2" ]; then LOCAL_ROOT="$ARG"
            elif [ "$POS" -eq "3" ]; then REMOTE_ROOT=$(urlencode "$ARG")
            fi

            POS=$(expr $POS + 1)
        fi
    done

    # echo "PLAYLIST: $PLAYLIST"
    # echo "OUTPUT: $OUTPUT"
    # echo "LOCAL_ROOT: $LOCAL_ROOT"
    # echo "REMOTE_ROOT: $REMOTE_ROOT"
    # echo "PREFIX: $PREFIX"

}

function run()
{
    echo "s#$LOCAL_ROOT#$PREFIX$REMOTE_ROOT#g"
    sed -e "s#$LOCAL_ROOT#$PREFIX$REMOTE_ROOT#g" $PLAYLIST > $OUTPUT
}

function main()
{
    ## Check the mandatory parameters
    if [ "$#" -lt "4" ]; then usage; exit 0; fi

    ## Get options
    options "$@"

    ## Run
    run
}

main "$@"