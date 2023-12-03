#!/bin/bash

# https://adventofcode.com/2023/day/3

# psuedocode
# sum = 0
# for each line
#     for each number
#         if the left or right adjacent character is a symbol:
#             add num to sum
#         else if there is a symbol in previous_symbols whose extent overlaps with this numbers extent
#             add num to sum
#         else
#             add num and extent to prevnums, to be used in the next loop
#     for each symbol
#         add symbol to prevsymbols, to be used in the next loop
#         if symbol extent overlaps with a num on previous line (from prevnums):
#             adds num to sum
#             make num 0 (so it is not double counted)
# print sum
        

cat $1 | awk 'BEGIN {
    debug = 1;

    sum = 0;

    # initialise arrays
    delete prevsymbols;
    delete prevsymbols_starts;
    delete prevsymbols_ends;

    delete nextsymbols;
    delete nextsymbols_starts;
    delete nextsymbols_ends;

    delete prevnums;
    delete prevnums_starts;
    delete prevnums_ends;

    delete nextnums;
    delete nextnums_starts;
    delete nextnums_ends;
}
{ 
    print "\n";
    print "> " $0;
} {
    for (i=0; i<length(prevsymbols); i++) {
        if (i==0) print " symbols from previous line";
        print "  " prevsymbols[i] " (" prevsymbols_starts[i] "-" prevsymbols_ends[i] ")";
    }
    for (i=0; i<length(prevnums); i++) {
        if (i==0) print " nums from previous line";
        print "  " prevnums[i] " (" prevnums_starts[i] "-" prevnums_ends[i] ")";
    }

    # NUMBERS
    n_nums = patsplit($0, numarr, /[0-9]+/, numseps);
    if (debug) print " " n_nums " nums found"
    acc = 1 + length(numseps[0])
    for (numindex=1; numindex <= n_nums; numindex++) {

        # position tracking
        istartat = acc;
        acc += length(numarr[numindex]);
        iendat = acc - 1;
        acc += length(numseps[numindex]);
        if (debug) print "  num " numarr[numindex] " [" istartat "-" iendat "]"

        # horizontal adjacency check
        isnexttosymbol = 0;
        lastchar = substr(numseps[numindex-1], length(numseps[numindex-1]))
        nextchar = substr(numseps[numindex], 1, 1)
        if (debug) print "   is lastchar (" lastchar ") or nextchar (" nextchar ") symbolic?"
        if ((lastchar != "." && lastchar != "") || (nextchar != "." && nextchar != "")) {
            if (debug) print "    yes!"
            isnexttosymbol=1;
        } else if (debug)  print "    no"
        if (isnexttosymbol) {
            print "    found symbol, sum = " sum " + " numarr[numindex] " (continuing)"
            sum += numarr[numindex];
            continue;
        }
        
        if (length(prevsymbols) == 0) {
            if (debug) print "   no prev symbols, continuing"
        }
        isnearprevsymbol = 0;
        for (si=0; si<length(prevsymbols); si++) {
            if (debug) print "   is near " prevsymbols[si] " [" prevsymbols_starts[si] "-" prevsymbols_ends[si] "] ?";
            a = istartat;
            b = iendat;
            x = prevsymbols_starts[si];
            y = prevsymbols_ends[si];
            if ((a >= x && a <= y) || (b >= x && b <= y)) {
                if (debug) print "    yes!"
                isnearprevsymbol = 1;
            } else if (debug) print "    no"
        }
        if (isnearprevsymbol) {
            print "   found symbol, sum = " sum " + " numarr[numindex] " (continuing)"
            sum += numarr[numindex];
            continue;
        }

        if (debug) print "   adding number to nextnums"
        nextnums[length(nextnums)] = numarr[numindex];
        nextnums_starts[length(nextnums_starts)] = istartat;
        nextnums_ends[length(nextnums_ends)] = iendat;        
    }

    # SYMBOLS
    n_syms = patsplit($0, symarr, /[^\.0-9]+/, symseps);
    if (debug) print " " n_syms " syms found"
    acc = 1 + length(symseps[0])
    for (symindex=1; symindex <= n_syms; symindex++) {

        # position tracking
        istartat = acc - 1;
        acc += length(symarr[symindex]);
        iendat = acc;
        acc += length(symseps[symindex]);
        if (debug) print "  sym " symarr[symindex] " [" istartat "-" iendat "]"

        nextsymbols[length(nextsymbols)] = symarr[symindex];
        nextsymbols_starts[length(nextsymbols_starts)] = istartat;
        nextsymbols_ends[length(nextsymbols_ends)] = iendat;

        if (length(prevnums) == 0) {
            if (debug) print "   no prev nums, continuing"
        }
        for (ni=0; ni<length(prevnums); ni++) {
            if (debug) print "   is near " prevnums[ni] " [" prevnums_starts[ni] "-" prevnums_ends[ni] "] ?";
            x = istartat;
            y = iendat;
            a = prevnums_starts[ni];
            b = prevnums_ends[ni];
            if ((a >= x && a <= y) || (b >= x && b <= y)) {
                if (debug) print "    yes!";
                print "    found number on prev line, sum = " sum " + " prevnums[ni] ". Setting num to 0.";
                sum += prevnums[ni];
                # nullify num being counted twice
                prevnums[ni] = 0;
            } else if (debug) print "    no"
        }
    }

    # delete PREVIOUS symbols and set up "previous" symbols for next loop
    delete prevsymbols;
    delete prevsymbols_starts;
    delete prevsymbols_ends;
    for (i=0; i<length(nextsymbols); i++) {
        prevsymbols[i] = nextsymbols[i];
        prevsymbols_starts[i] = nextsymbols_starts[i];
        prevsymbols_ends[i] = nextsymbols_ends[i];
    }
    delete nextsymbols;
    delete nextsymbols_starts;
    delete nextsymbols_ends;

    # delete PREVIOUS numbers and set up "previous" numbers for next loop
    delete prevnums;
    delete prevnums_starts;
    delete prevnums_ends;
    for (i=0; i<length(nextnums); i++) {
        prevnums[i] = nextnums[i]
        prevnums_starts[i] = nextnums_starts[i]
        prevnums_ends[i] = nextnums_ends[i]
    }
    delete nextnums;
    delete nextnums_starts;
    delete nextnums_ends;
} END {
    print "\nSUM: " sum;
}'
