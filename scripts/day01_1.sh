#!/bin/sh

# https://adventofcode.com/2023/day/1 

# cat $1 | awk '{ sum += $1 }; END { print sum }'
# cat $1 | awk '{ print "lll" }; {print}; /[0-9]/ { print }'
# cat $1 | awk '{ sum++ }; END {print sum}'
# cat $1 | sed 'p' | awk '1;1;1;1'

# cat $1 | sed "s+[0-9]+HIIIIIII+"

# cat $1 | awk '{ temp1 = $0 }; { temp2 = $0 }; { num = temp1 temp2 }; { print num }'c
# cat $1 | awk '{ print } { print gensub(/.*([0-9]).*?/, "Here are bees: \\1", "g", $0) }'
# cat $1 | awk '{ print } { i1 = match($0, /^.*?[0-9]/) } { print i1 }'

# cat $1 | sed -E "s/^.*?([0-9])/\\1/g"

# cat $1 | awk '{ print } { print gensub(/.*([0-9]).*?/, "Here are bees: \\1", "g", $0) } { print gensub(/.*?([0-9]).*/, "Here are bees: \\1", "g", $0) }'
# cat $1 | awk '{ print } { i1 = match($0, /[0-9]/) } { print i1 } { i2 = match($0, /[0-9](?!.*[0-9])/) } { print i2 }'
# cat $1 | awk '{ print "line" } { print } { n1 = gensub(/^[^0-9]*?([0-9])/, "\\1", "g", $0) } { n2 = gensub(/([0-9])[^0-9]*?$/, "\\1", "g", $0) } { print (n1 n2) }'

cat $1 | awk 'match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } {sum += calib} END { print sum }'
