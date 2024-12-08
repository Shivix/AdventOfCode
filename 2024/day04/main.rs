use std::collections::HashMap;

fn get_char_pos(pos: usize, i: usize, direction: i32) -> usize {
    (pos as i32 + i as i32 * direction) as usize
}

fn collect_words(
    grid: &Vec<Vec<char>>,
    word: &str,
    directions: &[(i32, i32)],
) -> Vec<(usize, usize)> {
    let mut result = Vec::new();
    let letters: Vec<char> = word.chars().collect();
    for row in 0..grid.len() {
        for col in 0..grid[row].len() {
            if grid[row][col] != letters[0] {
                continue;
            }
            for d in directions {
                for i in 1..letters.len() {
                    let r = get_char_pos(row, i, d.0);
                    let c = get_char_pos(col, i, d.1);
                    // If r/c overflow into negative they will wrap to the largest value which also
                    // procs this check.
                    if r >= grid.len() || c >= grid[r].len() {
                        break;
                    }
                    let next_char = grid[r][c];
                    if next_char != letters[i] {
                        break;
                    }
                    if i == letters.len() - 1 {
                        let a_row = get_char_pos(row, i - 1, d.0);
                        let a_col = get_char_pos(col, i - 1, d.1);
                        result.push((a_row, a_col));
                    }
                }
            }
        }
    }
    result
}

fn part1(grid: &Vec<Vec<char>>) -> usize {
    let directions: [(i32, i32); 8] = [
        (1, -1),
        (1, 0),
        (1, 1),
        (0, 1),
        (0, -1),
        (-1, -1),
        (-1, 0),
        (-1, 1),
    ];
    let words = collect_words(grid, "XMAS", &directions);
    words.len()
}

fn part2(grid: &Vec<Vec<char>>) -> i32 {
    let directions: [(i32, i32); 4] = [(1, -1), (1, 1), (-1, -1), (-1, 1)];
    let words = collect_words(grid, "MAS", &directions);
    let mut occurrences: HashMap<(usize, usize), i32> = HashMap::new();
    words.iter().fold(0, |acc, a_pos| {
        if occurrences.contains_key(&a_pos) {
            return acc + 1;
        }
        occurrences.insert(*a_pos, 0);
        acc
    })
}

fn main() {
    let input = include_str!("input");
    let grid: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();

    let part1 = part1(&grid);
    println!("part1: {}", part1);
    assert!(part1 == 2390);

    let part2 = part2(&grid);
    println!("part2: {}", part2);
    assert!(part2 == 1809);
}

#[test]
fn test() {
    let input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";
    let grid = input.lines().map(|line| line.chars().collect()).collect();

    assert_eq!(part1(&grid), 18);
}
