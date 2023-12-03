#include "aoclib.hpp"
#include <map>
#include <vector>
#include <algorithm>
#include <ranges>

bool is_symbol(char c) {
    return c < '.' || c > '9' || c == '/';
}

bool get_cog(int& part2, size_t pos, const std::map<size_t, std::string>& part_ref, std::string& first_part) {
    if (part_ref.contains(pos)) {
        const auto& part{part_ref.at(pos)};
        if (!first_part.empty() && part != first_part) {
            part2 += std::stoi(first_part) * std::stoi(part);
            return true;
        }
        first_part = part;
    }
    return false;
}

int main() {
    std::ifstream file{"2023/day03/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    int part1{};
    int part2{};
    static constexpr int width{140};
    std::vector<char> schematic{};
    for (const auto& line: file_data) {
        schematic.insert(schematic.end(), line.begin(), line.end());
    }
    
    std::string part_number{};
    std::map<size_t, std::string> part_ref{};
    bool is_part_number{};
    std::vector<size_t> part_positions{};
    for (size_t i{0}; i < schematic.size(); ++i) {
        const auto curr_char{schematic[i]};
        if (!std::isdigit(curr_char)) {
            if (!part_number.empty()) {
                if (is_part_number) {
                    part1 += std::stoi(part_number);
                }
                for (auto p: part_positions) {
                    part_ref[p] = part_number;
                }
                part_positions.clear();
                part_number.clear();
            }
            is_part_number = false;
            continue;
        }
        part_number += curr_char;
        part_positions.emplace_back(i);
        // check for out of bounds. if oob then not symbol.
        const auto top_left{i - width - 1};
        const auto top{i - width};
        const auto top_right{i - width + 1};
        const auto right{i + 1};
        const auto bottom_right{i + width + 1};
        const auto bottom{i + width};
        const auto bottom_left{i + width - 1};
        const auto left{i - 1};
        char symbol{};
        if (top_left < schematic.size() && is_symbol(schematic[top_left])) {
            is_part_number = true;
        } else if (top < schematic.size() && is_symbol(schematic[top])) {
            is_part_number = true;
        } else if (top_right < schematic.size() && is_symbol(schematic[top_right])) {
            is_part_number = true;
        } else if (right < schematic.size() && is_symbol(schematic[right])) {
            is_part_number = true;
        } else if (bottom_right < schematic.size() && is_symbol(schematic[bottom_right])) {
            is_part_number = true;
        } else if (bottom < schematic.size() && is_symbol(schematic[bottom])) {
            is_part_number = true;
        } else if (bottom_left < schematic.size() && is_symbol(schematic[bottom_left])) {
            is_part_number = true;
        } else if (left < schematic.size() && is_symbol(schematic[left])) {
            is_part_number = true;
        }
    }

    for (size_t i{0}; i < schematic.size(); ++i) {
        const auto top_left{i - width - 1};
        const auto top{i - width};
        const auto top_right{i - width + 1};
        const auto right{i + 1};
        const auto bottom_right{i + width + 1};
        const auto bottom{i + width};
        const auto bottom_left{i + width - 1};
        const auto left{i - 1};
        if (schematic[i] == '*') {
            std::string first_part{};
            if (get_cog(part2, top_left, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, top, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, top_right, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, right, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, bottom_right, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, bottom, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, bottom_left, part_ref, first_part)) {
                continue;
            }
            if (get_cog(part2, left, part_ref, first_part)) {
                continue;
            }
        }
    }
    std::cout << "part1: " << part1 << ", part2: " << part2;
}
