#!/bin/bash

# https://adventofcode.com/2023/day/6

cat $1 | tee >(sed 's/[a-zA-Z]*: *//g' | awk -F' *' 'NR==1{for (i=1;i<=NF;i++){times[i]=$i}}NR==2{for (i=1;i<=NF;i++){records[i]=$i}} END {mult=1; for (t in times) {acc = 0; for (s=0;s<=times[t];s++) {speed = s;remaining_time=times[t]-s; dist=speed*remaining_time; if (dist>records[t]){acc+=1;}}; mult*=acc;}print "part 1: " mult;}' > /dev/tty) | sed 's/[^0-9]//g' | tr "\n" ";" | awk -F';' '{for (s=0;s<=$1;s++) {if ((s * ($1 - s)) > $2) {acc += 1}}; print "part 2 " acc;}'
