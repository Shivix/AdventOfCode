type Equation = (i64, Vec<i64>);

fn concatenate_numbers(left: i64, right: i64) -> i64 {
    let multiplier = 10_i64.pow((right as f64).log10().floor() as u32 + 1);
    left * multiplier + right
}

fn can_evaluate_to(numbers: &[i64], target: i64, current: i64, part2: bool) -> bool {
    if numbers.is_empty() {
        return current == target;
    }

    let first = numbers[0];
    let rest = &numbers[1..];

    if can_evaluate_to(rest, target, current + first, part2) {
        return true;
    }
    if can_evaluate_to(rest, target, current * first, part2) {
        return true;
    }
    if part2
        && can_evaluate_to(
            rest,
            target,
            concatenate_numbers(current, first),
            part2,
        )
    {
        return true;
    }

    false
}

fn part1(equations: &Vec<Equation>) -> i64 {
    solve(equations, false)
}

fn part2(equations: &Vec<Equation>) -> i64 {
    solve(equations, true)
}

fn solve(equations: &Vec<Equation>, part2: bool) -> i64 {
    equations
        .iter()
        .filter_map(|(result, equation)| {
            if can_evaluate_to(&equation[1..], *result, equation[0], part2) {
                Some(*result)
            } else {
                None
            }
        })
        .sum()
}

fn parse(input: &str) -> Vec<Equation> {
    input
        .lines()
        .map(|line| {
            let (result, equation) = line.split_once(": ").unwrap();
            let equation = equation
                .split_whitespace()
                .map(|number| number.parse().unwrap())
                .collect();
            (result.parse().unwrap(), equation)
        })
        .collect()
}

fn main() {
    let equations = parse(include_str!("input"));

    let part1 = part1(&equations);
    println!("part1: {}", part1);
    assert!(part1 == 1298300076754);

    let part2 = part2(&equations);
    println!("part2: {}", part2);
    assert!(part2 == 248427118972289);
}

#[test]
fn test() {
    let input = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20";

    let equations = parse(input);
    assert_eq!(equations[1], (3267, vec![81, 40, 27]));

    let part1 = part1(&equations);
    let part2 = part2(&equations);
    assert_eq!(part1, 3749);
    assert_eq!(part2, 11387);
}
