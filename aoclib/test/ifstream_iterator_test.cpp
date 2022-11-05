#include <boost/test/unit_test.hpp>

#include "ifstream_iterator.hpp"

BOOST_AUTO_TEST_SUITE(ifstream_iterator_test)
BOOST_AUTO_TEST_CASE(vector_test) {
    std::ifstream test_stream{"/home/shivix/CppProjects/AdventOfCode/aoclib/test/input"};
	const std::vector<std::string> test_data{IfstreamIterator{test_stream}, {}};   
    BOOST_TEST(test_data[0] == "forward 6");
    BOOST_TEST(test_data[1] == "down 3");
    BOOST_TEST(test_data[2] == "forward 8");
    BOOST_TEST(test_data[3] == "down 5");
    BOOST_TEST(test_data[4] == "forward 9");
}
BOOST_AUTO_TEST_SUITE_END()
