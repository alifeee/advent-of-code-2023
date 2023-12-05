"""day 3 in python"""

import sys
import time
from typing import List
import functools
from tqdm import tqdm


class SingleMap:
    """One map of source range to target range"""

    def __init__(
        self,
        destination_range_start: int,
        source_range_start: int,
        range_length: int,
    ):
        self.destination_range_start = destination_range_start
        self.source_range_start = source_range_start
        self.range_length = range_length
        self.src_lower = source_range_start
        self.src_upper = source_range_start + range_length - 1
        self.dst_lower = destination_range_start
        self.dst_upper = destination_range_start + range_length - 1

    def can_map_forwards(self, num: int) -> bool:
        """can map forwards?"""
        if self.src_lower <= num <= self.src_upper:
            return True
        return False

    def can_map_backwards(self, num: int) -> bool:
        """can map backwards?"""
        if self.dst_lower <= num <= self.dst_upper:
            return True
        return False

    def map_forwards(self, num: int) -> int:
        """map a number forwards through the map"""
        if self.src_lower <= num <= self.src_upper:
            return self.dst_lower + (num - self.src_lower)
        return num

    def map_backwards(self, num: int) -> int:
        """map a number backwards through the map"""
        if self.dst_lower <= num <= self.dst_upper:
            return self.src_lower + (num - self.dst_lower)
        return num

    def __repr__(self) -> str:
        return f"[{self.src_lower}, {self.src_upper}] -> [{self.dst_lower}, {self.dst_upper}]"


class MultiMap:
    """Many maps together of source range to target range"""

    def __init__(self, singlemaps: List[SingleMap]):
        self.singlemaps = singlemaps

    def map_forwards(self, num: int) -> int:
        """map a number forwards through all child maps"""
        for singlemap in self.singlemaps:
            if singlemap.can_map_forwards(num):
                return singlemap.map_forwards(num)
        return num

    def map_backwards(self, num: int) -> int:
        """map a number backwards through all child maps"""
        for singlemap in self.singlemaps:
            if singlemap.can_map_backwards(num):
                return singlemap.map_backwards(num)
        return num

    def __repr__(self) -> str:
        return "[" + ", ".join([m.__repr__() for m in self.singlemaps]) + "]"


class Pipeline:
    """Many multimaps together form a pipeline"""

    def __init__(self, multimaps: List[MultiMap]):
        self.multimaps = multimaps

    def pipe_forwards(self, num: int) -> int:
        """pipe a number through each of my maps"""
        return functools.reduce(
            lambda cnum, mmap: mmap.map_forwards(cnum),
            self.multimaps,
            num,
        )

    def pipe_backwards(self, num: int) -> int:
        """pipe a number through each of my maps"""
        return functools.reduce(
            lambda cnum, mmap: mmap.map_backwards(cnum),
            reversed(self.multimaps),
            num,
        )

    def __repr__(self) -> str:
        return "[" + ", ".join([m.__repr__() for m in self.multimaps]) + "]"


class SeedRange:
    """Range of seeds, provided a start and length"""

    def __init__(self, start: int, length: int):
        self.start = start
        self.length = length
        self.end = self.start + self.length - 1

    def is_in_range(self, num: int) -> bool:
        """returns true if num is in seedrange"""
        return self.start <= num <= self.end

    def __repr__(self) -> str:
        return f"{self.start}<<{self.end}"


class SeedBag:
    """Pretend bag of seends. Is just a combination of seedranges"""

    def __init__(self, seedranges: List[SeedRange]):
        self.seedranges = seedranges

    def is_in_bag(self, num: int) -> bool:
        """returns true if num is in any of the seedranges"""
        return any(sr.is_in_range(num) for sr in self.seedranges)

    def __repr__(self) -> str:
        return "[" + ", ".join([m.__repr__() for m in self.seedranges]) + "]"

    def min_seed(self) -> int:
        """get smallest seed in bag"""
        return min(sr.start for sr in self.seedranges)


def test_single_map():
    """test SingleMap class"""
    singlemap = SingleMap(
        destination_range_start=50, source_range_start=98, range_length=2
    )
    assert not singlemap.can_map_forwards(97)
    assert singlemap.can_map_forwards(98)
    assert singlemap.can_map_forwards(99)
    assert not singlemap.can_map_forwards(100)

    assert singlemap.map_forwards(97) == 97
    assert singlemap.map_forwards(98) == 50
    assert singlemap.map_forwards(99) == 51
    assert singlemap.map_forwards(100) == 100

    assert not singlemap.can_map_backwards(97)
    assert singlemap.can_map_backwards(50)
    assert singlemap.can_map_backwards(51)
    assert not singlemap.can_map_backwards(100)

    assert singlemap.map_backwards(97) == 97
    assert singlemap.map_backwards(50) == 98
    assert singlemap.map_backwards(51) == 99
    assert singlemap.map_backwards(100) == 100


def test_multi_map():
    """test MultiMap class"""
    singlemap_1 = SingleMap(
        destination_range_start=50, source_range_start=98, range_length=2
    )
    singlemap_2 = SingleMap(
        destination_range_start=52, source_range_start=50, range_length=48
    )

    multimap = MultiMap(singlemaps=[singlemap_1, singlemap_2])

    assert multimap.map_forwards(0) == 0
    assert multimap.map_forwards(1) == 1
    assert multimap.map_forwards(48) == 48
    assert multimap.map_forwards(49) == 49
    assert multimap.map_forwards(50) == 52
    assert multimap.map_forwards(51) == 53
    assert multimap.map_forwards(96) == 98
    assert multimap.map_forwards(97) == 99
    assert multimap.map_forwards(98) == 50
    assert multimap.map_forwards(99) == 51
    assert multimap.map_forwards(100) == 100

    assert multimap.map_backwards(0) == 0
    assert multimap.map_backwards(1) == 1
    assert multimap.map_backwards(48) == 48
    assert multimap.map_backwards(49) == 49
    assert multimap.map_backwards(52) == 50
    assert multimap.map_backwards(53) == 51
    assert multimap.map_backwards(98) == 96
    assert multimap.map_backwards(99) == 97
    assert multimap.map_backwards(50) == 98
    assert multimap.map_backwards(51) == 99
    assert multimap.map_backwards(100) == 100


def test_seed_range():
    """test seed range class"""
    seedrange = SeedRange(start=79, length=14)

    assert not seedrange.is_in_range(1)
    assert not seedrange.is_in_range(78)
    assert seedrange.is_in_range(79)
    assert seedrange.is_in_range(80)
    assert seedrange.is_in_range(91)
    assert seedrange.is_in_range(92)
    assert not seedrange.is_in_range(93)
    assert not seedrange.is_in_range(100)

    seedrange2 = SeedRange(start=55, length=13)
    seedbag = SeedBag(seedranges=[seedrange, seedrange2])

    assert not seedbag.is_in_bag(1)
    assert not seedbag.is_in_bag(54)
    assert seedbag.is_in_bag(55)
    assert seedbag.is_in_bag(56)
    assert seedbag.is_in_bag(67)
    assert not seedbag.is_in_bag(68)
    assert not seedbag.is_in_bag(69)
    assert not seedbag.is_in_bag(78)
    assert seedbag.is_in_bag(79)
    assert seedbag.is_in_bag(92)
    assert not seedbag.is_in_bag(93)
    assert not seedbag.is_in_bag(100)


def main():
    """main"""
    input_lines = sys.stdin.read().splitlines()

    seed_line = input_lines[0]
    map_lines = input_lines[1:]

    test_single_map()
    test_multi_map()
    test_seed_range()

    multimaps = []
    for map_line in map_lines:
        singlemap_strs = map_line.split(";")
        singlemaps = []
        for singlemap_str in singlemap_strs:
            dst_start, src_start, length = singlemap_str.split(":")
            singlemap = SingleMap(
                destination_range_start=int(dst_start),
                source_range_start=int(src_start),
                range_length=int(length),
            )
            singlemaps.append(singlemap)
        multimaps.append(MultiMap(singlemaps=singlemaps))

    pipeline = Pipeline(multimaps=multimaps)

    # part 1
    seeds = [int(ss) for ss in seed_line.split(" ")]
    part1 = min(pipeline.pipe_forwards(seed) for seed in seeds)
    print(f"part 1: {part1}")

    # part 2
    seed_strs = [int(ss) for ss in seed_line.split(" ")]
    seedranges = []
    seeds = []
    for pairindex in range(len(seed_strs) // 2):
        start = seed_strs[2 * pairindex]
        length = seed_strs[2 * pairindex + 1]
        seedrange = SeedRange(
            start=start,
            length=length,
        )
        seedranges.append(seedrange)

    seedbag = SeedBag(seedranges=seedranges)
    print(f"min seed: {seedbag.min_seed()}")
    print(f"{77896732} in bag? {seedbag.is_in_bag(77896732)}")
    print(f"{77896731} in bag? {seedbag.is_in_bag(77896731)}")
    print(f"seed->loc {77896732} -> {pipeline.pipe_forwards(77896732)}")
    print(f"loc->seed {3846951716} -> {pipeline.pipe_forwards(3846951716)}")

    print()
    print("PIPELINE")
    for multimap in pipeline.multimaps:
        print()
        print("multimap")
        for singlemap in multimap.singlemaps:
            print(singlemap)
    return
    location = 0
    pbar = tqdm(desc="testing locations")
    while True:
        seed = pipeline.pipe_backwards(location)
        # print(f"test loc->seed {location} -> {seed} in seedbag")
        if seedbag.is_in_bag(seed):
            break
        location += 1
        # time.sleep(0.1)
        # if location % 1_000_000 == 0:
        pbar.update(location)

        print(f"seed->loc {location} -> {pipeline.pipe_forwards(location)}")
        time.sleep(1)
    pbar.close()

    print(f"part 2 {location}")


if __name__ == "__main__":
    main()
