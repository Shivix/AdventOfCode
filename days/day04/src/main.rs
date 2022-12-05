fn main() {
    let mut part1 = 0;
    let mut part2 = 0;
    include_str!("../input").lines().for_each(|line| {
        let (left_elf, right_elf) = line.split_once(',').unwrap();
        let (x, y) = left_elf.split_once('-').unwrap();
        let (x2, y2) = right_elf.split_once('-').unwrap();
        let x = x.parse::<i32>().unwrap();
        let x2 = x2.parse::<i32>().unwrap();
        let y = y.parse::<i32>().unwrap();
        let y2 = y2.parse::<i32>().unwrap();
        // Check if one entirely encompasses the other.
        if x >= x2 && y <= y2 || x <= x2 && y >= y2 {
            part1 += 1;
        }
        // Check if they overlap at all.
        if y2 >= x && y >= x2 {
            part2 +=1;
        }
    });
    println!("{}", part1);
    println!("{}", part2);
}
