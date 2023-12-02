#include "aoclib.hpp"
#include <vector>
#include <algorithm>
#include <ranges>

using std::ranges::views::split;
using std::operator""sv;

int main() {
    std::ifstream file{"2023/day02/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    int part1{};
    int part2{};

    // Game 3: 3 green, 4 red; 10 red, 2 blue, 5 green; 9 red, 3 blue, 5 green
    for (const auto& line: file_data) {
        const auto start_id{line.find_first_of(' ')};
        const auto end_id{line.find(": ")};
        const auto id{line.substr(start_id + 1, end_id - start_id - 1)};
        int red = 0;
        int green = 0;
        int blue = 0;
        for (const auto& reveal : split(line.substr(end_id + 2), "; "sv)) {
            for (const auto& i : split(reveal, ", "sv)) {
                std::string_view cubes{i.data(), i.size()};
                const auto split_pos{cubes.find(' ')};
                const auto amount = std::atoi(cubes.substr(0, split_pos).data());
                const auto colour = cubes.substr(split_pos + 1);
                if (colour == "red") {
                    red = std::max(red, amount);
                } else if (colour == "green") {
                    green = std::max(green, amount);
                } else if (colour == "blue") {
                    blue = std::max(blue, amount);
                }
            }
        }
        if (red <= 12 && green <= 13 && blue <= 14) {
            part1 += stoi(id);
        }
        part2 += red * green * blue;
    }

    std::cout << "part1: " << part1 << ", part2: " << part2;
}
