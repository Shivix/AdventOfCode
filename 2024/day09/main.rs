#[derive(Clone, Debug, PartialEq)]
enum Block {
    Empty,
    File(usize),
}

#[derive(Clone, Debug, PartialEq)]
struct BlockSet {
    block: Block,
    size: u32,
}

fn parse_file_blocks(input: &str) -> Vec<Block> {
    let mut is_file = true;
    let mut id = 0;
    input
        .trim()
        .chars()
        .flat_map(|char| {
            let count = char.to_digit(10).unwrap() as usize;
            let blocks = if is_file {
                id += 1;
                vec![Block::File(id - 1); count]
            } else {
                vec![Block::Empty; count]
            };
            is_file = !is_file;
            blocks
        })
        .collect()
}

fn parse_file_blockset(input: &str) -> Vec<BlockSet> {
    let mut is_file = true;
    let mut id = 0;
    input
        .trim()
        .chars()
        .map(|char| {
            let size = char.to_digit(10).unwrap();
            let blocks = if is_file {
                id += 1;
                BlockSet {
                    block: Block::File(id - 1),
                    size,
                }
            } else {
                BlockSet {
                    block: Block::Empty,
                    size,
                }
            };
            is_file = !is_file;
            blocks
        })
        .collect()
}

fn shift_file_blocks(input: &Vec<Block>) -> Vec<Block> {
    let mut result = input.clone();
    let mut highest_empty;
    for i in (0..input.len()).rev() {
        let empty_pos = result.iter().position(|elem| *elem == Block::Empty).unwrap();
        highest_empty = empty_pos;
        if i <= highest_empty + 1 {
            break;
        }
        result.swap(i, empty_pos);
    }
    result
}

fn shift_file_blockset(input: &Vec<BlockSet>) -> Vec<BlockSet> {
    let mut result = input.clone();
    for block in input.iter().rev() {
        if block.block == Block::Empty {
            continue;
        }
        let empty_pos = result.iter().position(|elem| elem.block == Block::Empty && elem.size >= block.size);
        if empty_pos.is_none() {
            continue;
        }
        let empty_pos = empty_pos.unwrap();
        let new_pos = result.iter().position(|elem| elem == block).unwrap();
        if empty_pos >= new_pos {
            continue;
        }

        let left_over_space = result[empty_pos].size - block.size;
        result[empty_pos].size = block.size;
        result.swap(new_pos, empty_pos);
        if left_over_space > 0 {
            result.insert(empty_pos + 1, BlockSet{ block: Block::Empty, size: left_over_space});
        }
    }
    result
}

fn blockset_to_blocks(blockset: &Vec<BlockSet>) -> Vec<Block> {
    blockset
        .iter()
        .flat_map(|blockset| {
            if let Block::File(id) = blockset.block {
                vec![Block::File(id); blockset.size as usize]
            } else {
                vec![Block::Empty; blockset.size as usize]
            }
        })
        .collect()
}

fn calculate_checksum(blocks: &Vec<Block>) -> usize {
    blocks
        .iter()
        .enumerate()
        .filter_map(|(i, block)| {
            if let Block::File(id) = block {
                return Some(i * id);
            };
            None
        })
        .sum()
}

fn main() {
    let input = include_str!("input");
    let file_blocks = parse_file_blocks(input);
    let shifted_blocks = shift_file_blocks(&file_blocks);
    let checksum = calculate_checksum(&shifted_blocks);

    println!("part1: {}", checksum);
    assert!(checksum == 6463499258318);

    let file_blockset = parse_file_blockset(input);
    let shifted_blockset = shift_file_blockset(&file_blockset);
    let shifted_blocks = blockset_to_blocks(&shifted_blockset);
    let checksum = calculate_checksum(&shifted_blocks);

    println!("part2: {}", checksum);
    assert!(checksum == 6493634986625);
}

#[cfg(test)]
macro_rules! blocks {
    ($input:expr) => {{
        $input
            .chars()
            .map(|c| match c {
                '.' => Block::Empty,
                digit if digit.is_digit(10) => Block::File(digit.to_digit(10).unwrap() as usize),
                _ => panic!("invalid file id"),
            })
            .collect::<Vec<_>>()
    }};
}

#[cfg(test)]
macro_rules! blockset {
    ($input:expr) => {{
        let mut id = 0;
        let mut is_file = true;
        $input
            .chars()
            .map(|c| {
                let size = c.to_digit(10).unwrap();
                let block = if is_file {
                    id += 1;
                    Block::File(id - 1)
                } else {
                    Block::Empty
                };
                is_file = !is_file;
                BlockSet {
                    block,
                    size,
                }
            })
            .collect::<Vec<_>>()
    }};
}

#[test]
fn test() {
    let input = "2333133121414131402";
    let blocks = parse_file_blocks(input);
    assert_eq!(
        blocks,
        blocks!("00...111...2...333.44.5555.6666.777.888899")
    );
    let shifted_blocks = shift_file_blocks(&blocks);
    assert_eq!(
        shifted_blocks,
        blocks!("0099811188827773336446555566..............")
    );
    let checksum = calculate_checksum(&shifted_blocks);
    assert_eq!(checksum, 1928);
}

#[test]
fn part2_test() {
    let input = "2333133121414131402";
    let blocks = parse_file_blockset(input);
    assert_eq!(
        blocks,
        blockset!("2333133121414131402")
    );
    let shifted_blockset = shift_file_blockset(&blocks);
    let shifted_blocks = blockset_to_blocks(&shifted_blockset);
    assert_eq!(
        shifted_blocks,
        blocks!("00992111777.44.333....5555.6666.....8888..")
    );
    let checksum = calculate_checksum(&shifted_blocks);
    assert_eq!(checksum, 2858);
}
