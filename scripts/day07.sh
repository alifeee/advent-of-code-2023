#!/bin/bash

# https://adventofcode.com/2023/day/7

cat $1 | awk -F' ' '{
    if (debug) print "> " $0;
} {
    delete cards;
    split($1, chars, "");
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
        hand_value = 6;
    } else if (quads > 0) {
        if (debug) print "quads!"
        hand_value = 5;
    } else if (triplets > 0 && pairs > 0) {
        if (debug) print "full house!"
        hand_value = 4;
    } else if (triplets > 0) {
        if (debug) print "three of a kind!"
        hand_value = 3;
    } else if (pairs > 1) {
        if (debug) print "two pair!"
        hand_value = 2;
    } else if (pairs > 0) {
        if (debug) print "pair!"
        hand_value = 1;
    } else {
        if (debug) print "high card :/"
        hand_value = 0;
    }

    hand = gensub(/(.)/, "_\\1", "g", $1);
    gsub(/T/, "a", hand);
    gsub(/J/, "b", hand);
    gsub(/Q/, "c", hand);
    gsub(/K/, "d", hand);
    gsub(/A/, "e", hand);
} {
    print hand_value hand " " $1 " " $2;
}' | sort | awk -F' ' '{sum += NR * $3} END {print sum}' 
