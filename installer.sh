#!/bin/sh

SCRIPTS="git-work git-base git-atomic git-test git-atomic-lib git-conditions-lib git-test-lib"
MANPAGES="git-work.1 git-base.1 git-atomic.1 git-test.1"

die()
{
    echo "$*" 1>&2
    exit 1
}

warn()
{
    echo "$*" 1>&2
}

require_mkdir()
{
    if test -d "$1"
    then
        mkdir -p "$1" || die "unable to make directory: \"$1\""
    fi
}

clean_build()
{
    if test -d build
    then
	rm -rf build && ! test -d build || die "clean failed"
    fi
}

require_build()
{
    require_mkdir build
}

make_package()
{
    mkdir -p build/${VERSION}/libexec/git-core &&
    mkdir -p build/${VERSION}/share/man/man1 || die "failed to make build directories"
    for f in $SCRIPTS
    do
	TARGET="build/${VERSION}/libexec/git-core/$f" &&
	cp git/${f}.sh "$TARGET" &&
	chmod 0755 "$TARGET" || die "failed to copy $f"
    done

    for m in $MANPAGES
    do
	cp git/Documentation/$m build/${VERSION}/share/man/man1 || die "failed to copy $m"
    done

    cp installer.sh build/${VERSION}

    pushd build 1>&2 &&
    tar -cf - ${VERSION} | gzip -c > ${VERSION}.tar.gz || die "failed to create .tar.gz file"
    echo build/${VERSION}.tar.gz
}


init_submodule()
{
    git submodule init &&
    git submodule update
}

require_git_exec_path()
{
    EXECPATH=$(git --exec-path) &&
    test -n "$EXECPATH" &&
    test -d "$EXECPATH" &&
    test -w "$EXECPATH" || die "\"$EXECPATH\" does not exist or is not a writeable directory"

    MANDIR=$EXECPATH/../../share/man/man1
}

install()
{
    (
	cd $ROOT &&
	require_git_exec_path &&
	chmod 0755 $ROOT/libexec/git-core/$* &&
	cp -p $ROOT/libexec/git-core/* ${EXECPATH} || die "failed to copy files to $EXECPATH"
	warn gitwork installed to ${EXECPATH}
    ) || exit $?
}

install_man()
{
    (
	cd $ROOT &&
	require_git_exec_path

	require_mkdir "$MANDIR"

	chmod 0644 $ROOT/share/man/man1/* &&
	cp -p $ROOT/share/man/man1/* "${MANDIR}" || die "failed to copy files to \"$MANDIR\""
	warn gitwork man pages installed to ${MANDIR}
    ) || exit $?
}

uninstall()
{
    require_git_exec_path
    for s in $SCRIPTS
    do
	if test -f ${EXECPATH}/$s
	then
	    rm ${EXECPATH}/$s || die "unable to remove ${EXECPATH}/$s"
	fi
    done

    for m in $MANPAGES
    do
	if test -f ${MANDIR}/$m
	then
	    rm ${MANDIR}/$m || die "unable to remove ${MANDIR}/$m"
	fi
    done
    warn gitwork uninstalled.
}

make_tar()
{
    (
	cd $ROOT &&
	init_submodule &&
	clean_build &&
	require_build &&
	pushd git/Documentation 1>&2 &&
	make $MANPAGES 1>&2 &&
	VERSION=$(git describe --tags) &&
	popd 1>&2 &&
	make_package ${VERSION}
    ) || exit $?
}

ROOT=$(cd $(dirname $0); pwd)

cmd=$1
test $# -gt 0 && shift

case "$cmd" in
    install)
	install "$@"
	break;
    ;;
    install-man)
	install_man "$@"
	break;
    ;;
    make-tar)
	make_tar "$@"
	break;
    ;;
    uninstall)
	uninstall "$@"
	break;
    ;;
    *)
	die "usage: ./installer.sh install|install-man|make-tar|uninstall";
    ;;
esac
