#!/bin/bash

remove_dots_and_slashes() {
    local x=$1

    # If the x is relative, make it absolute.
    [[ "$x" =~ ^/.* ]] || x="$PWD/$x"

    # Resolve any ".../foo/../..." to ".../..."
    # Resolve any ".../foo/.." to "..."
    x=$(echo "$x" | sed -Ee 's/(.*)\/[^\/]+\/\.\.(\/.*)/\1\2/g')
    x=$(echo "$x" | sed -Ee 's/(.*)\/[^\/]+\/\.\.$/\1/g')

    # Resolve any "..././..." to ".../..."
    # Resolve any ".../." to "..."
    x=$(echo "$x" | sed -Ee 's/(.*)\/\.(\/.*)/\1\2/g')
    x=$(echo "$x" | sed -Ee 's/(.*)\/\.$/\1/g')

    # Resolve any "...//..." to ".../..."
    x=$(echo "$x" | sed -Ee 's/(.*)\/\/(.*)/\1\/\2/g')

    echo $x
}

resolved() {
    # Try to resolve via readlink.
    local x="$(readlink "$1")"
    [[ -z "$x" ]] && x="$1"

    # Remove any trailing "/" added by readlink when resolving a link to a
    # directory.
    x=$(echo "$x" | sed -Ee 's/(.*)\/$/\1/')

    echo "$x"
}

join() {
    # Join a directory and new component. Special case being at the top with
    # "/", as that would lead to "//DIR".
    [[ "$1" == "/" ]] && echo "/$2" || echo "$1/$2"
}

realpath1() {
    # The approach here is to break the path into directory and name,
    # recursively call realpath on the directory, append the name to the
    # result, and pass that full string to readlink to see if it itself needs
    # to be resolve. Since this is a recursive routine, we check for bottoming
    # out by seeing if we're at the root directory.

    # Break our input into directory and name.
    dir="$(dirname "$1")"
    file="$(basename "$1")"

    # If we're at the root, just return.
    [[ "$dir" == "/" ]] && { echo "$1"; return; }

    # Resolve the directory, append the file name, and the resolve the result.
    echo "$(resolved "$(join "$(realpath "$dir")" "$file")")"
}

realpath() {
    # This implementation (along with supporting functions above) is the one I
    # came up with.
    realpath1 "$(remove_dots_and_slashes "$1")"
}

realpath() {
    # Found on the web:
    # Gets the answer wrong on ".../symlink/../file" -- it will try to go to
    # the parent of what the symlink points to, not the parent of the symlink.
    python -c 'import os, sys; print os.path.realpath(sys.argv[1])' "$1"
}

realpath() {
    # Found on the web:
    # Prints current path, not resolved argument.
    perl -MCwd=abs_path -le 'print abs_path readlink(shift);' "$1"
}

realpath() {
    # Found on the web:
    # Found it in here:  http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
    # A variant is here: http://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-osx
    # A variant is here: http://stackoverflow.com/questions/5756524/how-to-get-absolute-path-name-of-shell-script-on-macos
    # Seems solid.

    TARGET_FILE="$1"

    # Switch to the target directory, and get the bare file name.
    cd "$(dirname $TARGET_FILE)" &> /dev/null || { echo ""; return; }
    TARGET_FILE="$(basename $TARGET_FILE)"

    # Starting with the current directory and bare file name, iterate down a
    # (possible) chain of symlinks. Resolve the file name, (possibly) getting a
    # new directory and file name. CD to that directory and repeat until we no
    # longer point to a symbolic link. When done, we should be in the final
    # directory with $TARGET_FILE containing the real name.
    while [ -L "$TARGET_FILE" ]
    do
        TARGET_FILE="$(readlink "$TARGET_FILE")"
        cd "$(dirname "$TARGET_FILE")" &> /dev/null || { echo ""; return; }
        TARGET_FILE="$(basename "$TARGET_FILE")"
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    echo "$(pwd -P)/$TARGET_FILE"
}

realpath "$1"

# See the following for an extensive implementation and some test code.
# https://github.com/mkropat/sh-realpath
# Article providing that reference: http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
