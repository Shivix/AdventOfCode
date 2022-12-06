fn main() {
    let args: Vec<String> = std::env::args().collect();
    let part = aoclib::parse_args(args);
    let input: Vec<char> = include_str!("../input").chars().collect();
    match part {
        Some(1) => part1(&input),
        Some(2) => part2(&input),
        _ => {
            part1(&input);
            part2(&input);
        }
    }
}

fn part1(input: &[char]) {
    for (i, v) in input.windows(4).enumerate() {
        let mut packet = v.to_vec();
        packet.sort();
        packet.dedup();
        if packet.len() == 4 {
            println!("{}", i + 4);
            break;
        }
    }
}

fn part2(input: &[char]) {
    for (i, v) in input.windows(14).enumerate() {
        let mut packet = v.to_vec();
        packet.sort();
        packet.dedup();
        if packet.len() == 14 {
            println!("{}", i + 14);
            break;
        }
    }
}
