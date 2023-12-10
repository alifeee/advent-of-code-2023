#!/bin/bash

# https://adventofcode.com/2023/day/10

cat $1 | awk 'BEGIN { 
    debug = 0;
    delete pipes;
} {
    row = NR;
    split($0, arr, "");
    for (col=1; col<=length(arr); col++) {
        if (arr[col] == "S") {
            srow = row;
            scol = col;
        }
        pipes[row";"col] = arr[col];
    }
} END {
    # print pipes["140;138"];
    aboveS = pipes[(srow-1)";"(scol  )];
    rightS = pipes[(srow  )";"(scol+1)];
    belowS = pipes[(srow+1)";"(scol  )];
    leftS =  pipes[(srow  )";"(scol-1)];

    if (debug) print " " aboveS;
    if (debug) print leftS "S" rightS;
    if (debug) print " " belowS;

    if (match(aboveS, /\||7|F/)) {
        nextrow = srow - 1;
        nextcol = scol;
    } else if (match(rightS, /7|-|J/)) {
        nextrow = srow;
        nextcol = scol + 1;
    } else if (match(belowS, /L|\||J/)) {
        nextrow = srow + 1;
        nextcol = scol;
    }

    currentrow = srow;
    currentcol = scol;
    currentval = "S";
    steps = 0;
    while (1) {
        if (currentrow == nextrow) {
            if (nextcol > currentcol) {direc = "right"}
            else {direc = "left"}
        } else {
            if (nextrow > currentrow) {direc = "down"}
            else {direc = "up"}
        }
        nextval = pipes[nextrow";"nextcol];
        if (debug) printf " exploring %s->%s (r,c) %s from %s,%s %s to %s,%s %s\n", currentval, nextval, direc, currentrow, currentcol, currentval,nextrow, nextcol, nextval;
        if (debug) printf "   %s \n  %s%s%s\n   %s \n", pipes[(currentrow-1)";"(currentcol)], pipes[(currentrow)";"(currentcol-1)], pipes[(currentrow)";"(currentcol)], pipes[(currentrow)";"(currentcol+1)], pipes[(currentrow+1)";"(currentcol)];
        steps += 1
        
        currentrow = nextrow;
        currentcol = nextcol;
        currentval = nextval;

        nextrow = currentrow;
        nextcol = currentcol;
        if (nextval == "F") {
            if (direc == "up") {
                nextcol += 1;
            } else if (direc == "left") {
                nextrow += 1;
            }
        } else if (nextval == "7") {
            if (direc == "up") {
                nextcol -= 1;
            } else if (direc == "right") {
                nextrow += 1;
            }
        } else if (nextval == "J") {
            if (direc == "right") {
                nextrow -= 1;
            } else if (direc == "down") {
                nextcol -= 1;
            }
        } else if (nextval == "L") {
            if (direc == "down") {
                nextcol += 1;
            } else if (direc == "left") {
                nextrow -= 1;
            }
        } else if (nextval == "-") {
            if (direc == "right") {
                nextcol += 1;
            } else if (direc == "left") {
                nextcol -= 1;
            }
        } else if (nextval == "|") {
            if (direc == "down") {
                nextrow += 1;
            } else if (direc == "up") {
                nextrow -= 1;
            }
        }

        if (steps > 0 && nextval == "S") {
            break
        }

        if (nextrow == currentrow && nextcol == currentcol) {
            print "ERR!!! DID NOT COMPUTE"
        }
    }
    if (debug) print "found S again after " steps " steps :)";
    print "part 1: " steps / 2;
}'
