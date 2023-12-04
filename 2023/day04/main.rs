use regex::Regex;

#[test]
fn test_line_parse() {
    let example_line = "Card   1: 95 11  5  9  3 72 87 | 94 72 74 98 23 57 62 14 30  3 73 49";
    let matches = parse_card(example_line);
    assert_eq!(matches, 2);

    let example_line = "Card   1: 94 11  5 19 23 72 57 49 | 1 94 72 74 98 23 57 62 14 30  3 73 49";
    let matches = parse_card(example_line);
    assert_eq!(matches, 5);
}

#[test]
fn test_score() {
    assert_eq!(score(0), 0);
    assert_eq!(score(1), 1);
    assert_eq!(score(2), 2);
    assert_eq!(score(3), 4);
    assert_eq!(score(4), 8);
}

fn score(matches: usize) -> usize {
    if matches == 0 {
        return 0;
    }
    1 << matches - 1
}

fn parse_card(card_data: &str) -> usize {
    let (lhs, rhs) = card_data.split_once('|').unwrap();
    let regex = Regex::new("[0-9]+( |$)").unwrap();
    let winning_numbers: Vec<usize> = regex
        .find_iter(lhs)
        .map(|elem| elem.as_str().trim().parse::<usize>().unwrap())
        .collect();
    regex.find_iter(rhs).fold(0, |acc, elem| {
        let number = elem.as_str().trim().parse::<usize>().unwrap();
        if winning_numbers.contains(&number) {
            return acc + 1;
        }
        acc
    })
}

struct Card {
    matches: usize,
    copies: usize,
}

fn main() {
    let file_data = include_str!("input").lines();
    let mut cards: Vec<Card> = file_data
        .map(|line| Card {
            matches: parse_card(line),
            copies: 1,
        })
        .collect();

    let part1 = cards.iter().fold(0, |acc, card| acc + score(card.matches));

    for i in 0..cards.len() {
        for _ in 1..=cards[i].copies {
            for j in 1..=cards[i].matches {
                if i + j >= cards.len() {
                    break;
                }
                cards[i + j].copies += 1;
            }
        }
    }
    let part2 = cards.iter().fold(0, |acc, card| acc + card.copies);

    println!("part1: {}, part2: {}", part1, part2);
    assert!(part1 == 19135 && part2 == 5704953);
}
