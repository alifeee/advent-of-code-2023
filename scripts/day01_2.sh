#!/bin/bash

# https://adventofcode.com/2023/day/1

# cat $1 | sed s/one/1/g | sed s/two/2/g | sed s/three/3/g | sed s/four/4/g | sed s/five/5/g | sed s/six/6/g | sed s/seven/7/g | sed s/eight/8/g | sed s/nine/9/g

# cat $1 | sed -E 's/(zero|one|two|three|four|five|six|seven|eight|nine)/__\1__/g'

# cat $1 | awk '{ print gensub(/(zero|one|two|three|four|five|six|seven|eight|nine)/, "__\\1__", "g", $0) }'

# cat $1 | sed -E 's/(zero|one|two|three|four|five|six|seven|eight|nine)/_\1_/g' | sed s/_one_/1/g | sed s/_two_/2/g | sed s/_three_/3/g | sed s/_four_/4/g | sed s/_five_/5/g | sed s/_six_/6/g | sed s/_seven_/7/g | sed s/_eight_/8/g | sed s/_nine_/9/g | awk 'match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } {sum += calib} END { print sum }'

# cat $1 | awk '{ print } match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } { print calib } {sum += calib} END { print sum }'

# I couldn't figure out how to get the "last match" for a string with regex in awk, so instead we have this horrible "reversing and unreversing" the line.

cat $1 | awk 'BEGIN { map["zero"]=0; map["one"] = 1; map["two"]=2; map["three"]=3; map["four"]=4; map["five"]=5; map["six"]=6; map["seven"]=7; map["eight"]=8; map["nine"]=9 } match($0,/([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/) { n1 = substr($0, RSTART, RLENGTH) } { for(i=length;i!=0;i--) rev=(rev substr($0,i,1))} match(rev,/([0-9]|orez|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/) { n2rev = substr(rev, RSTART, RLENGTH) } { for(i=length;i!=0;i--) n2=(n2 substr(n2rev,i,1))} { if (length(n1) > 1) { n1num = map[n1] } else { n1num = n1 } } { if (length(n2) > 1) { n2num = map[n2] } else { n2num = n2 } } { calib = n1num n2num } { sum += calib } { rev=""; n2="" } END { print sum }'
