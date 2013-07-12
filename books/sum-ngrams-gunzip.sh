#!/bin/bash

echo "$1" 1>&2
gunzip -c "$1"