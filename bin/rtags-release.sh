#!/bin/bash

SCRIPT_PATH=`dirname "$0"`;
SCRIPT_PATH=`eval "cd \"$SCRIPT_PATH\" && pwd"`

branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"     # detached HEAD
branch_name=${branch_name##refs/heads/}

if [ "$branch_name" == "master" ]; then
    commit=`git show --oneline --no-patch`
    cd "$SCRIPT_PATH/.."
    rm -f rtags.tar
    $SCRIPT_PATH/git-archive-all rtags.tar
    rm -rf rtags-release-repo
    git new-workdir $PWD rtags-release-repo gh-pages
    cd rtags-release-repo
    git pull origin gh-pages
    rm -f rtags.tar.gz rtags.tar.bz2 rtags.tar
    mv ../rtags.tar .
    gzip --keep rtags.tar
    bzip2 rtags.tar
    git add rtags.tar.gz rtags.tar.bz2
    git commit -m "Release for $commit"
    git push origin gh-pages
    cd ..
    rm -rf rtags-release-repo
fi
