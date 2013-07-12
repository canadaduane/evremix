#!/bin/bash

N=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

find $DIR/test -name $N-grams.txt.gz -exec $DIR/sum-ngrams-gunzip.sh {} \; \
| awk '{ for(i = 0; i < $1; i++) print $2 " " $3 " " $4 " " $5 " " $6; }' \
| sort \
| uniq -c