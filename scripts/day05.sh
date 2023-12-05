#!/bin/bash

# https://adventofcode.com/2023/day/5

# cat $1 | sed 's/seeds: //g' | sed '2, $s/^.*: *//g' | sed '2, $s/ /:/g' | sed '2, $s/.$/;/g' | awk ' /^$/ { print; } /./ { printf("%s", $0); } ' | awk ' /^$/ { print; } /./ { printf("%s", $0); } '

cat $1 | sed 's/seeds: //g' | sed '2, $s/^.*: *//g' | sed '2, $s/ /:/g' | sed 's/\(.\)$/\1;/g' | awk ' /^$/ { print; } /./ { printf("%s", $0); } ' | awk ' /^$/ { print; } /./ { printf("%s", $0); } ' | sed 's/;$//g' | awk -F';' ' 
NR == 1 {
    print "# seeds"
    print "> " $0;
    two_n_pairs = split($0, pairs, / /);
    i = 1;
    for (p=1; p<=two_n_pairs; p += 2) {
        start = pairs[p];
        range = pairs[p+1];
        end = start + range;
        print " seed descriptor! starts at " start ", range " range ", end " end ", total seeds " (end - start);
        for (seednum=start; seednum < end; seednum += 1) {
            olditems[i] = seednum;
            i++;
        }
    }
    print " total seeds " length(olditems);
    n_items = length(olditems)
}
NR > 1 {
    print "\n> " $0

    printf("olditems: ");
    for (i=1; i<=n_items; i++) {
        printf("%s, ", olditems[i]);
    }
    print "";

    for (i=1; i<=NF; i++) {
        print $i;
        split($i, map, /:/);
        # print " destination range start: " map[1];
        # print " source range start: " map[2];
        # print " range length: " map[3];

        lower_from = map[2];
        upper_from = (map[2] + map[3] - 1);
        lower_to = map[1]
        print " map from [" lower_from "," upper_from "] to [" lower_to "," (map[1] + map[3] - 1) "]"

        for (item in olditems) {
            print "  " olditems[item] " in range?";
            if (olditems[item] >= lower_from && olditems[item] <= upper_from) {
                height = olditems[item] - lower_from;
                print "   yes! height from lower: " height ". new: " lower_to + height;
                newitems[item] = lower_to + height;
            } else print "   no :("
        }
    }

    for (i=1; i<=n_items; i++) {
        if (newitems[i]) {print "  new " newitems[i]}
        else print "  old " olditems[i];
        olditems[i] = newitems[i] ? newitems[i] : olditems[i];
    }
    delete newitems;
} END {
    min = olditems[1];
    for (i=1; i<=n_items; i++) {
        min = (olditems[i] < min) ? olditems[i] : min;
    }
    print "part 1: " min;
}'
