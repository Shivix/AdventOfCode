fn main() {
    let mut part1 = 0;
    let mut part2 = 0;
    let trees: Vec<Vec<u32>> = include_str!("../input")
        .lines()
        .map(|line| {
            line.chars()
                .map(|char| char.to_digit(10).unwrap())
                .collect()
        })
        .collect();
    for (i, rows) in trees.iter().enumerate() {
        for (j, tree) in rows.iter().enumerate() {
            if i == 0 || j == 0 || i == trees.len() - 1 || j == rows.len() - 1 {
                part1 += 1;
                // outer trees are always visible.
                continue;
            }

            let mut visible = [true, true, true, true];
            let mut scores = [0, 0, 0, 0];

            // Check trees up.
            for x in (0..i).rev() {
                scores[0] += 1;
                if trees[x][j] >= *tree {
                    visible[0] = false;
                    break;
                }
            }

            // Check trees down.
            for row in trees.iter().skip(i + 1) {
                scores[1] += 1;
                if row[j] >= *tree {
                    visible[1] = false;
                    break;
                }
            }

            // Check trees left.
            for x in trees[i][0..j].iter().rev() {
                scores[2] += 1;
                if x >= tree {
                    visible[2] = false;
                    break;
                }
            }

            // Check trees right.
            for x in &trees[i][j + 1..] {
                scores[3] += 1;
                if x >= tree {
                    visible[3] = false;
                    break;
                }
            }
            let visible = visible.into_iter().reduce(|x, y| x | y).unwrap();
            part1 += visible as i32;
            let score = scores.iter().product::<i32>();
            if score > part2 {
                part2 = score;
            }
        }
    }
    println!("part1: {}", part1);
    println!("part2: {}", part2);
}
