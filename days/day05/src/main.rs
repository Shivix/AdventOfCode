use regex::Regex;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mut stacks = vec![Vec::<char>::new(); 9];
    let (crates, instructions) = include_str!("../input").split_once("\n\n").unwrap();

    crates.lines().rev().for_each(|line| {
        let line = line.as_bytes();
        if line[1] > 57 {
            stacks[0].push(line[1] as char);
        }
        if line[5] > 57 {
            stacks[1].push(line[5] as char);
        }
        if line[9] > 57 {
            stacks[2].push(line[9] as char);
        }
        if line[13] > 57 {
            stacks[3].push(line[13] as char);
        }
        if line[17] > 57 {
            stacks[4].push(line[17] as char);
        }
        if line[21] > 57 {
            stacks[5].push(line[21] as char);
        }
        if line[25] > 57 {
            stacks[6].push(line[25] as char);
        }
        if line[29] > 57 {
            stacks[7].push(line[29] as char);
        }
        if line[33] > 57 {
            stacks[8].push(line[33] as char);
        }
    });
    let regex = Regex::new(r"(?P<amount>[0-9]+)[^0-9]+(?P<from>[0-9]+)[^0-9]+(?P<to>[0-9]+)")
        .expect("bad regex");

    for instruction in instructions.lines() {
        let capture = regex.captures(instruction).unwrap();
        let amount: i32 = capture["amount"].parse().unwrap();
        let from: usize = capture["from"].parse().unwrap();
        let to: usize = capture["to"].parse().unwrap();

        if args[1] == "-1" {
            for _ in 0..amount {
                let temp = stacks[from - 1].pop().unwrap();
                stacks[to - 1].push(temp);
            }
        } else if args[1] == "-2" {
            let mut to_move = Vec::<char>::new();
            for _ in 0..amount {
                to_move.push(stacks[from - 1].pop().unwrap());
            }
            to_move.reverse();
            for i in to_move {
                stacks[to - 1].push(i);
            }
        }
    }
    for stack in stacks.iter() {
        print!("{}", stack.last().unwrap());
    }
}
