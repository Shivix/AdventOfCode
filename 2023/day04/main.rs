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
    1 << matches >> 1
}

fn parse_card(card_data: &str) -> usize {
    let (lhs, rhs) = card_data.split_once('|').unwrap();
    lhs.split_whitespace()
        .skip(2)
        .map(|elem| {
            let winning_number = elem.trim().parse::<usize>().unwrap();
            rhs.split_whitespace().fold(0, |acc, elem| {
                let number = elem.trim().parse::<usize>().unwrap();
                acc + (winning_number == number) as usize
            })
        })
        .sum()
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
        let Card { matches, copies } = cards[i];
        for next_card in cards.iter_mut().skip(i + 1).take(matches) {
            next_card.copies += copies;
        }
    }

    let part2 = cards.iter().fold(0, |acc, card| acc + card.copies);

    println!("part1: {}, part2: {}", part1, part2);
    assert!(part1 == 19135 && part2 == 5704953);
}
