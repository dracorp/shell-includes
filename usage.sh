#===============================================================================
# NAME
#        usage.sh - Function to print documentation like this one
#
# SYNOPSIS
#        . usage.sh
#        _help [EXIT_CODE]
#        _usage [EXIT_CODE]
#        _version
#
# DESCRIPTION
#        Prints comments of the form "# This is a comment" at the start of the
#        sourcing file to standard error, trimming the two first characters.
#        Stops printing when it encounters either a line starting with two
#        hashes (see below) or a line without a comment.
#
#        Skips the shebang line if there is one.
#
#        Returns from the sourcing file with the given exit code (default 0).
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

_help() {
    local header line retval
    local pre_header=''
    local lib_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    if [[ ! -r "$0" ]]; then
        printf '%s\n' "Wrong usage of library ${lib_path}! Use it in a shell script." >&2
        return 1
    fi
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            '#!'*) # Shebang line
                ;;
            '#='*) # comment from header
                ;;
            ''|'##'*|'#='*|[!#]*) # End of comments
                retval=$1
                if [[ ! $retval =~ ^-?[0-9] ]]; then
                    retval=0
                fi
                exit $retval
                ;;
            *) # Comment line
                line=${line:2} # Remove comment prefix
                if [[ "$1" = usage ]]; then
                    # print only usage
                    if [[ "${line}" =~ ^[A-Z\s]+$ ]]; then
                        header=${line}
                    fi
                    if [[ "$header" = SYNOPSIS ]]; then
                        if [[ "$line" = SYNOPSIS ]]; then
                            printf '%s' 'Usage:' >&2
                        else
                            printf '%s\n' "${line}" >&2
                            retval=$2
                            if [[ ! $retval =~ ^-?[0-9] ]]; then
                                retval=0
                            fi
                            exit $retval
                        fi
                    else
                        pre_header=$header
                    fi
                else
                    printf '%s\n' "${line}" >&2
                fi
                ;;
        esac
    done < "$0"
}

_usage() {
    _help usage $1
}

_version() {
    if [[ -z "$PROGRAM_VERSION" ]]; then
        local PROGRAM_VERSION=undef
    fi
    if [[ -n "$PROGRAM_NAME" ]]; then
        printf '%s\n' "$PROGRAM_NAME version $PROGRAM_VERSION"
        if [[ ! -r "$0" ]]; then
            return 0
        else
            exit 0
        fi
    else
        if [[ ! -r "$0" ]]; then
            return 1
        else
            exit 1
        fi
    fi
}

usage() {
    _usage "$@"
}

version() {
    _version "$@"
}
