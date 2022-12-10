fn main() {
    let mut x = 1;
    let mut result = vec![1];
    include_str!("../input").lines().for_each(|line| {
        result.push(x);
        if line != "noop" {
            // addx takes too ticks where first tick's x will be unchanged.
            result.push(x);
            x += line[5..].parse::<i32>().unwrap();
        }
    });
    let part1 = result[20] * 20
        + result[60] * 60
        + result[100] * 100
        + result[140] * 140
        + result[180] * 180
        + result[220] * 220;
    println!("part1: {}\npart2:", part1);

    let mut screen = vec![' '; 40 * 6];
    for (tick, x) in result.into_iter().enumerate() {
        if (x - (tick as i32 - 1) % 40).abs() < 2 {
            screen[tick] = '█';
        }
    }
    for (i, pixel) in screen.iter().enumerate() {
        print!("{}", pixel);
        if i % 40 == 0 {
            print!("\n")
        }
    }
}
