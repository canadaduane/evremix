#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT=`basename $0`
TMPFILE=`mktemp /tmp/${SCRIPT}.XXXX` || exit 1

gunzip -c $1/${2}-grams.txt.gz \
| awk '{$1=""; print $0}' \
| cut -b2- \
| comm -12 $DIR/bom/${2}-grams.txt - >"$TMPFILE"

gunzip -c "$DIR/baseline2/all-${2}grams.txt.gz" \
| ruby $DIR/compare.rb "$TMPFILE"
