#!/usr/bin/env bash

grep -v "^#" dmel-all-r6.36.gtf \
| cut -f1,3 \
| sort -k2,2\
| grep "\<gene\>"\
| grep '[234LRXY]'\
| grep -v '[\d{15}]'\
| uniq -c\
| sort -rn
