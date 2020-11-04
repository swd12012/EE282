#!/usr/bin/env bash

grep -v "^#" dmel-all-r6.36.gtf \
| cut -f3 \
| sort\
| uniq -c\
|sort -rn
