use std::{str::Chars, cmp::Ordering};

#[derive(Debug, Eq, PartialEq, Clone)]
enum Signal {
    List(Vec<Self>),
    Int(i32),
}

impl PartialOrd for Signal {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Signal {
    fn cmp(&self, other: &Self) -> Ordering {
        match (self, other) {
            (Signal::List(a), Signal::List(b)) => a.cmp(b),
            (Signal::Int(a), Signal::List(b)) => vec![Signal::Int(*a)].cmp(b),
            (Signal::List(a), Signal::Int(b)) => a.cmp(&vec![Signal::Int(*b)]),
            (Signal::Int(a), Signal::Int(b)) => a.cmp(b),
        }
    }
}

macro_rules! packet {
    ($n:literal) => {
        Signal::Int($n)
    };
    ([$($i:tt),*]) => {
        Signal::List(vec![
            $(
                packet!($i)
            ),*
        ])
    };
}

fn parse_list(input: &mut Chars) -> Signal {
    let mut result = Vec::<Signal>::new();
    let mut digit = String::new();
    loop {
        // Check if no more lines left.
        let Some(i) = input.next() else {
            break;
        };
        match i {
            '[' => result.push(parse_list(input)),
            ']' => {
                if let Ok(x) = digit.parse::<i32>() {
                    result.push(Signal::Int(x));
                }
                break;
            }
            ',' => {
                if let Ok(x) = digit.parse::<i32>() {
                    result.push(Signal::Int(x));
                }
                digit.clear();
            }
            // Integer
            _ => digit.push(i),
        };
    }
    Signal::List(result)
}

fn main() {
    let packets: Vec<(Signal, Signal)> = include_str!("input")
        .lines()
        .collect::<Vec<&str>>()
        .windows(2)
        .step_by(3)
        .map(|line| {
            (parse_list(&mut line[0].chars()), parse_list(&mut line[1].chars()))
        })
        .collect();

    let mut result = 0;
    for (i, packet) in packets.iter().enumerate() {
        if packet.0 <= packet.1 {
            result += i + 1;
        }
    }

    let mut packets: Vec<Signal> = packets.iter().flat_map(|tup| [tup.0.clone(), tup.1.clone()].into_iter()).collect();
    // Add divider packets
    packets.push(packet!([[2]]));
    packets.push(packet!([[6]]));
    packets.sort();
    let mut result2 = Vec::<usize>::new();
    for (i, packet) in packets.iter().enumerate() {
        if *packet == packet!([[2]]) || *packet == packet!([[6]]) {
            result2.push(i + 1);
        }
    }
    println!("part1: {}", result);
    println!("part2: {}", result2.iter().product::<usize>());
}

#[test]
fn example() {
    let input = r"[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]

[[[7,8],5],[[9,[8,7,8],[],[2,4,10,10],[2,10,8,3,3]],[],[[6,1,10],[],3,6],[3]],[],[4],[3,0,1,10]]
[[[[3,2,1,5],7]],[2,0,7,[4,[4],[10,2,10],[3,0,5,9],1]],[[[]],[[]]],[1,[[0,8,0,3],6,[9,9,5,5,5],6],[[]],8,[[],[0,4,2],[4,2]]],[4]]

[[],[[],0,2],[9,[]],[3,[[8,4,9,1,9]],[10,3,7],1,[5,[10,0,4],[8,8,4,10,8],[6,1,3]]]]
[[0,[]]]";

    let test: Vec<(Signal, Signal)> = input
        .lines()
        .collect::<Vec<&str>>()
        .windows(2)
        .step_by(3)
        .map(|line| {
            // Skip first `[`
            let a = &mut line[0].chars();
            a.next();
            let b = &mut line[1].chars();
            b.next();
            (parse_list(a), parse_list(b))
        })
        .collect();

    assert_eq!(
        test[0].0,
        packet!([1, 1, 3, 1, 1])
    );
    assert_eq!(
        test[1].0,
        packet!([[1], [2, 3, 4]])
    );
    assert_eq!(
        test[9].1,
        packet!([[0, []]])
    );
    assert_eq!(
        test[9].0,
        packet!([[],[[],0,2],[9,[]],[3,[[8,4,9,1,9]],[10,3,7],1,[5,[10,0,4],[8,8,4,10,8],[6,1,3]]]])
    );
    assert!(test[0].0 < test[0].1);
    assert!(test[1].0 < test[1].1);
    assert!(test[2].0 > test[2].1);
    assert!(test[3].0 < test[3].1);
    assert!(test[4].0 > test[4].1);
    assert!(test[5].0 < test[5].1);
    assert!(test[6].0 > test[6].1);
    assert!(test[7].0 > test[7].1);
    assert!(test[8].0 > test[8].1);
    assert!(test[9].0 < test[9].1);
}
