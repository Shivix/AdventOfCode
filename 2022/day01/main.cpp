#include "aoclib.hpp"
#include <vector>
#include <array>

int main(int argc, const char* argv[]) {
    const auto part{parse_args(argc, argv)};
    std::ifstream file{"2022/day01/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    int result{};

    if (part == 1) {
        int current{};
        for(const auto& line: file_data) {
            if (line.empty()) {
                if (current > result) {
                    result = current;
                }
                current = {};
                continue;
            }
            current += stoi(line);
        };
        std::cout << result;
    } else if (part == 2) {
        std::array<int, 3> result_group{};
        int current{};
        for(const auto& line: file_data) {
            if (line.empty()) {
                if (current > result_group[2]) {
                    result_group[0] = result_group[1];
                    result_group[1] = result_group[2];
                    result_group[2] = current;
                }
                else if (current > result_group[1]) {
                    result_group[0] = result_group[1];
                    result_group[1] = current;
                }
                else if (current > result_group[0]) {
                    result_group[0] = current;
                }
                current = {};
                continue;
            }
            current += stoi(line);
        };
        for (auto i: result_group) {
            result += i;
        }
        std::cout << result;
    }
}
// cat input | awk 'BEGIN { result = 0 }; /[0-9]+/ { current += $1 }; $0 !~ /[0-9]+/ { print current; current = 0 }' | sort -g | tail -3 | awk 'BEGIN { print "day 1:" } // { print $0; result += $1 } END { print "day 2:\n"result }'
