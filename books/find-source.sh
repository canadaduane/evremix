#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

find $DIR/baseline2 -name "$1".txt.gz -exec $DIR/find-source-helper.sh {} "$2" \;
