#===============================================================================
# NAME
#        message.sh - Function to print various messages
#
# SYNOPSIS
#        . messages.sh
#
# DESCRIPTION
#   Do not use for Ksh shell!
#
# BUGS
#        https://github.com/dracorp/shell-includes/issues
#
# COPYRIGHT AND LICENSE
#        Copyright (C) 2010-2013 Victor Engmark
#
#        This program is free software: you can redistribute it and/or modify it
#        under the terms of the GNU General Public License as published by the
#        Free Software Foundation, either version 3 of the License, or (at your
#        option) any later version.
#
#        This program is distributed in the hope that it will be useful, but
#        WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#        General Public License for more details.
#
#        You should have received a copy of the GNU General Public License along
#        with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#===============================================================================

if echo $SHELL | grep -q ksh; then
    return 1
fi

: ${USE_COLOR=y}
# check if messages are to be printed using color {{{
if [[ -t 2 && ! $USE_COLOR = "n" ]]; then
    : echo "Nop"
else
    unset ALL_OFF BOLD BLUE GREEN RED YELLOW
fi

plain() {
    (( QUIET )) && return
    typeset CR="\n"
    if [[ "$1" == '-n' ]]; then
        CR='';shift
    fi
    typeset mesg=$1; shift
    printf "${BOLD}%s${ALL_OFF} %s${CR}" "$mesg" "$*" >&1
}

msg() {
    (( QUIET )) && return
    typeset CR="\n"
    if [[ "$1" == '-n' ]]; then
        CR='';shift
    fi
    typeset mesg=$1; shift
    printf "${GREEN}${ALL_OFF}${BOLD}%s${ALL_OFF} %s${CR}" "$mesg" "$*" >&1
}

INFO() {
    msg "INFO: $@"
}

msg2() {
    (( QUIET )) && return
    typeset CR="\n"
    if [[ "$1" == '-n' ]]; then
        CR='';shift
    fi
    typeset mesg=$1; shift
    printf "${BLUE}   ->${ALL_OFF}${BOLD}%s${ALL_OFF} %s${CR}" "$mesg" "$*" >&1
}

warning() {
    typeset CR="\n"
    if [[ "$1" == '-n' ]]; then
        CR='';shift
    fi
    typeset mesg=$1; shift
    printf "${YELLOW}$(gettext "WARNING:")${ALL_OFF}${BOLD} %s${ALL_OFF} %s${CR}" "$mesg" "$*" >&2
}

WARN() {
    warning "$@"
}

error() {
    typeset CR="\n"
    if [[ "$1" == '-n' ]]; then
        CR='';shift
    fi
    typeset mesg=$1; shift
    printf "${RED}$(gettext "ERROR:")${ALL_OFF}${BOLD} %s${ALL_OFF} %s${CR}" "$mesg" "$*" >&2
}

ERROR() {
    error "$@"
}

FAIL() {
    error "$@"
}

LOGEXIT() {
    error "$@"
    exit 1
    if [ "${BASH_SOURCE[0]}" == "$0" ]; then
        # invoked as script
        exit 1
    else
        # sourced by . or source command
        return 0
    fi
}

