"""day 3 in python"""

import sys
from typing import List
import functools


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


def main():
    """main"""
    input_lines = sys.stdin.read().splitlines()

    seed_line = input_lines[0]
    map_lines = input_lines[1:]

    # print(map_lines)

    test_single_map()
    test_multi_map()

    seeds = [int(ss) for ss in seed_line.split(" ")]

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

    for seed in seeds:
        print(f"pipe seed->loc   {seed} -> {pipeline.pipe_forwards(seed)}")


if __name__ == "__main__":
    main()
