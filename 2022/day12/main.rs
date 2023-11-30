use pathfinding::prelude::bfs;

#[derive(Clone, Eq, Hash, PartialEq)]
struct Pos(usize, usize);

impl Pos {
    fn successors(&self, map: &Vec<Vec<u8>>) -> Vec<Pos> {
        let &Pos(x, y) = self;
        let mut result = Vec::<Pos>::new();
        if x < map.len() - 1 && map[x + 1][y] <= map[x][y] + 1 {
            result.push(Pos(x + 1, y));
        }
        if x > 0 && map[x - 1][y] <= map[x][y] + 1 {
            result.push(Pos(x - 1, y));
        }
        if y < map[0].len() - 1 && map[x][y + 1] <= map[x][y] + 1 {
            result.push(Pos(x, y + 1));
        }
        if y > 0 && map[x][y - 1] <= map[x][y] + 1 {
            result.push(Pos(x, y - 1));
        }
        result
    }
}

fn main() {
    let map: Vec<Vec<u8>> = include_str!("input")
        .lines()
        .map(|line| line.bytes().collect())
        .collect();

    const GOAL: Pos = Pos(21, 137);

    // Part1
    let result = bfs(&Pos(21, 1), |p| p.successors(&map), |p| *p == GOAL).expect("no path found");
    // Counts the starting position.
    println!("{}", result.len() - 1);

    // Part2
    let mut routes = Vec::<usize>::new();
    for (x, i) in map.iter().enumerate() {
        for (y, j) in i.iter().enumerate() {
            if *j == 97 {
                if let Some(route) = bfs(&Pos(x, y), |p| p.successors(&map), |p| *p == GOAL) {
                    routes.push(route.len() - 1);
                }
            }
        }
    }

    routes.sort();
    println!("{}", routes[0]);
}
