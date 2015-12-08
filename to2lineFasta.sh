#!/bin/bash

awk '!/^>/ { printf "%s", $0; n = "\n" }  /^>/ { print n $0; n = "" } END { printf "%s", n }' $1
