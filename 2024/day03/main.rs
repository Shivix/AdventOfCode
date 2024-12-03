use regex::Regex;

#[derive(Debug, PartialEq)]
enum Cmd {
    Mul(i32, i32),
    Do,
    Dont,
}

fn parse(input: &str) -> Vec<Cmd> {
    let regex = Regex::new(r"do\(\)|don't\(\)|mul\(([0-9]+),([0-9]+)\)").expect("bad regex");
    regex
        .captures_iter(input)
        .map(|capture| {
            let cmd = capture.get(0).unwrap().as_str();
            if cmd == "do()" {
                Cmd::Do
            } else if cmd == "don't()" {
                Cmd::Dont
            } else {
                let left = capture.get(1).unwrap().as_str();
                let right = capture.get(2).unwrap().as_str();
                Cmd::Mul(left.parse().unwrap(), right.parse().unwrap())
            }
        })
        .collect()
}

fn main() {
    let input = include_str!("input");
    let cmds = parse(input);

    let part1: i32 = cmds
        .iter()
        .filter_map(|cmd| match cmd {
            Cmd::Mul(left, right) => Some(left * right),
            _ => None,
        })
        .sum();
    assert!(part1 == 183788984);

    let mut active = true;
    let part2: i32 = cmds
        .iter()
        .filter_map(|cmd| match cmd {
            Cmd::Mul(left, right) => {
                if active {
                    Some(left * right)
                } else {
                    None
                }
            }
            Cmd::Do => {
                active = true;
                None
            }
            Cmd::Dont => {
                active = false;
                None
            }
        })
        .sum();
    assert!(part2 == 62098619);

    println!("part1: {}", part1);
    println!("part2: {}", part2);
}

#[test]
fn test_parse_mul() {
    let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
    let matches = parse(input);
    assert_eq!(
        matches,
        vec![
            Cmd::Mul(2, 4),
            Cmd::Mul(5, 5),
            Cmd::Mul(11, 8),
            Cmd::Mul(8, 5)
        ]
    );
}

#[test]
fn test_parse_all() {
    let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";
    let matches = parse(input);
    assert_eq!(
        matches,
        vec![
            Cmd::Mul(2, 4),
            Cmd::Dont,
            Cmd::Mul(5, 5),
            Cmd::Mul(11, 8),
            Cmd::Do,
            Cmd::Mul(8, 5)
        ]
    );
}
