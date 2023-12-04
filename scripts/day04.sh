#!/bin/bash

# https://adventofcode.com/2023/day/4

cat $1 | sed 's/Card *[0-9]*: *//g' | awk 'BEGIN { FS = " *\\| *" } { delete wnums; delete nums; card = 0; } { split($1, wnumarr, / */); for (i in wnumarr) { wnums[wnumarr[i]] } } { split($2, numarr, / */); for (i in numarr) { nums[numarr[i]] } } { for (num in nums) { if (num in wnums) { card += 1 } }} { if (card) total += 2^(card - 1) } END {print "tot " total}'
