#!/bin/bash -eu

cd $(dirname $0)

git fetch

ORIGIN=$(git config --get remote.origin.url)
BRANCHES=$(git branch --list --sort=version:refname --remotes origin/* | grep -E '^\s*origin/(master|[0-9]+.[0-9]+.[0-9])$' | sed 's|origin/||')

if [[ $# -ge 1 ]] ; then
    ADDITIONAL_BRANCH=$1
    if [[ ! -z ${ADDITIONAL_BRANCH// } ]] ; then
        BRANCHES+=" ${ADDITIONAL_BRANCH}"
    fi
fi

echo 'Branches:' $BRANCHES

declare -a BRANCH_NAMES
for BRANCH in $BRANCHES; do
    if [ -e "source/$BRANCH/.git" ]; then
        echo "Pulling branch $BRANCH"
        git -C "source/$BRANCH" pull --quiet
    else
        echo "Cloning branch $BRANCH"
        git clone --quiet --depth 1 --branch $BRANCH $ORIGIN "source/$BRANCH"
    fi

    BRANCH_NAME=${BRANCH}
    if [ -e "source/$BRANCH/source/conf.py" ] ; then
        BRANCH_NAME=$(python -c "execfile('source/${BRANCH}/source/conf.py') ; print(release)")
    fi
    BRANCH_NAMES+=" ${BRANCH_NAME}"
    LATEST=$BRANCH
done

(
    # Do not use underscores in variables passed to envsubst!
    export BRANCHES=$(echo ${BRANCH_NAMES[*]})
    export LATEST

    echo "Generate index.html"
    envsubst \$LATEST <source/index.html.in >source/index.html

    echo "Generate version_switch.html"
    envsubst \$BRANCHES <source/shared/_static/version_switch.js.in >source/shared/_static/version_switch.js
)
