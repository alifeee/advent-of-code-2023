#!/bin/bash

# https://adventofcode.com/2023/day/8

cat $1 | awk ' /^$/ { print } /./ { printf "%s;", $0 }' | awk -F';' 'NR == 1 {
    split($1, directions, "");
} NR == 2 {
    nextloc = "AAA";
    acc = 0;
    direcindex = 0;
    while (1) {
        if (nextloc == "ZZZ") {
            break
        }
        acc += 1;
        direcindex += 1;
        # if (acc > 100) {
        #     break;
        # }
        if (direcindex > length(directions)) {
            direcindex -= length(directions);
        }

        regex = "("nextloc") = \\(([A-Z]{3}), ([A-Z]{3})\\)"
        match($0, regex, AAA);
        
        all = AAA[0];
        current = AAA[1];
        left = AAA[2];
        right = AAA[3];
        
        direction = directions[direcindex];
        if (debug) printf "%s = (%s, %s) - %s - next: %s\n", current, left, right, acc, direction;

        if (direction == "L") {
            nextloc = left;
        } else if (direction == "R") {
            nextloc = right;
        }

        if (debug) print " choosing " nextloc;
    }
    print "part 1: " acc;
}'
