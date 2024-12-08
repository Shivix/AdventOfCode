fn parse_input(input: &str) -> (Vec<(i32, i32)>, Vec<Vec<i32>>) {
    let (order_rules, updates) = input.split_once("\n\n").unwrap();

    let order_rules: Vec<(i32, i32)> = order_rules
        .lines()
        .map(|rule| {
            let (left, right) = rule.split_once('|').unwrap();
            (left.parse().unwrap(), right.parse().unwrap())
        })
        .collect();
    let updates: Vec<Vec<i32>> = updates
        .lines()
        .map(|update| {
            update
                .split(",")
                .map(|split| split.parse().unwrap())
                .collect::<Vec<i32>>()
        })
        .collect();
    (order_rules, updates)
}

fn part1(rules: &Vec<(i32, i32)>, updates: &Vec<Vec<i32>>) -> i32 {
    updates
        .iter()
        .filter(|update| {
            !rules.iter().any(|rule| {
                let pos1 = update.iter().position(|&i| i == rule.0);
                let pos2 = update.iter().position(|&i| i == rule.1);
                if pos1.is_none() || pos2.is_none() {
                    return false;
                }
                pos1.unwrap() > pos2.unwrap()
            })
        })
        .map(|update| update.get(update.len() / 2).unwrap())
        .sum()
}

fn part2(rules: &Vec<(i32, i32)>, updates: &Vec<Vec<i32>>) -> i32 {
    let mut corrected_updates = Vec::<Vec<i32>>::new();
    for update in updates {
        let mut broke_rule = false;
        let mut new_update = update.clone();
        'retry: loop {
            for rule in rules {
                let pos1 = new_update.iter().position(|&i| i == rule.0);
                let pos2 = new_update.iter().position(|&i| i == rule.1);
                if pos1.is_none() || pos2.is_none() {
                    continue;
                }
                let pos1 = pos1.unwrap();
                let pos2 = pos2.unwrap();
                if pos1 < pos2 {
                    continue;
                }
                broke_rule = true;
                new_update.swap(pos1, pos2);
                continue 'retry;
            }
            break;
        }
        if broke_rule {
            corrected_updates.push(new_update);
        }
    }
    corrected_updates
        .iter()
        .map(|update| update.get(update.len() / 2).unwrap())
        .sum()
}

fn main() {
    let (rules, updates) = parse_input(include_str!("input"));

    let part1 = part1(&rules, &updates);
    println!("part1: {}", part1);
    assert!(part1 == 4872);

    let part2 = part2(&rules, &updates);
    println!("part2: {}", part2);
    assert!(part2 == 5564);
}

#[test]
fn test() {
    let input = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47";
    let (rules, updates) = parse_input(input);

    assert_eq!(part1(&rules, &updates), 143);
    assert_eq!(part2(&rules, &updates), 123);
}
