#include "aoclib.hpp"
#include <vector>

int solve(std::string_view input) {
    int points{0};
    const auto them{input[0]};
    const auto us{input[2]};
    if (us == 'X') {
        points += 1;
        if (them == 'A') {
            points += 3;
        } else if (them == 'B') {
            // Lose no points.
        } else if (them == 'C') {
            points += 6;
        }
    } else if (us == 'Y') {
        points += 2;
        if (them == 'A') {
            points += 6;
        } else if (them == 'B') {
            points += 3;
        } else if (them == 'C') {
            // Lose no points.
        }
    } else if (us == 'Z') {
        points += 3;
        if (them == 'A') {
            // Lose no points.
        } else if (them == 'B') {
            points += 6;
        } else if (them == 'C') {
            points += 3;
        }
    }
    return points;
}

int main(int argc, const char* argv[]) {
    const auto part{parse_args(argc, argv)};
    std::ifstream file{"days/day02/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    int result{};
    if (part == 1) {
        for(const auto& line: file_data) {
            result += solve(line);
        }
        std::cout << result;
    } else if (part == 2) {
    }
}
