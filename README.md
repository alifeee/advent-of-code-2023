# Advent of Code 2023

My solutions for Advent of Code 2023. The language used may be anything. I started with `sh`. I don't know why. The final files have not been cleaned; there is a lot of commented experimentation (especially in the `sh` files).

<https://adventofcode.com/2023>

## Other people's solutions

| Check out! | These! |
| --- | --- |
| [`jedevc`](https://github.com/jedevc/advent-of-code-2023/) | [`lavigne958`](https://github.com/lavigne958/Adventofcode2023) |

## My solutions

Asides: I am not trying to optimise the length or execution time of my scripts further than "it works in a reasonable amount of time".

| Day | Solution | Chars | Runtime |
| --- | --- | --- | --- |
| [01 - Trebuchet?!] | [bash][01] | █░░░░░░░░░ 930 | <span id="01">░░░░░░░░░░░░░░░░░░░░ 0.030 s</span> |
| [02 - Cube Conundrum] | [bash][02] | █░░░░░░░░░ 828 | <span id="02">░░░░░░░░░░░░░░░░░░░░ 0.020 s</span> |
| [03 - Gear Ratios] | [bash][03] | ██████░░░░ 7,954 | <span id="03">░░░░░░░░░░░░░░░░░░░░ 0.029 s</span> |
| [04 - Scratchcards] | [bash][04] | ░░░░░░░░░░ 467 | <span id="04">░░░░░░░░░░░░░░░░░░░░ 0.025 s</span> |
| [05 - If You Give A Seed A Fertilizer] | [bash][05] + [python][05-py] | ██████████ 2,029 + 11,005 | <span id="05">████████████████████ 88.934 s</span> |
| [06 - Wait For It] | [bash][06] | ░░░░░░░░░░ 474 | <span id="06">███░░░░░░░░░░░░░░░░░ 11.995 s</span> |
| [07 - Camel Cards] | [bash][07] | ██░░░░░░░░ 2804 | <span id="07">░░░░░░░░░░░░░░░░░░░░ 0.098 s</span> |
| [08 - Haunted Wasteland] | [bash][08] + [python][08-py] | ██░░░░░░░ 2092 + 158 | <span id="08">░░░░░░░░░░░░░░░░░░░░ 0.099 s</span> |
| [09 - Mirage Maintenance] | [bash][09] | ██░░░░░░░░ 2300 | <span id="09">░░░░░░░░░░░░░░░░░░░░ 0.168 s</span> |
| [10 - Pipe Maze] | [bash][10] | ████░░░░░░ 5052 | <span id="10">░░░░░░░░░░░░░░░░░░░░ 0.240 s</span> |
| [11 - Cosmic Expansion] | [bash][11] | ██░░░░░░░░ 2242 | <span id="11">░░░░░░░░░░░░░░░░░░░░ 1.696 s</span> |

[01 - Trebuchet?!]: https://adventofcode.com/2023/day/1
[01]: ./scripts/day01.sh
[02 - Cube Conundrum]: https://adventofcode.com/2023/day/2
[02]: ./scripts/day02.sh
[03 - Gear Ratios]: https://adventofcode.com/2023/day/3
[03]: ./scripts/day03.sh
[04 - Scratchcards]: https://adventofcode.com/2023/day/4
[04]: ./scripts/day04.sh
[05 - If You Give A Seed A Fertilizer]: https://adventofcode.com/2023/day/5
[05]: ./scripts/day05.sh
[05-py]: ./scripts/day05.sh
[06 - Wait For It]: https://adventofcode.com/2023/day/6
[06]: ./scripts/day06.sh
[07 - Camel Cards]: https://adventofcode.com/2023/day/7
[07]: ./scripts/day07.sh
[08 - Haunted Wasteland]: https://adventofcode.com/2023/day/8
[08]: ./scripts/day08.sh
[08-py]: ./scripts/day08.py
[09 - Mirage Maintenance]: https://adventofcode.com/2023/day/9
[09]: ./scripts/day09.sh
[10 - Pipe Maze]: https://adventofcode.com/2023/day/10
[10]: ./scripts/day10.sh
[11 - Cosmic Expansion]: https://adventofcode.com/2023/day/11
[11]: ./scripts/day11.sh

## To run

### Bash solutions

Either `cat` the data file into the script file with a pipe, or give the filename as input to the script:

```bash
cat data/day1.txt | ./scripts/day01_1.sh
# or
./scripts/day01_1.sh data/day1.txt
```

### All solutions at once

Up to n

```bash
for i in {01..n}; do echo "day ${i}"; ./scripts/day${i}.sh ./data/day${i}.txt; done
```

## Metrics

### Measure execution time

Use `time`, like so:

```bash
$ time ./scripts/day02_01.sh data/day2.txt
real    0m0.021s
user    0m0.016s
sys     0m0.000s
```

### Send execution time to readme

```bash
$ ./runtime.sh 06

writing ███░░░░░░░░░░░░░░░░░ (11.995 s) to day 06...
```

### Create bar chart

Arguments (described in [file](./bar.sh)) are `PROGRESS`, `TOTAL`, and `NUMBER of SEGMENTS`.

```bash
$ ./bar.sh 7954 13034 10

██████░░░░
```
