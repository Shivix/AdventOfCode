use std::collections::HashSet;

fn parse(input: &str) -> Vec<Vec<char>> {
    input
        .lines()
        .map(|line| line.chars().collect())
        .collect::<Vec<Vec<char>>>()
}

fn get_obstacles_start_pos(input: &[Vec<char>]) -> ((i32, i32), HashSet<(i32, i32)>, (i32, i32)) {
    let mut start_pos = (0, 0);
    let mut obstacles = HashSet::<(i32, i32)>::new();
    for (row, line) in input.iter().enumerate() {
        for (col, char) in line.iter().enumerate() {
            if *char == '^' {
                start_pos = (row as i32, col as i32);
            } else if *char == '#' {
                obstacles.insert((row as i32, col as i32));
            }
        }
    }
    (
        start_pos,
        obstacles,
        (input.len() as i32, input[0].len() as i32),
    )
}

const DIRECTIONS: [(i32, i32); 4] = [(-1, 0), (0, 1), (1, 0), (0, -1)];

fn next_pos(current: (i32, i32), direction: usize) -> (i32, i32) {
    (
        current.0 + DIRECTIONS[direction].0,
        current.1 + DIRECTIONS[direction].1,
    )
}

fn new_direction(direction: usize) -> usize {
    (direction + 1) % DIRECTIONS.len()
}

fn out_of_bounds(pos: (i32, i32), boundaries: (i32, i32)) -> bool {
    pos.0 >= boundaries.0 || pos.0 < 0 || pos.1 >= boundaries.1 || pos.1 < 0
}

fn part1(
    start_pos: (i32, i32),
    obstacles: &HashSet<(i32, i32)>,
    boundaries: (i32, i32),
) -> Vec<(i32, i32)> {
    let mut direction = 0;
    let mut current_pos = start_pos;
    let mut result = Vec::<(i32, i32)>::from([start_pos]);
    loop {
        let next_pos = next_pos(current_pos, direction);
        if obstacles.contains(&next_pos) {
            direction = new_direction(direction);
            continue;
        }
        if out_of_bounds(next_pos, boundaries) {
            break;
        }
        if !result.contains(&next_pos) {
            result.push(next_pos);
        }
        current_pos = next_pos;
    }
    result
}

fn check_loop(
    start_pos: (i32, i32),
    obstacles: &HashSet<(i32, i32)>,
    boundaries: (i32, i32),
) -> bool {
    let mut direction = 0;
    let mut current_pos = start_pos;
    let mut obstacle_hits = Vec::<((i32, i32), usize)>::new();
    loop {
        let next_pos = next_pos(current_pos, direction);
        if obstacles.contains(&next_pos) {
            // If an obstacles is hit from the same direction again we've looped.
            if obstacle_hits.contains(&(next_pos, direction)) {
                return true;
            }
            obstacle_hits.push((next_pos, direction));
            direction = new_direction(direction);
            continue;
        }
        if out_of_bounds(next_pos, boundaries) {
            break;
        }
        current_pos = next_pos;
    }
    false
}

fn main() {
    let input = parse(include_str!("input"));

    let (start_pos, mut obstacles, boundaries) = get_obstacles_start_pos(&input);

    let part1 = part1(
        start_pos,
        &obstacles,
        (input.len() as i32, input[0].len() as i32),
    );

    println!("part1: {}", part1.len());
    assert!(part1.len() == 5145);

    let part2 = part1.iter().fold(0, |acc, pos| {
        if !obstacles.contains(pos) {
            obstacles.insert(*pos);
            let is_loop = check_loop(start_pos, &obstacles, boundaries);
            obstacles.remove(pos);
            if is_loop {
                return acc + 1;
            }
        }
        acc
    });
    println!("part2: {}", part2);
    assert!(part2 == 1523);
}

#[test]
fn test() {
    let input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...";

    let input = parse(input);
    let (start_pos, obstacles, boundaries) = get_obstacles_start_pos(&input);
    let part1 = part1(start_pos, &obstacles, boundaries);
    assert_eq!(part1.len(), 41);
}
