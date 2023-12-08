#!/bin/bash

# https://adventofcode.com/2023/day/8

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

cat $1 | awk ' /^$/ { print } /./ { printf "%s;", $0 }' | tee >(awk -F';' 'BEGIN {
    debug = 0;
} NR == 1 {
    split($1, directions, "");
} NR == 2 {
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
    for (l in nextlocs) {
        nextlocs[l] = substr(nextlocs[l], 0, 3);
    }

    for (l in nextlocs) {
        nextloc = nextlocs[l];
        acc = 0;
        tooktoz = 0;
        while (1) {
            if (substr(nextloc, 3) == "Z") {
                if (!tooktoz) {
                    tooktoz = acc;
                } else break;
            }
            acc += 1;
            direcindex += 1;
            if (direcindex > length(directions)) direcindex -= length(directions);

            direction = directions[direcindex];
            nextloc = map[nextloc direction]
        }
        # print nextlocs[l] " took " tooktoz " to get to Z and then " (acc - tooktoz) " til the next z"
        print tooktoz
    }
}' | python3 "${SCRIPTPATH}/day08.py"
