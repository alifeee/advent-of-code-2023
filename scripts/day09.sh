#!/bin/bash

# https://adventofcode.com/2023/day/9

cat $1 | awk -F' ' '{
    COLUMNS = NF * 2 - 1;
    ROWS = NF - 1;
    if (debug) print " COLUMNS: " COLUMNS;
    if (debug) print " Num fields: " NF;

    delete tree;
    for (f=1; f<=NF; f+=1) {
        col = f * 2 - 1;
        row = ROWS;
        if (debug) printf " (%s, %s) - %s\n", row, col, $f;
        tree[row";"col] = $f;
    }

    # generate tree
    for (row=ROWS - 1; row >=0; row--) {
        if (debug) print " row " row;
        firstcol = ROWS - row + 1;
        lastcol = COLUMNS - firstcol + 1;
        for (col=firstcol; col<=lastcol; col+=2) {
            a_r1_c1 = tree[(row+1)";"(col+1)];
            a_r1_cm1 = tree[(row+1)";"(col-1)];

            if (debug) printf "  a(%s,%s) = a(%s,%s) - a(%s,%s)\n", row, col, row+1, col+1, row+1, col-1;
            nextval = a_r1_c1 - a_r1_cm1;
            if (debug) printf "  %s = %s - %s\n", nextval, a_r1_c1, a_r1_cm1;

            tree[row";"col] = nextval
        }
    }

    # add another column to tree
    for (row=0; row<=ROWS; row++) {
        if (debug) print " row " row;
        rightcol = COLUMNS - (ROWS - row) + 2;
        a_r_cm2 = tree[row";"(rightcol-2)];
        a_rm1_cm1 = tree[(row-1)";"(rightcol-1)];
        nextval = a_r_cm2 + a_rm1_cm1;

        if (debug) printf "  a(%s,%s) = a(%s,%s) - a(%s,%s)\n", row, rightcol, row, rightcol-2, row-1, col-1;
        if (debug) printf "  %s = %s + %s\n", nextval, a_r_cm2, a_rm1_cm1;

        tree[row";"rightcol] = nextval;
    }

    # get top column final value
    rightmost = tree[ROWS";"(COLUMNS+2)];
    if (debug) print " next val! -> " tree[ROWS";"(COLUMNS+2)];

    sum += rightmost;
} END {
    print sum;
}'
