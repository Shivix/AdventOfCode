#[derive(Debug)]
struct Monkey {
    items: Vec<i64>,
    operation: fn(i64) -> i64,
    test: fn(i64) -> usize,
    test_divisible: i64,
}

macro_rules! monkeys {
    ($start_items:ident,$($operation:expr,$test_mod:literal,$monkey1:literal,$monkey2:literal),*) => {
        {
            let mut item = $start_items.iter();
            vec![ $(
                Monkey {
                    items: item.next().unwrap().to_vec(),
                    operation: $operation,
                    test: |item: i64| -> usize {
                        if item % $test_mod == 0 {
                            return $monkey1;
                        }
                        $monkey2
                    },
                    test_divisible: $test_mod,
                },
            )*]
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let part = aoclib::parse_args(args);
    let starting_items: Vec<Vec<i64>> = include_str!("../input")
        .lines()
        .collect::<Vec<&str>>()
        .windows(6)
        .step_by(7)
        .map(|monkey| {
            monkey[1][18..]
                .split_terminator(", ")
                .map(|val| val.parse().unwrap())
                .collect()
        })
        .collect();

    let mut monkeys = monkeys!(
        starting_items,
        |item: i64| -> i64 { item * 5 },
        17,
        4,
        7,
        |item: i64| -> i64 { item + 3 },
        7,
        3,
        2,
        |item: i64| -> i64 { item + 7 },
        13,
        0,
        7,
        |item: i64| -> i64 { item + 5 },
        2,
        0,
        2,
        |item: i64| -> i64 { item + 2 },
        19,
        6,
        5,
        |item: i64| -> i64 { item * 19 },
        3,
        6,
        1,
        |item: i64| -> i64 { item * item },
        5,
        3,
        1,
        |item: i64| -> i64 { item + 4 },
        11,
        5,
        4
    );

    let mut inspections = [0_u128; 8];

    if part == Some(1) {
        for _ in 0..20 {
            for i in 0..monkeys.len() {
                for _ in 0..monkeys[i].items.len() {
                    let new_item = (monkeys[i].operation)(monkeys[i].items.remove(0)) / 3;
                    let pass_monkey = (monkeys[i].test)(new_item);
                    monkeys[pass_monkey].items.push(new_item);
                    inspections[i] += 1;
                }
            }
        }
    } else {
        for _ in 0..10000 {
            for i in 0..monkeys.len() {
                for _ in 0..monkeys[i].items.len() {
                    let new_item = (monkeys[i].operation)(
                        monkeys[i].items.remove(0)
                            % monkeys.iter().map(|m| m.test_divisible).product::<i64>(),
                    );
                    let pass_monkey = (monkeys[i].test)(new_item);
                    monkeys[pass_monkey].items.push(new_item);
                    inspections[i] += 1;
                }
            }
        }
    }

    inspections.sort();
    println!("{:?}", inspections);
    println!("{}", inspections[6] * inspections[7]);
}
