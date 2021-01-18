#!/bin/bash
# What need change? {{{1
#   - Help()
#   - GetOpts()
#   - Main()    our script here
#
declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/lib_common.sh

# header {{{1
#   sample.sh -- script template
NOTE="a script template"
_DEBUG="off"
verbose=0
dryrun="off"

# functions {{{1
# help {{{2
Help ()
{
cat << EOF
Usage: ${0##*/} [-hvdn] [-m <message>]

Options:
  -h  help
  -v  verbose
  -d  debug
  -n  dry-run

Samples:
  ./${0##*/} -dn -m "hello"

EOF
exit ${1:-0}
}

# basic function {{{2
GetOpts ()
{
    if [ $# -eq 0 ]; then
        Help >&2
    fi

    # Reset is necessary if getopts was used previously in the script.
    OPTIND=1
    local opt
    while getopts "hvdnm:" opt; do
    case "$opt" in
    h)
        Help
        ;;
    v)  verbose=$OPTARG
        ;;
    d)  _DEBUG="on"
        ;;
    n)  dryrun="on"
        ;;
    m)  usermsg=$OPTARG
        ;;
    \?)
        Help >&2
        ;;
    *)
        Help >&2
        ;;
    esac
    done
    # Shift off the options and optional
    shift "$((OPTIND-1))"

    # Check options
    if [ -z "${usermsg}" ] || [ -z "${verbose}" ]; then
        Help
    fi
}

DEBUG() { [ "$_DEBUG" == "on" ] && $@; }
Echo () { echo "# $(basename $0): $*"; }
Die()   { echo $1; exit 1; }

Run ()
{
    if [ "$dryrun" == "off" ]; then
        eval "$@"
    else
        echo "Will $*"
        return 0
    fi
}

# user function {{{2

Demo()
{
    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"

    Run "ls"
    Run ls -l

    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# Main: user script {{{1
Main ()
{
    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
    printf "$NOTE: dry=$dryrun v=$verbose\n"
    ################################################

    # Put our script here {{{2
    Demo

    ################################################
    DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
}

# footer {{{1
old_dir=$(pwd) 2> /dev/null
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]} {{{${#FUNCNAME[@]}\n"
GetOpts "$@"
DEBUG set -vx
Main "$@"
DEBUG set +vx
DEBUG printf "###$(basename $0):${BASH_LINENO[0]}: ${FUNCNAME[0]}{{{${#FUNCNAME[@]}\n"
cd $old_dir
# End of file

