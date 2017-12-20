#!/bin/sh
set -eu -o pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]] ; then
    >&2 echo "Usage: $0 <new_version>"
    exit 1
fi

INPUT_VERSION=$1; shift

MAJOR_VERSION=${INPUT_VERSION%%.*}
WITHOUT_MAJOR_VERSION=${INPUT_VERSION#${MAJOR_VERSION}.}
MINOR_VERSION=${WITHOUT_MAJOR_VERSION%%.*}
WITHOUT_MINOR_VERSION=${INPUT_VERSION#${MAJOR_VERSION}.${MINOR_VERSION}.}
PATCH_VERSION=${WITHOUT_MINOR_VERSION%%.*}

XY_VERSION="${MAJOR_VERSION}.${MINOR_VERSION}"
XYZ_VERSION="${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}"

if [[ "${INPUT_VERSION}" == *-* ]] ; then
    TAGS_VERSION=${INPUT_VERSION#*-}
else
    TAGS_VERSION=
fi

if [[ -n "${TAGS_VERSION}" ]] ; then
    FULL_XYZ_VERSION="${XYZ_VERSION}-${TAGS_VERSION}"
else
    FULL_XYZ_VERSION="${XYZ_VERSION}"
fi

CURRENT_DATE=`date +%Y-%m-%d`

cd $(dirname -- $0)
cd ${PWD}/../..

# version = '2.0'
# release = '2.0.2'
sed -i \
    -e "s/version *= *'[^']*'/version = '${XY_VERSION}'/" \
    -e "s/release *= *'[^']*'/release = '${FULL_XYZ_VERSION}'/" \
    source/conf.py
