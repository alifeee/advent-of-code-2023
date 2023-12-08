"""calculate LCM for numbers through stdin"""

import sys
from math import lcm

input_lines = sys.stdin.read().splitlines()

numbers = [int(line) for line in input_lines]

print(f"part 2: {lcm(*numbers)}")
