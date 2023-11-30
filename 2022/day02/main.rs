/// returns points for the round.
fn solve(input: &str) -> i32 {
    // input example: "A X"
    let mut points = 0;
    let (them, us) = input.split_once(' ').unwrap();
    if us == "X" {
        points += 1;
        points += match them {
            "A" => 3,
            "B" => 0,
            "C" => 6,
            _ => 0,
        }
    } else if us == "Y" {
        points += 2;
        points += match them {
            "A" => 6,
            "B" => 3,
            "C" => 0,
            _ => 0,
        }
    } else if us == "Z" {
        points += 3;
        points += match them {
            "A" => 0,
            "B" => 6,
            "C" => 3,
            _ => 0,
        }
    }
    points
}
fn solve2(input: &str) -> i32 {
    // input example: "A X"
    let mut points = 0;
    let (them, result) = input.split_once(' ').unwrap();
    if result == "X" {
        points += match them {
            "A" => 3,
            "B" => 1,
            "C" => 2,
            _ => 0,
        }
    } else if result == "Y" {
        points += match them {
            "A" => 4,
            "B" => 5,
            "C" => 6,
            _ => 0,
        }
    } else if result == "Z" {
        points += match them {
            "A" => 8,
            "B" => 9,
            "C" => 7,
            _ => 0,
        }
    }
    points
}

fn main() {
    // A/X rock(1) B/Y paper(2) C/Z scissors(3)
    // 0 lose 3 draw 6 win
    // part2:
    // X lose y draw z win
    let file_data = include_str!("input");
    let part1: i32 = file_data.lines().map(solve).sum();
    println!("{}", part1);
    let part2: i32 = file_data.lines().map(solve2).sum();
    println!("{}", part2);
}
