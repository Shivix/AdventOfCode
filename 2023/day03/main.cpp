#include "aoclib.hpp"
#include <map>
#include <set>
#include <vector>
#include <array>

bool is_symbol(char c) {
    return c < '.' || c > '9' || c == '/';
}

constexpr int width{140};

std::array<size_t, 8> make_adjacent_positions(size_t i) {
    return {
        i - 1,
        i - width - 1,
        i - width,
        i - width + 1,
        i + 1,
        i + width - 1,
        i + width,
        i + width + 1,
    };
}

int main() {
    std::ifstream file{"2023/day03/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    std::vector<char> schematic{};
    for (const auto& line: file_data) {
        schematic.insert(schematic.end(), line.begin(), line.end());
    }

    std::string part_number{};
    std::map<std::size_t, int> part_ref{};
    std::vector<size_t> part_positions{};

    for (size_t i{0}; i < schematic.size(); ++i) {
        if (std::isdigit(schematic[i])) {
            part_number += schematic[i];
            part_positions.emplace_back(i);
            continue;
        }
        if (!part_number.empty()) {
            for (auto p: part_positions) {
                part_ref[p] = std::stoi(part_number);
            }
            part_positions.clear();
            part_number.clear();
        }
    }

    int part1{};
    int part2{};
    std::set<int> parts_counted{};
    for (size_t i{0}; i < schematic.size(); ++i) {
        // part 1
        if (!is_symbol(schematic[i])) {
            continue;
        }
        for (auto pos: make_adjacent_positions(i)) {
            if (part_ref.contains(pos)) {
                const auto part{part_ref[pos]};
                // N.B. No part numbers have more than one adjacent symbol
                if (parts_counted.insert(part).second) {
                    part1 += part;
                }
            }
        }
        parts_counted.clear();
        // part 2
        if (schematic[i] != '*') {
            continue;
        }
        int first_part{};
        for (auto pos: make_adjacent_positions(i)) {
            if (part_ref.contains(pos)) {
                const auto part{part_ref[pos]};
                if (first_part != 0 && part != first_part) {
                    part2 += first_part * part;
                }
                first_part = part;
            }
        }
    }
    std::cout << "part1: " << part1 << ", part2: " << part2;
}
