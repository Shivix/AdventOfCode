#include "aoclib.hpp"
#include <vector>
#include <array>
#include <algorithm>

int get_digit(std::string_view line, size_t i) {
    std::string word{};
    if (std::isdigit(line[i])) {
        return line[i] - '0';
    }
    for (; i < line.size(); ++i) {
        word += line[i];
        if (word == "one") {
            return 1;
        }
        if (word == "two") {
            return 2;
        }
        if (word == "three") {
            return 3;
        }
        if (word == "four") {
            return 4;
        }
        if (word == "five") {
            return 5;
        }
        if (word == "six") {
            return 6;
        }
        if (word == "seven") {
            return 7;
        }
        if (word == "eight") {
            return 8;
        }
        if (word == "nine") {
            return 9;
        }
    }
    return 0;
}

std::pair<int, int> part1(std::string_view line) {
    const int first{*std::ranges::find_if(line, [](auto elem) {
        return std::isdigit(elem);
    }) - '0'};
    const int second{*std::find_if(line.rbegin(), line.rend(), [](auto elem) {
        return std::isdigit(elem);
    }) - '0'};
    return {first, second};
}

std::pair<int, int> part2(std::string_view line) {
    int first{};
    int second{};
    for (size_t i{}; i < line.size(); ++i) {
        if (auto value{get_digit(line, i)}; value != 0) {
            first = value;
            break;
        }
    }
    for (size_t i{line.size() - 1}; i >= 0; --i) {
        if (auto value{get_digit(line, i)}; value != 0) {
            second = value;
            break;
        }
    }
    return {first, second};
}

int main(int argc, const char* argv[]) {
    const auto part{parse_args(argc, argv)};
    std::ifstream file{"2023/day01/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    const auto get_calibration_value{[part]{
        if (part == 2) {
            return part2;
        }
        return part1;
    }()};
    int result{};

    for (const auto& line: file_data) {
        std::cout << line << std::endl;
        const auto [first, second] = get_calibration_value(line);
        std::cout << first << second << std::endl;
        result += first * 10 + second;
    }

    std::cout << result;
}
