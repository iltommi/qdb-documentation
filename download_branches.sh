#!/bin/bash -eu

cd $(dirname $0)

git fetch

ORIGIN=$(git config --get remote.origin.url)
BRANCHES=$(git branch --list --sort=version:refname --remotes origin/* | grep -E '^\s*origin/[0-9]+.[0-9]+.[0-9]$' | sed 's|origin/||')

for BRANCH in $BRANCHES; do
    if [ -e "source/$BRANCH/.git" ]; then
        echo "Pulling branch $BRANCH"
        git -C "source/$BRANCH" pull --quiet
    else
        echo "Cloning branch $BRANCH"
        git clone --quiet --depth 1 --branch $BRANCH $ORIGIN "source/$BRANCH"
    fi
    LATEST=$BRANCH
done

(
    export BRANCHES=$(echo ${BRANCHES[*]})
    export LATEST

    echo "Generate index.html"
    envsubst <source/index.html.in >source/index.html

    echo "Generate version_switch.html"
    envsubst <source/shared/_static/version_switch.js.in >source/shared/_static/version_switch.js
)
