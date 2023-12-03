use std::collections::HashMap;
use std::collections::HashSet;

fn is_symbol(c: char) -> bool {
    c < '.' || c > '9' || c == '/'
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

// Could we regex the lines of the file, get index of capture multiplied + line number * width to
// get pos
fn main() {
    let schematic = include_str!("input").lines().flat_map(|line| line.chars());

    let mut part_ref = HashMap::<usize, i32>::new();
    let mut part_positions = Vec::<usize>::new();
    let mut part_number = String::new();

    schematic.clone().enumerate().for_each(|(pos, character)| {
        if character.is_digit(10) {
            part_number.push(character);
            part_positions.push(pos);
            return;
        }
        for p in part_positions.iter() {
            part_ref.insert(*p, part_number.parse::<i32>().unwrap());
        }
        part_positions.clear();
        part_number.clear();
    });

    let mut part1 = 0;
    let mut part2 = 0;
    let mut parts_counted = HashSet::<i32>::new();
    for (i, char) in schematic.enumerate() {
        // part 1
        if !is_symbol(char) {
            continue;
        }
        let mut first_part = 0;
        for pos in make_adjacent_positions(i).iter() {
            if part_ref.contains_key(pos) {
                let part = part_ref[pos];
                // N.B. No part numbers have more than one adjacent symbol
                if parts_counted.insert(part) {
                    part1 += part;
                }
                // part 2
                if char == '*' {
                    if first_part != 0 && part != first_part {
                        part2 += first_part * part;
                    }
                    first_part = part;
                }
            }
        }
        parts_counted.clear();
    }

    println!("part1: {}, part2: {}", part1, part2);
}
