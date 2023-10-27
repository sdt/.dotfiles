#!/bin/bash
set -e

# In lieu of cpm having support for default args in an env var.

# Use this just like you'd use cpm:
#  cpm.sh install Foo::Bar Foo::Baz

# Extra bonus install-cpm feature: cpm.sh install-cpm

if [[ $OSTYPE =~ darwin ]]; then
    nproc() { sysctl -n hw.logicalcpu; }
fi

cpm_install_args=(
    --color
    --local-lib-contained="$PERL_LOCAL_LIB_ROOT"
    --no-prebuilt
    --test
    --verbose
    --workers=$( nproc )
)

cpm="$PERL_LOCAL_LIB_ROOT/bin/cpm"

if [[ ($# == 1) && ($1 == install-cpm) ]]; then
    curl -fsSL https://raw.githubusercontent.com/skaji/cpm/main/cpm \
        | perl - install "${cpm_install_args[@]}" App::cpm
elif [[ ! -f "$cpm" ]]; then
    echo cpm not found at $cpm
    echo Run \"$0 install-cpm\" to install it
elif [[ ($# > 0) && ($1 == install) ]]; then
    # This is "cpm install @caller-args"
    # Convert to "cpm install @our-args @caller-args"
    shift   # shift off the install arg - we'll add that back manually
            # that leaves us with the rest of the options and args
    set -x
    "$cpm" install "${cpm_install_args[@]}" "$@"
else
    # By default pass everything straight through to cpm
    "$cpm" "$@"
fi
