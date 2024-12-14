use std::collections::HashSet;

type Pos = (i32, i32);

#[derive(Debug, PartialEq)]
struct Antennae {
    frequency: char,
    pos: Pos,
}

fn parse(input: &str) -> (Vec<Antennae>, (i32, i32)) {
    let grid: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();

    let mut antennaes = Vec::<Antennae>::new();
    for (i, row) in grid.iter().enumerate() {
        for (j, col) in row.iter().enumerate() {
            if *col != '.' {
                antennaes.push(Antennae {
                    frequency: *col,
                    pos: (i as i32, j as i32),
                })
            }
        }
    }
    (antennaes, (grid.len() as i32, grid[0].len() as i32))
}

fn count_unique_antinodes(antennae: &Vec<Antennae>, row_max: i32, col_max: i32) -> usize {
    let mut antinodes = HashSet::new();

    for (i, a1) in antennae.iter().enumerate() {
        for a2 in antennae.iter().skip(i + 1) {
            if a1.frequency != a2.frequency {
                continue;
            }

            let row_diff = a2.pos.0 - a1.pos.0;
            let col_diff = a2.pos.1 - a1.pos.1;
            let candidates = [
                (a1.pos.0 - row_diff, a1.pos.1 - col_diff),
                (a2.pos.0 + row_diff, a2.pos.1 + col_diff),
            ];

            for (row, col) in candidates {
                if row >= 0 && row < row_max && col >= 0 && col < col_max {
                    antinodes.insert((row, col));
                }
            }
        }
    }

    antinodes.len()
}

fn count_unique_antinodes_part2(antennae: &Vec<Antennae>, row_max: i32, col_max: i32) -> usize {
    let mut antinodes = HashSet::<(i32, i32)>::new();

    for (i, a1) in antennae.iter().enumerate() {
        for a2 in antennae.iter().skip(i + 1) {
            if a1.frequency != a2.frequency {
                continue;
            }

            let row_diff = a2.pos.0 - a1.pos.0;
            let col_diff = a2.pos.1 - a1.pos.1;

            let mut row_pos = a1.pos.0;
            let mut col_pos = a1.pos.1;
            while row_pos >= 0 && row_pos < row_max && col_pos >= 0 && col_pos < col_max {
                antinodes.insert((row_pos, col_pos));
                row_pos += row_diff;
                col_pos += col_diff;
            }

            let mut row_pos = a2.pos.0;
            let mut col_pos = a2.pos.1;
            while row_pos >= 0 && row_pos < row_max && col_pos >= 0 && col_pos < col_max {
                antinodes.insert((row_pos, col_pos));
                row_pos -= row_diff;
                col_pos -= col_diff;
            }
        }
    }

    antinodes.len()
}

fn main() {
    let (antennaes, (row_max, col_max)) = parse(include_str!("input"));

    let part1 = count_unique_antinodes(&antennaes, row_max, col_max);
    println!("part1: {}", part1);
    assert!(part1 == 220);

    let part2 = count_unique_antinodes_part2(&antennaes, row_max, col_max);
    println!("part2: {}", part2);
    assert!(part2 == 813);
}

/*macro_rules! antennae {
    ($frequency:literal, ($x:literal, $y:literal)) => {
        Antennae {
            frequency: $frequency,
            pos: ($x, $y),
        }
    };
}*/

#[test]
fn test() {
    let input = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............";

    let (antennaes, (row_max, col_max)) = parse(input);
    assert_eq!(row_max, 12);
    assert_eq!(col_max, 12);
    assert_eq!(antennaes, vec![
        Antennae {
            frequency: '0',
            pos: (1, 8),
        },
        Antennae {
            frequency: '0',
            pos: (2, 5),
        },
        Antennae {
            frequency: '0',
            pos: (3, 7),
        },
        Antennae {
            frequency: '0',
            pos: (4, 4),
        },
        Antennae {
            frequency: 'A',
            pos: (5, 6),
        },
        Antennae {
            frequency: 'A',
            pos: (8, 8),
        },
        Antennae {
            frequency: 'A',
            pos: (9, 9),
        },
    ]);
    let antinodes = count_unique_antinodes(&antennaes, row_max, col_max);
    assert_eq!(antinodes, 14);
    let antinodes = count_unique_antinodes_part2(&antennaes, row_max, col_max);
    assert_eq!(antinodes, 34);
}
