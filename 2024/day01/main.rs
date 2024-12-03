fn main() {
    let (mut list1, mut list2): (Vec<i32>, Vec<i32>) = include_str!("input")
        .lines()
        .map(|line| {
            let (left, right) = line.split_once("   ").unwrap();
            (left.parse::<i32>().unwrap(), right.parse::<i32>().unwrap())
        })
        .unzip();

    list1.sort();
    list2.sort();

    let part1: i32 = list1
        .iter()
        .zip(list2.iter())
        .map(|(left, right)| (left - right).abs() )
        .sum();

    println!("part1: {}", part1);
    assert!(part1 == 3574690);

    let mut part2 = 0;
    for left in list1.iter() {
        for right in list2.iter() {
            if left == right {
                part2 += left;
            }
        }
    }

    println!("part2: {}", part2);
    assert!(part2 == 22565391);
}
