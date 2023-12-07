#!/bin/bash

# https://adventofcode.com/2023/day/7

cat $1 | awk -F' ' 'BEGIN {debug = 0}{
    if (debug) print "> " $0;
} {
    highesthand = $1;
    highesthandval = 0;
    othercards = "23456789TQJKA"
    split(othercards, joker_replacements, "");
    for (r=1; r<=length(joker_replacements); r++) {
        repl = joker_replacements[r];
        tryhand = gensub(/J/, repl, "g", $1);
        if (debug) print tryhand;
        
        delete cards;
        split(tryhand, chars, "");
        for (i=1; i<=length($1); i++) {
            if (chars[i] in cards) {
                cards[chars[i]] += 1;
            } else {
                cards[chars[i]] = 1;
            }
        }
        pairs = 0;
        triplets = 0;
        quads = 0;
        quints = 0;
        for (card in cards) {
            if (cards[card] >= 5) {
                quints += 1;
            } else if (cards[card] >= 4) {
                quads += 1;
            } else if (cards[card] >= 3) {
                triplets += 1;
            } else if (cards[card] >= 2) {
                pairs += 1;
            }
        }
        # print " p" pairs " t" triplets " q" quads " q" quints;
        if (quints > 0) {
            if (debug) print "quints!"
            currenthandval = 6;
        } else if (quads > 0) {
            if (debug) print "quads!"
            currenthandval = 5;
        } else if (triplets > 0 && pairs > 0) {
            if (debug) print "full house!"
            currenthandval = 4;
        } else if (triplets > 0) {
            if (debug) print "three of a kind!"
            currenthandval = 3;
        } else if (pairs > 1) {
            if (debug) print "two pair!"
            currenthandval = 2;
        } else if (pairs > 0) {
            if (debug) print "pair!"
            currenthandval = 1;
        } else {
            if (debug) print "high card :/"
            currenthandval = 0;
        }

        if (repl == "J") {
            realhandval = currenthandval;
        }

        highesthandval = currenthandval > highesthandval ? currenthandval : highesthandval;
    }
    if (debug) print " highest hand:" highesthand " with " highesthandval;
} {
    print realhandval " " highesthandval " " $1 " " $2;
}' | tee >(awk -F' ' '{
    hand = gensub(/(.)/, "_\\0", "g", $3);
    gsub(/T/, "a", hand);
    gsub(/J/, "b", hand);
    gsub(/Q/, "c", hand);
    gsub(/K/, "d", hand);
    gsub(/A/, "e", hand);
    print $1 hand " " $2 hand " " $3 " " $4;
}' | sort | awk -F' ' '{ sum += NR * $4 } END { print "part 1 " sum }' > /dev/tty) | awk -F' ' '{
    hand = gensub(/(.)/, "_\\0", "g", $3);
    gsub(/T/, "a", hand);
    gsub(/J/, "1", hand);
    gsub(/Q/, "c", hand);
    gsub(/K/, "d", hand);
    gsub(/A/, "e", hand);
    print $1 hand " " $2 hand " " $3 " " $4;
}' | sort -k2 | awk -F' ' '{ sum += NR * $4 } END { print "part 2 " sum }'
