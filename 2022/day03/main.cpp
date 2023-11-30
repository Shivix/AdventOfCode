#include "aoclib.hpp"
#include <vector>
#include <algorithm>

int main(int argc, const char* argv[]) {
    const auto part{parse_args(argc, argv)};
    std::ifstream file{"2022/day03/input"};
	const std::vector<std::string> file_data{IfstreamIterator{file}, {}};   
    int result{};

    if (part == 1) {
        for(const auto& line: file_data) {
            const auto pack1{line.substr(0, line.size() / 2)};
            const auto pack2{line.substr(line.size() / 2)};
            const auto item{*std::ranges::find_first_of(pack1, pack2)};
            result += isupper(item) ? item - 38 : item - 96;
        };
        std::cout << result;
    } else if (part == 2) {
        for(size_t i{}; i < file_data.size(); i += 3) {
            const auto& pack1{file_data[i]};
            const auto& pack2{file_data[i + 1]};
            const auto& pack3{file_data[i + 2]};
            std::string shared_items{};
            for (auto item: pack1) {
                if (std::ranges::find(pack2, item) != pack2.end()) {
                    shared_items.push_back(item);
                }
            }
            const auto badge{*std::ranges::find_first_of(shared_items, pack3)};
            result += isupper(badge) ? badge - 38 : badge - 96;
        };
        std::cout << result;
    }
}
