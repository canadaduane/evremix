#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat $DIR/baseline2/all-1grams.txt \
| ruby -e '$stdin.each_line{ |e| c1, c2 = e.strip.split(" "); puts "%07d %s" % [c1, c2] }' \
| grep 0000001 \
| awk '{print $2;}' \
| comm -12 ../bom/1-grams.txt -