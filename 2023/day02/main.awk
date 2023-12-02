function max(a, b) {
    return a > b ? a : b
}
BEGIN { part1 = 0; part2 = 0 }
{
    # Game 3: 3 green, 4 red; 10 red, 2 blue, 5 green; 9 red, 3 blue, 5 green
    sub(/^.*: /, "", $0)
    id = NR
    red = 0
    green = 0
    blue = 0
    split($0, cubes, ", |; ")
    for (i in cubes) {
        split(cubes[i], amount_colour, " ")
        amount = amount_colour[1]
        colour = amount_colour[2]
        if (colour == "red") {
            red = max(red, amount)
        } else if (colour == "green") {
            green = max(green, amount)
        } else if (colour == "blue") {
            blue = max(blue, amount)
        }
    }
    if (red <= 12 && green <= 13 && blue <= 14) {
        part1 += id
    }
    part2 += red * green * blue
}
END { print part1, part2 }
