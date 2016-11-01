#!/bin/false
#
# anymake is copyright 2016 Brian Parks (http://brianparks.me)
# anymake is licensed under the terms of the GNU GPL v3
# You should find a copy of this license "near" the installed
# version of this file; otherwise at gnu.org
#
# This file should be SOURCED:
#  . anymake.sh
#  source anymake.sh

__anymake() {
    # Anymake can be invoked as any number of commands
    # (see the "invocations" section below), each of which
    # alters the behavior somewhat. Most often, it is
    # invoked as `make`, typically with no arguments, so
    # it is our responsibility to determine what is actually
    # intended by this "default" invocation

    # If this is a standard configure/make/make install package,
    # then we just pass through to the appropriate command

    if [ "$0" == "qmake" ] ; then
        # Assume qmake operation is intended
        \qmake $@
        return $?
    elif [ "$0" == "cmake" ] ; then
        # Assume cmake operation is intended
        \cmake $@
        return $?
    elif [ -e Makefile -o -e makefile -o -e GNUmakefile ] ; then
        \make $@
        return $?
    elif [ -e configure -a -x configure ] ; then
        echo This is a standard GNU automake project. Please run ./configure
        echo before running make.
        return 1
    elif [ -e package.json ] ; then
        npm install
        return $?
    elif [ -e composer.json ] ; then
        composer install
        return $?
    else
        echo Unable to automatically detect build system
        echo If it is a fairly standard one, please consider adding support
        echo to https://github.com/bparks/anymake. Alternately, you can add
        echo support for this project by adding a .anymake file with contents
        echo like the following:
        echo "    config=configure_command"
        echo "    make=make_command"
        echo "    install=install_command"
    fi

    if [ $# -ge 1 -a "x$1" == "xinstall" ] ; then
        # Install mode
        echo Install mode
    fi

}


# Invocations
alias make=__anymake
alias cmake=__anymake
alias qmake=__anymake
