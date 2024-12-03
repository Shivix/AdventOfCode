fn check_safe(report: &Vec<i32>) -> bool {
    let mut prev_increasing = report[1] > report[0];
    let mut prev_reading = report[0];
    for i in 1..report.len() {
        let reading = report[i];
        let diff = (reading - prev_reading).abs();
        if diff < 1 || diff > 3 {
            return false;
        }
        let increasing = reading > prev_reading;
        if increasing != prev_increasing {
            return false;
        }
        prev_reading = reading;
        prev_increasing = increasing;
    }
    return true;
}

fn main() {
    let reports: Vec<Vec<i32>> = include_str!("input")
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|num| num.parse::<i32>().unwrap())
                .collect()
        })
        .collect();

    let all_reports: Vec<Vec<Vec<i32>>> = reports
        .iter()
        .map(|report| {
            (0..report.len())
                .map(|i| {
                    let mut dampened_report = report.clone();
                    dampened_report.remove(i);
                    dampened_report
                })
                .collect()
        })
        .collect();

    let part1 = reports.iter().filter(|report| check_safe(report)).count();

    println!("part1: {}", part1);
    assert!(part1 == 686);

    let part2 = all_reports
        .iter()
        .filter(|dampened_reports| dampened_reports.iter().any(|report| check_safe(report)))
        .count();

    println!("part2: {}", part2);
    assert!(part2 == 717);
}
