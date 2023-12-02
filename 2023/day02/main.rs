use std::cmp::max;

struct Game {
    id: i32,
    red: i32,
    green: i32,
    blue: i32,
}

fn main() {
    let file_data = include_str!("input");
    // example game => Game 3: 3 green, 4 red; 10 red, 2 blue, 5 green; 9 red, 3 blue, 5 green

    let max_cubes = file_data.lines().map(|line| {
        let (title, reveals) = line.split_once(": ").unwrap();
        let mut game = Game {
            id: title.split_once(' ').unwrap().1.parse::<i32>().unwrap(),
            red: 0,
            green: 0,
            blue: 0,
        };
        reveals.split([';', ',']).for_each(|cubes| {
            let cubes = cubes.trim_start();
            let (amount, colour) = cubes.split_once(' ').unwrap();
            let amount = amount.parse::<i32>().unwrap();
            match colour {
                "red" => game.red = max(game.red, amount),
                "green" => game.green = max(game.green, amount),
                "blue" => game.blue = max(game.blue, amount),
                _ => panic!("invalid colour"),
            };
        });
        game
    });

    // Which games could have 12 reds, 13 greens and 14 blues?
    let part1: i32 = max_cubes.clone().fold(0, |sum, game| {
        if game.red <= 12 && game.green <= 13 && game.blue <= 14 {
            return sum + game.id;
        }
        sum
    });

    let part2: i32 = max_cubes.fold(0, |sum, game| sum + game.red * game.green * game.blue);
    println!("part1: {}, part2: {}", part1, part2);
}
