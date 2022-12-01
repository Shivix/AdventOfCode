fn main() {
    let mut file_data: Vec<i32> = include_str!("input")
        .split("\n\n")
        .map(|elf| {
            elf.lines()
                .map(|calories| calories.parse::<i32>().unwrap())
                .sum::<i32>()
        })
        .collect();
    // Sort in descending order.
    file_data.sort_by(|a, b| b.cmp(a));
    println!("{}", file_data[0]);
    println!("{}", file_data.iter().take(3).sum::<i32>());
}
