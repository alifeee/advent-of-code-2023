#!/bin/bash

# https://adventofcode.com/2023/day/4

cat $1 | sed 's/Card *[0-9]*: *//g' | awk 'BEGIN { FS = " *\\| *" } { print } { delete wnums; delete nums; card = 0; } { split($1, wnumarr, / */); for (i in wnumarr) { wnums[wnumarr[i]] } } { split($2, numarr, / */); for (i in numarr) { nums[numarr[i]] } } { print "wnums" } { for (wnum in wnums) { print wnum } } { print "nums" } { for (num in nums) { print num " " (num in wnums ? "\t*" : ""); if (num in wnums) { card += 1 } }} { print "total wnums " card  " -> " (card ? 2^(card-1) : 0) " pts" } { if (card) total += 2^(card - 1) } {print "tot " total}'