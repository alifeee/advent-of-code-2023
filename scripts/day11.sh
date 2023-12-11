#!/bin/bash

# https://adventofcode.com/2023/day/11

cat $1 | awk 'NR == 1 {
    split($0, arr, "");
    for (col=1; col<=length(arr); col++) {
        colworth[col] = 2;
        colworth2[col] = 1000000;
    }
} {
    row = NR;
    split($0, arr, "");
    rowworth[row] = 2;
    rowworth2[row] = 1000000;
    for (col=1; col<=length(arr); col++) {
        if (arr[col] == "#") {
            # printf " galaxy at rc %s,%s\n", row, col
            galaxies[row";"col] = 1;
            # part 1
            rowworth[row] = 1;
            colworth[col] = 1;
            # part 2
            rowworth2[row] = 1;
            colworth2[col] = 1;
        }
    }
} END {
    delete galaxylist;
    i = 1;
    for (gloc in galaxies) {
        galaxylist[i] = gloc;
        i += 1;
    }
    
    p1sum = 0;
    p2sum = 0;
    for (g1index=1; g1index<length(galaxylist); g1index++) {
        # if (g1index<420) continue;
        for (g2index=g1index+1; g2index<=length(galaxylist); g2index++) {
            g1loc = galaxylist[g1index]
            g2loc = galaxylist[g2index]
            if (debug) printf "comparing %s with %s\n", g1loc, g2loc;

            split(g1loc, g1arr, ";");
            g1row = g1arr[1]
            g1col = g1arr[2]
            split(g2loc, g2arr, ";");
            g2row = g2arr[1]
            g2col = g2arr[2]

            if (g1row > g2row) {
                rowdir = -1
            } else if (g1row < g2row) {
                rowdir = +1
            }
            rowdiff = 0;
            rowdiff2 = 0;
            for (row=g1row; row!=g2row; row += rowdir) {
                rowdiff += rowworth[row];
                rowdiff2 += rowworth2[row];
            }

            if (g1col > g2col) {
                coldir = -1
            } else if (g1col < g2col) {
                coldir = +1
            }
            coldiff = 0;
            coldiff2 = 0;
            for (col=g1col; col!=g2col; col += coldir) {
                coldiff += colworth[col];
                coldiff2 += colworth2[col];
            }

            if (debug) print " row diff: " rowdiff;
            if (debug) print " col diff: " coldiff;
            p1sum += rowdiff + coldiff;
            p2sum += rowdiff2 + coldiff2;
        }
    }

    print "part 1: " p1sum;
    print "part 2: " p2sum;
}'
