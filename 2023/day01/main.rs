fn main() {
    let file_data = include_str!("input");
    let part1: u32 = file_data
        .lines()
        .map(|line| {
            let calibrated: Vec<u32> = line.chars().filter_map(|char| char.to_digit(10)).collect();
            let first = calibrated[0];
            let last = calibrated.last().unwrap();
            first * 10 + last
        })
        .sum();
    let part2: u32 = file_data
        .lines()
        .map(|line| {
            println!("{}", line);
            let calibrated: Vec<u32> = line
                .chars()
                .enumerate()
                .filter_map(|(i, char)| {
                    char.to_digit(10).or_else(|| {
                        for end in i..=line.len() {
                            let word = &line[i..end];
                            if word == "one" {
                                return Some(1);
                            } else if word == "two" {
                                return Some(2);
                            } else if word == "three" {
                                return Some(3);
                            } else if word == "four" {
                                return Some(4);
                            } else if word == "five" {
                                return Some(5);
                            } else if word == "six" {
                                return Some(6);
                            } else if word == "seven" {
                                return Some(7);
                            } else if word == "eight" {
                                return Some(8);
                            } else if word == "nine" {
                                return Some(9);
                            }
                        }
                        None
                    })
                })
                .collect();
            let first = calibrated[0];
            let last = calibrated.last().unwrap();
            println!("{}{}", first, last);
            first * 10 + last
        })
        .sum();
    println!("part1: {}, part2: {}", part1, part2);
}
