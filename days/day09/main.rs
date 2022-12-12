use std::collections::HashMap;

fn main() {
    // minus head
    const NUM_OF_KNOTS: usize = 9;
    let mut positions = HashMap::<(i32, i32), ()>::new();
    let mut knot_pos = [(0, 0); NUM_OF_KNOTS + 1];

    include_str!("input").lines().for_each(|line| {
        // calculate new head position separately.
        let (direction, amount) = line.split_once(' ').unwrap();
        let amount = amount.parse::<i32>().unwrap();
        match direction {
            "U" => knot_pos[0].1 += amount,
            "D" => knot_pos[0].1 -= amount,
            "L" => knot_pos[0].0 -= amount,
            "R" => knot_pos[0].0 += amount,
            _ => panic!("invalid direction"),
        };
        for _ in 0..amount {
            for i in 1..=NUM_OF_KNOTS {
                if (knot_pos[i - 1].0 - knot_pos[i].0 as i32).abs() <= 1
                    && (knot_pos[i - 1].1 - knot_pos[i].1 as i32).abs() <= 1
                {
                    // Current knot does not need to move, neither will the rest.
                    break;
                }
                knot_pos[i].0 += (knot_pos[i - 1].0 - knot_pos[i].0).signum();
                knot_pos[i].1 += (knot_pos[i - 1].1 - knot_pos[i].1).signum();
            }
            positions.insert(knot_pos[NUM_OF_KNOTS], ());
        }
    });
    println!("{}", positions.len());
}
