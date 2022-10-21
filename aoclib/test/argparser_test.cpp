#define BOOST_TEST_MODULE AocLib Unit_Test
#ifndef WIN32
#define BOOST_TEST_DYN_LINK
#else
#endif

#include <boost/test/unit_test.hpp>

#include "argparser.hpp"

BOOST_AUTO_TEST_SUITE(argparser_test)
BOOST_AUTO_TEST_CASE(parse_test) {
    const char *case1[2]{"day1", "--part1"};
    BOOST_TEST(parse_args(2, case1) == 1);
    const char *case2[2]{"day1", "--part2"};
    BOOST_TEST(parse_args(2, case2) == 2);
    const char *case3[1]{"day1"};
    BOOST_TEST(parse_args(2, case3) == 0);
    const char *case4[2]{"day6", "--wrong"};
    BOOST_TEST(parse_args(2, case4) == 0);
}
BOOST_AUTO_TEST_SUITE_END()
