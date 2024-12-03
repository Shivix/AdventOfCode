fn main() {
    let file_data: Vec<&str> = include_str!("input").split("\n\n").collect();

    let seeds: Vec<u128> = file_data[0]
        .split_whitespace()
        .skip(1)
        .map(|elem| elem.parse::<u128>().unwrap())
        .collect();
    println!("{:?}", seeds);

    for i in file_data.iter().skip(1) {
        i.lines()
        .skip(1)
        .for_each(|elem| println!("{}", elem));
    }

    //println!("part1: {}, part2: {}", part1, part2);
    //assert!(part1 == 19135 && part2 == 5704953);
}
