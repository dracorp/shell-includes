#!/bin/sh
# NAME
#        help.sh - Function to print documentation like this one
#
# SYNOPSIS
#        . help.sh
#        help [EXIT_CODE]
#        usage
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
#        https://github.com/l0b0/shell-includes/issues
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
################################################################################

help() { #{{{
    local header
    local pre_header=''
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            '#!'*) # Shebang line
                ;;
            '#='*) # comment from header
                ;;
            ''|'##'*|[!#]*) # End of comments
                return #"${1:-0}"
                ;;
            *) # Comment line
                line=${line:2} # Remove comment prefix
                if [[ "$1" = usage ]]; then
                    # print only usage
                    if [[ $pre_header = SYNOPSIS ]]; then
                        return
                    fi
                    if [[ "${line}" =~ ^[A-Z\s]+$ ]]; then
                        header=${line}
                    fi
                    if [[ "$header" = SYNOPSIS ]]; then
                        if [[ "$line" = SYNOPSIS ]]; then
                            printf '%s\n' 'Usage:' >&2
                        else
                            printf '%s\n' "${line}" >&2
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
} # end of function help }}}
usage() { #{{{
    help usage
} # end of function usage }}}
