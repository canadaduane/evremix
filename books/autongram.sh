#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for FILE in *.txt; do
  echo "$FILE"
  $DIR/make-ngrams.sh "$FILE"
done