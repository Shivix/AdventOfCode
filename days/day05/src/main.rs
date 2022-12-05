use regex::Regex;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mut stacks = vec![Vec::<char>::new(); 9];
    let (crates, instructions) = include_str!("../input").split_once("\n\n").unwrap();
    crates.lines().rev().for_each(|line| {
        for (i, c) in line.char_indices().skip(1).step_by(4) {
            if c != ' ' {
                stacks[i / 4].push(c);
            }
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
    for stack in stacks {
        print!("{}", stack.last().unwrap());
    }
}
