#!/bin/bash

# https://adventofcode.com/2023/day/2

REDS="${REDS:=12}"
GREENS="${GREENS:=13}"
BLUES="${BLUES:=14}"

# cat $1 | awk -F'[:;]' 'BEGIN { maxreds="'"$REDS"'"; maxgreens="'"$GREENS"'"; maxblues="'"$BLUES"'" } { print "> " $0 } { print $1 } match($1,/[0-9]+/) { game = substr($1,RSTART, RLENGTH) } { print game } '

cat $1 | awk -F'[:;]' 'match($1,/[0-9]+/) {
    game = substr($1,RSTART, RLENGTH)
} {
    maxred = 0; maxgreen = 0; maxblue = 0;
    for(i=2;i<=NF;i++) {
        reds = match($i, /([0-9]+) red/, arr);
        if (reds != 0 && maxred<arr[1]) maxred = arr[1];
        greens = match($i, /([0-9]+) green/, arr);
        if (greens != 0 && maxgreen<arr[1]) maxgreen = arr[1];
        blues = match($i, /([0-9]+) blue/, arr);
        if (blues != 0 && maxblue<arr[1]) maxblue= arr[1];
    }
} {
    print game "," maxred "," maxgreen "," maxblue;
}' | awk -F',' 'BEGIN { maxreds='"$REDS"'; maxgreens='"$GREENS"'; maxblues='"$BLUES"' } { if ( ($2 <= maxreds) && ($3 <= maxgreens) && ($4 <= maxblues) ) sum += $1 } END { print sum }'
