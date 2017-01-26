#!/bin/sh
#
# This coverage script is originally created by mlafeldt
#
# See the following link for original version
# https://github.com/mlafeldt/chef-runner/blob/v0.7.0/script/coverage
#
# Modification
#
# * Remove absolute path generated in .cover/*.cover
# 
# Original document
#
# Generate test coverage statistics for Go packages.
#
# Works around the fact that `go test -coverprofile` currently does not work
# with multiple packages, see https://code.google.com/p/go/issues/detail?id=6909
#
# Usage: script/coverage [--html|--coveralls]
#
#     --html      Additionally create HTML report and open it in browser
#     --coveralls Push coverage statistics to coveralls.io
#

set -e

pwd=$('pwd')
pwdpat=${pwd//\//\\\/}
workdir=.cover
profile="$workdir/cover.out"
mode=count

generate_cover_data() {
    rm -rf "$workdir"
    mkdir "$workdir"

    for pkgpath in "$@"; do
        pkg=${pkgpath/_$pwd/./}
        f="$workdir/$(echo $pkg | tr / - | tr . _).cover"
        go test -covermode="$mode" -coverprofile="$f" "$pkg"
        if [ -e $f ]; then
            sed -i '.orig' "s/_$pwdpat/./g" $f
        fi
    done

    echo "mode: $mode" >"$profile"
    grep -h -v "^mode:" "$workdir"/*.cover >>"$profile"
}

show_cover_report() {
    go tool cover -${1}="$profile"
}

push_to_coveralls() {
    echo "Pushing coverage statistics to coveralls.io"
    goveralls -coverprofile="$profile"
}

generate_cover_data $(go list ./...)
show_cover_report func
case "$1" in
"")
    ;;
--html)
    show_cover_report html ;;
--coveralls)
    push_to_coveralls ;;
*)
    echo >&2 "error: invalid option: $1"; exit 1 ;;
esac