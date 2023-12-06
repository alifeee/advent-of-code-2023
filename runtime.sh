#!/bin/bash

# replace the progress bar in README.md with the solution for whichever day

DAY=$1
MAXTIME=90
SEGMENTS=20

# { time "./scripts/day${DAY}.sh" "./data/day${DAY}.txt"; } 2>&1 | 

TIME_L=$( TIMEFORMAT="real %R"; { time "./scripts/day${DAY}.sh" "./data/day${DAY}.txt"; } 2>&1 | grep "real" )

TIME=$( echo $TIME_L | sed s'/real //g' )

BAR=$( ./bar.sh $TIME $MAXTIME $SEGMENTS | awk -v t=$TIME '{
    printf "%s %.3f s\n", $0, t;
}')

echo "writing ${BAR} to day ${DAY}..."

sed -i "s/<span id=\"${DAY}\">.*<\/span>/<span id=\"${DAY}\">${BAR}<\/span>/g" "README.md"
