fn main() {
    let input: Vec<char> = include_str!("../input").chars().collect();
    for (i, packet) in input.windows(4).enumerate() {
        let mut v = packet.to_vec();
        v.sort();
        v.dedup();
        if v.len() == 4 {
            println!("{}", i + 4);
            break;
        }
    }
    for (i, packet) in input.windows(14).enumerate() {
        let mut v = packet.to_vec();
        v.sort();
        v.dedup();
        if v.len() == 14 {
            println!("{}", i + 14);
            break;
        }
    }
}
