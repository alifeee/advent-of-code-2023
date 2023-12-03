#!/bin/bash

# https://adventofcode.com/2023/day/3

cat $1 | awk 'BEGIN {
    debug = 1;
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

    # NUMBERS
    n_nums = patsplit($0, numarr, /[0-9]+/, numseps);
    if (debug) print " " n_nums " nums found"
    acc = 1 + length(numseps[0])
    for (numindex=1; numindex <= n_nums; numindex++) {
        if (debug) print "  num " numarr[numindex];

        # position tracking
        istartat = acc;
        acc += length(numarr[numindex]);
        iendat = acc - 1;
        acc += length(numseps[numindex]);
        if (debug) print "   i start at " istartat
        if (debug) print "   i end at " iendat

        # horizontal adjacency check
        lastchar = substr(numseps[numindex-1], length(numseps[numindex-1]))
        if (debug) print "   lastchar " lastchar
        nextchar = substr(numseps[numindex], 1, 1)
        if (debug) print "   nextchar " nextchar
        if ((lastchar != "." && lastchar != "") || (nextchar != "." && nextchar != "")) {
            print "horizontal match!"
        }

        
    }

    # SYMBOLS
    n_syms = patsplit($0, symarr, /[^\.0-9]+/, symseps);
    if (debug) print " " n_syms " syms found"
    acc = 1 + length(symseps[0])
    for (symindex=1; symindex <= n_syms; symindex++) {
        if (debug) print "  sym " symarr[symindex]

        # position tracking
        istartat = acc - 1;
        acc += length(symarr[symindex]);
        iendat = acc;
        acc += length(symseps[symindex]);
        if (debug) print "   i start at " istartat
        if (debug) print "   i end at " iendat

        nextsymbols[length(nextsymbols)] = symarr[symindex];
        nextsymbols_starts[length(nextsymbols_starts)] = istartat;
        nextsymbols_ends[length(nextsymbols_ends)] = iendat;
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
}'
