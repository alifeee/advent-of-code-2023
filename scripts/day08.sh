#!/bin/bash

# https://adventofcode.com/2023/day/8

cat $1 | awk ' /^$/ { print } /./ { printf "%s;", $0 }' | tee >(awk -F';' 'BEGIN {
    debug = 0;
} NR == 1 {
    split($1, directions, "");
} NR == 2 {
    next
    # generate map 
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
}' > /dev/tty) | awk -F';' 'BEGIN {
    debug = 0;
} NR == 1 {
    split($1, directions, "");
} NR == 2 {
    delete map;
    for (line=1; line < NF; line++) {
        from = substr($line, 0, 3);
        left = substr($line, 8, 3);
        right = substr($line, 13, 3);
        map[from "L"] = left;
        map[from "R"] = right;
    }

    # for (m in map) {
    #     printf "map[%s] = %s\n", m, map[m];
    # }
    
    acc = 0;
    direcindex = 0;
    patsplit($0, nextlocs, /(..A) = /);
    print "nextlocs"
    for (l in nextlocs) {
        nextlocs[l] = substr(nextlocs[l], 0, 3);
        print " " nextlocs[l];
    }

    print "loop"
    while (1) {
        hasz = 1;
        for (l in nextlocs) {
            hasz = hasz && (substr(nextlocs[l], 3) == "Z");
        }
        if (hasz) {
            next;
        }

        acc += 1;
        if (debug) print acc;
        direcindex += 1;
        if (direcindex > length(directions)) direcindex -= length(directions);

        direction = directions[direcindex];
        
        for (l in nextlocs) {
            # print nextlocs[l] direction;
            nextlocs[l] = map[nextlocs[l] direction]
        }

        if (acc % 1000000 == 0) {
            printf "\r%s", acc;
        }
    }
} END {
    print "part 2: " acc;
}'
