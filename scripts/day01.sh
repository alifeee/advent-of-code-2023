#!/bin/bash

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

# part 2 workspace

# cat $1 | sed s/one/1/g | sed s/two/2/g | sed s/three/3/g | sed s/four/4/g | sed s/five/5/g | sed s/six/6/g | sed s/seven/7/g | sed s/eight/8/g | sed s/nine/9/g

# cat $1 | sed -E 's/(zero|one|two|three|four|five|six|seven|eight|nine)/__\1__/g'

# cat $1 | awk '{ print gensub(/(zero|one|two|three|four|five|six|seven|eight|nine)/, "__\\1__", "g", $0) }'

# cat $1 | sed -E 's/(zero|one|two|three|four|five|six|seven|eight|nine)/_\1_/g' | sed s/_one_/1/g | sed s/_two_/2/g | sed s/_three_/3/g | sed s/_four_/4/g | sed s/_five_/5/g | sed s/_six_/6/g | sed s/_seven_/7/g | sed s/_eight_/8/g | sed s/_nine_/9/g | awk 'match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } {sum += calib} END { print sum }'

# cat $1 | awk '{ print } match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } { print calib } {sum += calib} END { print sum }'

# I couldn't figure out how to get the "last match" for a string with regex in awk, so instead we have this horrible "reversing and unreversing" the line.

cat $1 | tee >(awk 'match($0,/^[^0-9]*?[0-9]/) { n1 = substr($0,RSTART + RLENGTH - 1, 1) } match($0,/[0-9][^0-9]*?$/) { n2 = substr($0,RSTART,1) } { calib = (n1 n2) } {sum += calib} END { print "part 1: " sum }' > /dev/tty) | awk 'BEGIN { map["zero"]=0; map["one"] = 1; map["two"]=2; map["three"]=3; map["four"]=4; map["five"]=5; map["six"]=6; map["seven"]=7; map["eight"]=8; map["nine"]=9 } match($0,/([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/) { n1 = substr($0, RSTART, RLENGTH) } { for(i=length;i!=0;i--) rev=(rev substr($0,i,1))} match(rev,/([0-9]|orez|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/) { n2rev = substr(rev, RSTART, RLENGTH) } { for(i=length;i!=0;i--) n2=(n2 substr(n2rev,i,1))} { if (length(n1) > 1) { n1num = map[n1] } else { n1num = n1 } } { if (length(n2) > 1) { n2num = map[n2] } else { n2num = n2 } } { calib = n1num n2num } { sum += calib } { rev=""; n2="" } END { print "part 2: " sum }'

# below (bottom) is a solution in Perl (which allows regex lookaheads/lookbehinds)

# cat $1 | awk 'BEGIN { map["zero"]=0; map["one"] = 1; map["two"]=2; map["three"]=3; map["four"]=4; map["five"]=5; map["six"]=6; map["seven"]=7; map["eight"]=8; map["nine"]=9 } match($0,/([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/) { n1 = substr($0, RSTART, RLENGTH) } match($0,/([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)(?!.*([0-9]|zero|one|two|three|four|five|six|seven|eight|nine))/) { n2 = substr($0, RSTART, RLENGTH) } { print n2 }'

# cat $1 | perl -ne 'my %map = (zero=>0, one=>1, two=>2, three=>3, four=>4, five=>5, six=>6, seven=>7, eight=>8, nine=>9, 0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, 9=>9); print ; $_ =~ /([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/; $first = $1; $_ =~ /([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)(?!.*([0-9]|zero|one|two|three|four|five|six|seven|eight|nine))/; $last = $1; $calib = "$map{$first}$map{$last}"; print $calib ;$sum += $calib; print "\n"; END {print $sum}'

# cat $1 | perl -ne 'my %map = (zero=>0, one=>1, two=>2, three=>3, four=>4, five=>5, six=>6, seven=>7, eight=>8, nine=>9, 0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, 9=>9); $line = $_; $_ =~ /([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/; $first = $1; while ($_ =~ /((?=[0-9]|zero|one|two|three|four|five|six|seven|eight|nine))/g) { $lastonwards = substr $line, pos $_ }; $lastonwards =~ /([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)/; $last = $1; $calib = "$map{$first}$map{$last}";$sum += $calib; END {print $sum; print "\n"}'

# cat $1 | perl -ne 'my $regex = "[0-9]|zero|one|two|three|four|five|six|seven|eight|nine"; my %map = (zero=>0, one=>1, two=>2, three=>3, four=>4, five=>5, six=>6, seven=>7, eight=>8, nine=>9, 0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, 9=>9); $line = $_; $_ =~ /(($regex))/; $first = $1; while ($_ =~ /((?=$regex))/g) { $lastonwards = substr $line, pos $_ }; $lastonwards =~ /(($regex))/; $last = $1; $calib = "$map{$first}$map{$last}"; $sum += $calib; END {print $sum; print "\n"}'
