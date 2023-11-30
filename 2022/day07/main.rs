use std::str::Lines;

enum CmdLine {
    Cd(),
    Return(),
    Ls(),
    Dir(),
    File(i32),
}

fn parse(input: Lines) -> Vec<CmdLine> {
    input
        .map(|line| {
            if line.starts_with("$ cd") {
                if line.split_at(5).1 == ".." {
                    return CmdLine::Return();
                }
                CmdLine::Cd()
            } else if line.starts_with("$ ls") {
                CmdLine::Ls()
            } else if line.starts_with("dir") {
                CmdLine::Dir()
            } else {
                CmdLine::File(line.split_once(' ').unwrap().0.parse().unwrap())
            }
        })
        .collect()
}

fn solve(cmds: &mut std::slice::Iter<'_, CmdLine>) -> Vec<i32> {
    let mut dir = Vec::<i32>::new();
    let mut size: i32 = 0;

    loop {
        // Check if no more lines left.
        let Some(cmd) = cmds.next() else {
            break;
        };
        match cmd {
            CmdLine::Cd() => {
                dir.extend(solve(cmds));
                size += dir.last().unwrap();
            }
            CmdLine::Return() => break,
            CmdLine::Dir() | CmdLine::Ls() => (),
            CmdLine::File(arg) => size += arg,
        }
    }
    dir.push(size);
    dir
}

fn main() {
    let line_iter = include_str!("input").lines();
    let commands = parse(line_iter);
    let result = solve(&mut commands.iter());
    println!("{}", result.iter().filter(|&&x| x < 100_000).sum::<i32>());

    // Root folder always last.
    let total_size = result.last().unwrap();
    let mem_left = 70_000_000 - total_size;
    let to_delete = 30_000_000 - mem_left;
    let part2 = result.iter().find(|&&x| x >= to_delete).unwrap();
    println!("{}", part2);
}
