"""advent of code day 12"""

# 2 spare (+3 each)
# __ + x_xx_xxx

# 1 space (+2 each)
# _ + x_xx__xxx
# _ + x__xx_xxx

# 0 space (+1 each)
# + x__xx__xxx
# + x___xx_xxx
# + x_xx___xxx

# ADD TO 4 (2 + 1 + 1)
# choice[1;1] = x_xx_xxx
# choice[1;2] = x_xx__xxx
# choice[1;3] = x_xx___xxx
# choice[2;1] = x__xx_xxx
# choice[2;2] = x__xx__xxx
# choice[3;1] = x___xx_xxx

# ADD TO 5 (3 + 1 + 1)
# 1;1
# 1;2
# 1;3
# 1;4
# 2;1
# 2;2
# 2;3
# 3;1
# 3;2
# 4;1

# ADD 3 to 6 (3 + 1 + 1 + 1)
# 1;1;1
# 1;1;2
# 1;1;3
# 1;1;4
# 2;1;1
# 2;1;2
# 2;1;3
# 2;2;1
# 2;2;2
# 3;1;1
# 3;1;2
# 3;2;1

# 1,2,3 -> N  = 8
# N = sum(nums) + num(nums)
# p(n) =
#   sum from k=1 to (n-N+1) of
#     sum from i=1 to k of i

# p(8) = 1
# p(9) = 4
# p(10) = 10

# f(n) = sum from
# x_xx_xxx__
# x_xx__xxx_
# x_xx___xxx
# x__xx_xxx_
# x__xx__xxx
# x___xx_xxx
# _x_xx_xxx_
# _x_xx__xxx
# _x__xx_xxx
# __x_xx_xxx

# .??..??...?##. 1,1,3 ->
#   SEQ = {sep 1} {2 mys} {2 sep} {2 mys} {3 sep} {1 mys} {2 spr} {1 sep}
#     == SEQ = S {2 mys} S {2 mys} S {1 mys} {2 spr} S
#     == SEQ = {2 mys} S {2 mys} S {1 mys} {2 spr}
#   NUMS = 1, 1, 3

# given SEQ and NUMS, how many PERMUTATIONS

# .??..??...?##. == .??.??.?##.
# .??.??.?##. == ??.??.?##

# N = length(nums)
# for num in nums:
#   N += num

# SEQ = replace "........" -> "."
# SEQ = strip(SEQ, ".")

# NUMS, GAPS = split($0)

# n = full length of $0
# FOR gapindex IN [1,2,...]

#   for sepchoice < totalseps:

from anytree import Node, RenderTree

root = Node("2")

SPARE = 2

for i in range(2):
    for node in root.leaves:
        node.children = [Node("2"), Node("3"), Node("4")]
        SPARE += 3
