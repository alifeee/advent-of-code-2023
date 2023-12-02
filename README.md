# Advent of Code 2023

My solutions for Advent of Code 2023. The language used may be anything. I started with `sh`. I don't know why. The final files have not been cleaned; there is a lot of commented experimentation (especially in the `sh` files).

<https://adventofcode.com/2023>

## Other people's solutions

| Check out! | these! |
| --- | --- |
| [jedevc](https://github.com/jedevc/advent-of-code-2023/) | [lavigne958](https://github.com/lavigne958/Adventofcode2023) |

## To run

### Bash solutions

Either `cat` the data file into the script file with a pipe, or give the filename as input to the script:

```bash
cat data/day1.txt | ./scripts/day01_1.sh
# or
./scripts/day01_1.sh data/day1.txt
```

## Measure execution time

Use `time`, like so:

```bash
$ time ./scripts/day02_01.sh data/day2.txt
real    0m0.021s
user    0m0.016s
sys     0m0.000s
```
