#!/bin/bash

# https://adventofcode.com/2023/day/8

cat $1 | awk ' /^$/ { print } /./ { printf "%s;", $0 }' | awk -F';' 'BEGIN {
    debug = 0;
} NR == 1 {
    split($1, directions, "");
} NR == 2 {
    patsplit($0, nextlocs, /(..A) = \(([A-Z]{3}), ([A-Z]{3})\)/);
    for (l in nextlocs) {
        nextlocs[l] = substr(nextlocs[l], 0, 3);
    }

    for (line=1; line <= NF; line++) {
        from = substr($line, 0, 3);
        left = substr($line, 8, 3);
        right = substr($line, 13, 3);
        map[from "L"] = left;
        map[from "R"] = right;
    }
    
    acc = 0;
    direcindex = 0;
    nextloc = "AAA"

    while (1) {
        if (nextloc == "ZZZ") {
            next
        }
        acc += 1;
        direcindex += 1;
        if (direcindex > length(directions)) direcindex -= length(directions);

        direction = directions[direcindex];
        nextloc = map[nextloc direction]
    }
} END {
    print "part 1: " acc;
}'
