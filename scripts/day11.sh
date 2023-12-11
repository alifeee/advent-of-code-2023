#!/bin/bash

# https://adventofcode.com/2023/day/11

cat $1 | awk 'NR == 1 {
    split($0, arr, "");
    for (col=1; col<=length(arr); col++) {
        colworth[col] = 2;
    }
} {
    row = NR;
    split($0, arr, "");
    rowworth[row] = 2;
    for (col=1; col<=length(arr); col++) {
        if (arr[col] == "#") {
            # printf " galaxy at rc %s,%s\n", row, col
            galaxies[row";"col] = 1;
            rowworth[row] = 1;
            colworth[col] = 1;
        }
    }
} END {
    # for (r in rowworth) {
    #     printf "row %s worth %s\n", r, rowworth[r];
    # }

    delete galaxylist;
    i = 1;
    for (gloc in galaxies) {
        galaxylist[i] = gloc;
        i += 1;
    }
    
    p1sum = 0;
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
            for (row=g1row; row!=g2row; row += rowdir) {
                rowdiff += rowworth[row];
            }

            if (g1col > g2col) {
                coldir = -1
            } else if (g1col < g2col) {
                coldir = +1
            }
            coldiff = 0;
            for (col=g1col; col!=g2col; col += coldir) {
                coldiff += colworth[col];
            }

            if (debug) print " row diff: " rowdiff;
            if (debug) print " col diff: " coldiff;
            p1sum += rowdiff + coldiff;
        }
    }

    print "part 1: " p1sum;
}'
