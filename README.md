NAME
====
gitwork - a proposal to add working branch management commands to git

DESCRIPTION
===========
This project builds a package that can be used to update an existing git installation with scripts
and man pages that implement the proposed **git work** and **git base** commands.

In this way, people who are not in a position to rebuild their own version of git can still
make use of the proposed commands.

For more details about the commands provided by this package, read:
<ul>
<li><a href="https://jonseymour.s3.amazonaws.com/git-work.html" target="browse">git-work(1)</a></li>
<li><a href="https://jonseymour.s3.amazonaws.com/git-base.html" target="browse">git-base(1)</a></li>
<li><a href="https://jonseymour.s3.amazonaws.com/git-atomic.html" target="browse">git-atomic(1)</a></li>
<li><a href="https://jonseymour.s3.amazonaws.com/git-test.html" target="browse">git-test(1)</a></li>
</ul>
or refer to the installed man pages, for example:

       man git-work

BUILD
=====
The best way to build git work is simply to fetch git://github.com/jonseymour/git into your
copy of the git repo, check out its work branch and build git in the normal way. If you are happy 
to do this, you can ignore the following instructions which only apply to people who want to build
or install a tarball with the proposed additions in order to patch existing git installations.

The instructions that follow immediately are for people that want to build their own tarball containing
the git work additions. People who are happy to use a pre-built tarball may skip to the INSTALLATION section.

To build the package, you must have a working git installation and be able to build git
and its documentation. You do not, however, have to install git as part of this process.

Obtain the source:

       git clone git://github.com/jonseymour/gitwork
       cd gitwork

Make the tarball:

       git clone git://github.com/jonseymour/gitwork
       cd gitwork
       sh ./installer make-tar

This command will use git's make command to build the git documentation but
will not attempt to install git itself.

INSTALLATION
============
To install the package you need a working git installation that you have the
permission to update, a unix shell and tar and a copy of the git-work tarball
that you built yourself or obtained from the <a href="https://github.com/jonseymour/gitwork/archives/master">download</a>
location.

If you have just built the tarball, you can simply change into the
build/gitwork-vX.X.X directory, otherwise unpack the tarball
as follows:

        gzip -dc gitwork-vX.X.X.tar.gz | tar -xvf -
        cd gitwork-vX.X.X

Once you are in the root directory of the untar'd package, run:

        sh ./installer install

This command will update the version of git found in git --exec-path.

To install the documentation, run:

        sh ./installer install-man

This command will install the man pages into $(git --exec-path)/../../share/man/man1.

Note that the installer does not modify any files of the existing git installation - it simply
adds new files. One consequence of this is that the git config documentation is not updated. To
see the proposed updated, please refer to the description of branch.&lt;name&gt;.baseresetoptions
in [git-config(1)](https://jonseymour.s3.amazonaws.com/git-config.html).

UPDATING
========
If you ever need to update your version of gitwork, change to
the root of your clone and run:

       git fetch origin
       git checkout -f origin/master # or choose the tag you want to build
       git submodule update

then re-run the BUILD procedure.

UNINSTALL
=========
If you need to uninstall gitwork, run the following command:

        sh ./installer uninstall

RATIONALE
=========
At this stage the **git work** and **git base** commands are proposed for inclusion
into git, however, there is no guarantee that the proposal will be accepted. The
objective of this package is to allow people to experiment with the proposed
commands while the proposal is being evaluated.
