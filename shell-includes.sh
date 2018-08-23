#===============================================================================
# NAME
#        shell-includes.sh - Meta to file for all libraries in the project
#
# SYNOPSIS
#        . shell-includes.sh
#
# DESCRIPTION
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

[[ -n "$LIB_SOURCE_SH" ]] && return
LIB_SOURCE_SH=1

get_sh_directory() {
    local SOURCE DIR
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    echo $DIR
}

LIBRARY_LOCALIZATION=$(get_sh_directory)
LIBRARY=${LIBRARY:-$LIBRARY_LOCALIZATION}

for lib in "$LIBRARY/"*.sh; do
    if [[ "${lib##*/}" = "${BASH_SOURCE[0]##*/}" ]]; then
	    continue
    fi
	source "$lib"
done

unset LIBRARY LIBRARY_LOCALIZATION
