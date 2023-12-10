#!/bin/bash

# https://adventofcode.com/2023/day/10

cat $1 | awk 'BEGIN { 
    debug = 0;
    delete pipes;
    delete loop;
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

    ROWS += 1;
    COLUMNS = length(arr)
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
        above = 1;
    } if (match(rightS, /7|-|J/)) {
        nextrow = srow;
        nextcol = scol + 1;
        right = 1;
    } if (match(belowS, /L|\||J/)) {
        nextrow = srow + 1;
        nextcol = scol;
        below = 1;
    } if (match(leftS, /F|-|L/)) {
        nextrow = srow;
        nextcol = scol - 1;
        left = 1;
    }

    currentrow = srow;
    currentcol = scol;
    currentval = "S";
    steps = 0;
    # follow loop
    while (1) {
        if (debug) print "adding " currentrow";"currentcol " -> " currentval " to loop";
        loop[currentrow";"currentcol] = currentval;
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

    # replace S with pipe segment...
    if (above && right) {
        replaceS = "L";
    } else if (above && below) {
        replaceS = "|";
    } else if (above && left) {
        replaceS = "J";
    } else if (right && below) {
        replaceS = "F";
    } else if (right && left) {
        replaceS = "-";
    } else if (below && left) {
        replaceS = "7"
    }
    loop[srow";"scol] = replaceS;

    insides = 0;
    for (row=1; row<=ROWS; row++) {
        for (col=1; col<=COLUMNS; col++) {
            if ((row";"col) in loop) {
                continue
            }
            parity = 0;
            for (trycol=1; trycol<col; trycol++) {
                # printf "%s ", trycol;
                segment = loop[row";"trycol];
                if (segment == "|") {
                    parity += 1;
                } else if (segment == "L" || segment == "7") {
                    parity += 1/2;
                } else if (segment == "F" || segment == "J") {
                    parity -= 1/2;
                }
            }
            if ((parity % 2) == 0) {
                if (debug) print "even, outside loop";
            } else if ((parity % 2 == 1) || (parity % 2 == -1)) {
                if (debug) print "odd, inside loop";
                insides += 1;
            } else {
                print "problem :/ - parity=" parity;
            }
        }
    }
    print "part 2: " insides;
}'
