fn find_first_of(line: &str) -> i32 {
    let mut item = ' ';
    for i in line[..line.len() / 2].chars() {
        if line[line.len() / 2..].contains(i) {
            item = i;
        }
    }
    if item.is_uppercase() {
        item as i32 - 38
    } else {
        item as i32 - 96
    }
}

fn main() {
    let part1: i32 = include_str!("input").lines().map(find_first_of).sum();
    println!("{}", part1);
}
