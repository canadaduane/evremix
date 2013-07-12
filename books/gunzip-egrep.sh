#!/bin/bash

found=$(gunzip -c "$1" | egrep "$2")
if [[ $found != "" ]]; then
  echo "$1"
  echo $found
fi