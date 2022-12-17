use std::cmp::{max, min};

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let part = aoclib::parse_args(args);
    let mut cave = [['.'; 200]; 800];
    cave[500][0] = '+';
    let mut highest_y = 0;
    include_str!("input").lines().for_each(|line| {
        let mut prev_x = 0;
        let mut prev_y = 0;
        line.split(" -> ").for_each(|formation| {
            let (x, y) = formation.split_once(',').unwrap();
            let x = x.parse::<usize>().unwrap();
            let y = y.parse::<usize>().unwrap();
            if y > highest_y {
                highest_y = y;
            }
            if prev_x == 0 && prev_y == 0 {
                prev_x = x;
                prev_y = y;
            }
            #[allow(clippy::needless_range_loop)]
            for i in min(x, prev_x)..=max(x, prev_x) {
                cave[i][y] = '#'
            }
            for i in min(y, prev_y)..=max(y, prev_y) {
                cave[x][i] = '#'
            }
            prev_x = x;
            prev_y = y;
        })
    });

    if part == Some(2) {
        // Add cave floor for part 2
        for i in &mut cave {
            i[highest_y + 2] = 'x';
        }
    }

    let mut result = 0;
    'main: loop {
        let mut x = 500;
        let mut y = 0;
        result += 1;
        loop {
            if x >= cave.len() - 1 || y >= cave[0].len() - 1 {
                break 'main;
            }
            y += 1;
            if cave[x][y] == '.' {
                // can move below
            } else if cave[x - 1][y] == '.' {
                // can move diagonally
                x -= 1;
            } else if cave[x + 1][y] == '.' {
                // can move diagonally
                x += 1;
            } else {
                // all ways blocked so place sand here
                if y == 1 {
                    break 'main;
                }
                cave[x][y - 1] = 'O';
                break;
            }
        }
    }

    println!("part1: {}", result);
}
