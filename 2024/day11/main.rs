use std::collections::HashMap;

fn parse(input: &str) -> HashMap<i128, i128> {
    input
        .split_whitespace()
        .map(|split| (split.parse().unwrap(), 1))
        .collect()
}

fn blink(stones: &HashMap<i128, i128>) -> HashMap<i128, i128> {
    let mut result = HashMap::with_capacity(stones.len());

    for (&stone, &count) in stones {
        if stone == 0 {
            *result.entry(1).or_insert(0) += count;
        } else {
            let digits = stone.ilog10() + 1;
            if digits % 2 == 0 {
                let divisor = 10_i128.pow(digits as u32 / 2);
                *result.entry(stone / divisor).or_insert(0) += count;
                *result.entry(stone % divisor).or_insert(0) += count;
            } else {
                let k = stone * 2024;
                *result.entry(k).or_insert(0) += count;
            }
        }
    }

    result
}

fn main() {
    let input = include_str!("input");
    let mut stones = parse(input);

    for _ in 0..25 {
        stones = blink(&stones);
    }
    let part1 = stones.iter().map(|i| i.1 ).sum::<i128>();
    println!("part1: {}", part1);
    assert!(part1 == 198089);

    for _ in 0..50 {
        stones = blink(&stones);
    }
    let part2 = stones.iter().map(|i| i.1 ).sum::<i128>();
    println!("part2: {}", part2);
    assert!(part2 == 236302670835517);

    for _ in 0..125 {
        stones = blink(&stones);
    }
    let flex = stones.iter().map(|i| i.1 ).sum::<i128>();
    println!("250 blinks: {}", flex);
}

//#[test]
//fn test() {
//    let input = "0 1 10 99 999";
//    let stones = parse(input);
//
//    assert_eq!(stones, vec![0, 1, 10, 99, 999]);
//
//    let stones = blink(&stones);
//    assert_eq!(stones, vec![1, 2024, 1, 0, 9, 9, 2021976]);
//}
//
#[test]
fn multi_blink() {
    let input = "125 17";
    let mut stones = parse(input);
    //assert_eq!(stones, vec![125, 17]);

    //stones = blink(&stones);
    //assert_eq!(stones, vec![253000, 1, 7]);
    //stones = blink(&stones);
    //assert_eq!(stones, vec![253, 0, 2024, 14168]);
    //stones = blink(&stones);
    //assert_eq!(stones, vec![512072, 1, 20, 24, 28676032]);
    //stones = blink(&stones);
    //assert_eq!(stones, vec![512, 72, 2024, 2, 0, 2, 4, 2867, 6032]);
    //stones = blink(&stones);
    //assert_eq!(
    //    stones,
    //    vec![1036288, 7, 2, 20, 24, 4048, 1, 4048, 8096, 28, 67, 60, 32]
    //);
    //stones = blink(&stones);
    //assert_eq!(
    //    stones,
    //    vec![
    //        2097446912, 14168, 4048, 2, 0, 2, 4, 40, 48, 2024, 40, 48, 80, 96, 2, 8, 6, 7, 6, 0, 3,
    //        2
    //    ]
    //);

    for _ in 0..25 {
        stones = blink(&stones);
    }
    assert_eq!(stones.iter().map(|i| i.1 ).sum::<i128>(), 55312);
}
