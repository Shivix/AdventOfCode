fn main() {
    let file_data: Vec<&str> = include_str!("input")
        .lines()
        .collect();
    let mut current: i32 = 0;
    let mut result = Vec::<i32>::new();
    for i in &file_data {
        if i.is_empty() {
            result.push(current);
            current = 0
        } else {
            current += i.parse::<i32>().unwrap();
        }
    }
    result.sort();
    result.reverse();
    println!("{}", result[0]);
    println!("{}", result[0] + result[1] + result[2]);
}
