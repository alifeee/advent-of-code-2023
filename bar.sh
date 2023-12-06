#!/bin/bash
# make bar chart from $prog, $total, $n_seg as $1 $2 $3

awk -v prog=$1 -v TOTAL=$2 -v TOTSEG=$3 'BEGIN {
    frac = prog / TOTAL;
    segs = frac * TOTSEG;
    segs_int = int(sprintf("%.0f", segs));
    for (s=0; s<segs_int; s++) {
        printf "%s", "█";
    }
    for (s=0; s<(TOTSEG - segs_int); s++) {
        printf "%s", "░";
    }
}'
