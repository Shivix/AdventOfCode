use std::collections::HashSet;

fn parse(input: &str) -> Vec<Vec<i16>> {
    input
        .lines()
        .map(|line| {
            line.chars().map(|char| char.to_digit(10).unwrap() as i16 ).collect()
        })
        .collect()
}

fn find_path(map: &Vec<Vec<i16>>, peaks_reached: &mut HashSet<(i32, i32)>, x: i32, y: i32, height: i16, part2: bool) -> i32 {
    let mut score = 0;
    let directions = [
        (0, 1),
        (1, 0),
        (0, -1),
        (-1, 0),
    ];

    for dir in directions {
        let next_x = x + dir.0;
        let next_y = y + dir.1;
        if next_x < 0 || next_x >= map.len() as i32 {
            continue;
        }
        // Assume consistent length rows.
        if next_y < 0 || next_y >= map[0].len() as i32 {
            continue;
        }
        let next_height = height + 1;
        if map[next_x as usize][next_y as usize] == next_height {
            if next_height == 9 && !peaks_reached.contains(&(next_x, next_y)) {
                score += 1;
                if !part2 {
                    peaks_reached.insert((next_x, next_y));
                }
                continue;
            }
            score += find_path(map, peaks_reached, next_x, next_y, next_height, part2);
        }
    }
    score
}

fn score_trailheads(map: &Vec<Vec<i16>>, part2: bool) -> i32 {
    let mut score = 0;

    for (x, row) in map.iter().enumerate() {
        for (y, trailhead) in row.iter().enumerate() {
            if *trailhead != 0 {
                continue;
            }
            let mut peaks_reached = HashSet::<(i32, i32)>::new();
            score += find_path(map, &mut peaks_reached, x as i32, y as i32, 0, part2);
        }
    }

    score
}

fn main() {
    let map = parse(include_str!("input"));

    let score = score_trailheads(&map, false);
    println!("Part1: {}", score);
    assert!(score == 754);

    let score = score_trailheads(&map, true);
    println!("Part2: {}", score);
    assert!(score == 1609);
    // loop through each trail head (0)
    // Check each direction
    // if is == 1 higher than current, repeat search there
    // When we get to a 9 stop and add 9 pos to HashSet (to ensure we don't count multiple routes
    // to same 9 for the same trail head) (Clear HashSet after each trailhead)
    // Recursive func good here? search(current_x, current_y) sorta thing.
}

#[test]
fn test() {
let input = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732";

    let map = parse(input);

    assert_eq!(map[0][0], 8);
    assert_eq!(map[0][7], 3);
    assert_eq!(map[5][5], 0);
    assert_eq!(map[7][7], 2);

    let mut test_peaks = HashSet::<(i32, i32)>::new();
    assert_eq!(find_path(&map, &mut test_peaks, 0, 2, 0, false), 5);
    test_peaks.clear();
    assert_eq!(find_path(&map, &mut test_peaks, 0, 4, 0, false), 6);
    test_peaks.clear();
    assert_eq!(find_path(&map, &mut test_peaks, 2, 4, 0, false), 5);
    test_peaks.clear();
    assert_eq!(find_path(&map, &mut test_peaks, 4, 6, 0, false), 3);

    let score = score_trailheads(&map, false);
    assert_eq!(score, 36);

    test_peaks.clear();
    assert_eq!(find_path(&map, &mut test_peaks, 0, 2, 0, true), 20);

    let score = score_trailheads(&map, true);
    assert_eq!(score, 81);
}
