#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Comparing $1 with the Book of Mormon"
echo "(unique n-grams in BOTH, but not in KJV or Douay bibles)"
for N in 1 2 3 4 5 6; do
  echo -n "matching $N-grams: "
  $DIR/compare.sh $1 $N | wc | awk '{print $1;}'
done