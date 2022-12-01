#include <cstring>
#include <exception>
#include <iostream>

/** Parses the commandline arguments and returns the part specified.
    Returns 1 if part1 is specified
    Returns 2 if part2 is specified
    Returns 0 if no part is specified **/
int parse_args(int argc, const char *argv[]) noexcept {
    // FIXME: should return 0 if both -1 and -2 are provided
    for (int i{}; i < argc; ++i) {
        if (std::strcmp(argv[i], "--part1") == 0 || std::strcmp(argv[i], "-1") == 0) {
            return 1;
        }
        if (std::strcmp(argv[i], "--part2") == 0 || std::strcmp(argv[i], "-2") == 0) {
            return 2;
        }
    }
    std::cerr << "USAGE: " << argv[0] << R"( [ARG]
ARG:
    -h, --help                     Print help information
    -1, --part1                    Run only part1
    -2, --part2                    Run only part2
)";
    return 0;
}
