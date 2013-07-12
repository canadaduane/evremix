#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$1
BASE="$( basename "$FILE" )"
OUTDIR="$( dirname "$FILE" )/${BASE%.txt}"

echo "Preparing $FILE"

mkdir -p "$OUTDIR"
for N in 1 2 3 4 5; do
  pv "$FILE" \
  | "${DIR}/filtergoogle" \
  | "${DIR}/cleantext" \
  | tee "${OUTDIR}/words.txt" \
  | "${DIR}/mkngrams" -n ${N} -b \
  | gzip -c \
  >"${OUTDIR}/${N}-grams.txt.gz"
done