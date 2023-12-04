#!/bin/bash

# https://adventofcode.com/2023/day/4

cat $1 | sed 's/Card *[0-9]*: *//g' | awk 'BEGIN { FS = " *\\| *" } { delete wnums; delete nums; matches = 0; } split($1, warr, / */) { for (i in warr) { wnums[warr[i]] } } { split($2, narr, / */); for (i in narr) { nums[narr[i]] } } { for (num in nums) { if (num in wnums) { matches += 1 } }} {if (matches) p1 += 2^(matches - 1)} {repeats[NR] += 1; for (r=1; r<=repeats[NR]; r++) {for (m=1; m<=matches; m++) {repeats[NR+m] += 1;}}} END { print "part 1: " p1; for (i in repeats) { p2 += repeats[i]} print "part 2: " p2; }'
