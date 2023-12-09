#!/bin/bash

# https://adventofcode.com/2023/day/9

cat $1 | awk -F' ' 'BEGIN { debug=0 } {
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

    # add another column to end of tree
    for (row=0; row<=ROWS; row++) {
        if (debug) print " row " row;

        # new right column
        rightcol = COLUMNS - (ROWS - row) + 2;

        a_r_cm2 = tree[row";"(rightcol-2)];
        a_rm1_cm1 = tree[(row-1)";"(rightcol-1)];
        nextval = a_r_cm2 + a_rm1_cm1;

        if (debug) printf "  a(%s,%s) = a(%s,%s) - a(%s,%s)\n", row, rightcol, row, rightcol-2, row-1, rightcol-1;
        if (debug) printf "  %s = %s + %s\n", nextval, a_r_cm2, a_rm1_cm1;

        tree[row";"rightcol] = nextval;

        # new left column
        leftcol = ROWS - row - 1;

        a_r_c2 = tree[row";"(leftcol+2)];
        a_rm1_c1 = tree[(row-1)";"(leftcol+1)];
        nextval = a_r_c2 - a_rm1_c1;

        if (debug) printf "  a(%s,%s) = a(%s,%s) - a(%s,%s)\n", row, leftcol, row, leftcol+2, row-1, leftcol+1;
        if (debug) printf "  %s = %s - %s\n", nextval, a_r_c2, a_rm1_c1;

        tree[row";"leftcol] = nextval;
    }

    # get top column final value
    rightmost = tree[ROWS";"(COLUMNS+2)];
    if (debug) print " next val! -> " rightmost;

    # get top column (first-1)th value
    leftmost = tree[ROWS";""-1"];
    if (debug) print " next val! -> " leftmost;

    p1sum += rightmost;
    p2sum += leftmost;
} END {
    print "part 1: " p1sum;
    print "part 2: " p2sum;
}'
