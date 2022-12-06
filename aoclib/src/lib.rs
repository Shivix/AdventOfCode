pub fn parse_args(args: Vec<String>) -> Option<i32> {
    if args.len() == 1 {
        return None;
    }
    if args[1] == "--part1" || args[1] == "-1" {
        return Some(1);
    }
    if args[1] == "--part2" || args[1] == "-2" {
        return Some(2);
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = parse_args(vec!["bin".to_string(), "--part1".to_string()]);
        assert_eq!(result, Some(1));
    }
}
