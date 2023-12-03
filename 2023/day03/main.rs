use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn is_symbol(c: char) -> bool {
    !c.is_digit(10) && c != '.'
}

const WIDTH: usize = 140;

fn make_adjacent_positions(i: usize) -> [usize; 8] {
    [
        i - 1,
        i - WIDTH - 1,
        i - WIDTH,
        i - WIDTH + 1,
        i + 1,
        i + WIDTH - 1,
        i + WIDTH,
        i + WIDTH + 1,
    ]
}

fn main() {
    let regex = Regex::new(r"[0-9]+").unwrap();
    // Create map of parts where key is position in the schematic and value is the part id.
    let part_ref = include_str!("input").lines().enumerate().fold(
        HashMap::<usize, i32>::new(),
        |mut acc, (line_n, line)| {
            for capture in regex.find_iter(line) {
                for i in capture.start()..capture.end() {
                    acc.insert(line_n * WIDTH + i, capture.as_str().parse::<i32>().unwrap());
                }
            }
            acc
        },
    );

    // Now when checking adjacent positions to symbols we can see if a part is there by searching
    // the map.
    let mut parts_counted = HashSet::<i32>::new();
    let (part1, part2) = include_str!("input")
        .lines()
        .flat_map(|line| line.chars())
        .enumerate()
        .fold((0, 0), |(mut acc1, mut acc2), (i, char)| {
            if !is_symbol(char) {
                return (acc1, acc2);
            }
            let mut first_part = 0;
            for pos in make_adjacent_positions(i).iter() {
                if part_ref.contains_key(pos) {
                    let part = part_ref[pos];
                    // N.B. No part numbers have more than one adjacent symbol
                    if parts_counted.insert(part) {
                        acc1 += part;
                    }
                    // part2
                    if char == '*' {
                        let part = part_ref[pos];
                        if first_part != 0 && part != first_part {
                            acc2 += first_part * part;
                        }
                        first_part = part;
                    }
                }
            }
            parts_counted.clear();
            (acc1, acc2)
        });
    println!("part1: {}, part2: {}", part1, part2);
    assert!(part1 == 536576 && part2 == 75741499);
}
