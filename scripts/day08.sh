#!/bin/bash

# https://adventofcode.com/2023/day/8

cat $1 | awk ' /^$/ { print } /./ { printf "%s;", $0 }' | tee >(awk -F';' 'NR == 1 {
    split($1, directions, "");
} NR == 2 {
    nextloc = "AAA";
    acc = 0;
    direcindex = 0;
    while (1) {
        break
        if (nextloc == "ZZZ") {
            next
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
} END {
    print "part 1: " acc;
}' > /dev/tty) | awk 'BEGIN {
    debug = 0;
} NR == 1 {
    split($1, directions, "");
} NR == 2 {
    patsplit($0, nextlocs, /(..A) = \(([A-Z]{3}), ([A-Z]{3})\)/);
    for (l in nextlocs) {
        nextlocs[l] = substr(nextlocs[l], 0, 3);
    }
    acc = 0;
    direcindex = 0;
    while (1) {
        if (debug) print acc

        eq = 1;
        for (l in nextlocs) {
            if (!match(nextlocs[l], /..Z/)) {
                eq=0;
                break;
            }
        } if (eq) {
            break;
        }

        acc += 1;
        direcindex += 1;
        if (direcindex > length(directions)) {
            direcindex -= length(directions);
        }

        for (l in nextlocs) {
            regex = "("nextlocs[l]") = \\(([A-Z]{3}), ([A-Z]{3})\\)"
            match($0, regex, AAA);

            all = AAA[0];
            current = AAA[1];
            left = AAA[2];
            right = AAA[3];
            direction = directions[direcindex];

            if (debug) printf "%s = (%s, %s) - next: %s\n", current, left, right, direction;

            direction = directions[direcindex];
            if (direction == "L") {
                nextlocs[l] = left;
            } else if (direction == "R") {
                nextlocs[l] = right
            }
        }

        if (acc % 100 == 0) {
            printf "\r%s", acc;
        }
    }
} END { print "part 2: " acc }'
