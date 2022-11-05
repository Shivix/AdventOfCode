add_executable(aoclib-test
    argparser_test.cpp
    ifstream_iterator_test.cpp
)

find_package(Boost REQUIRED COMPONENTS system)

target_compile_options(aoclib-test PRIVATE -Wall -Wextra -Wpedantic -Werror)
target_compile_features(aoclib-test PRIVATE cxx_std_20)
target_link_libraries(aoclib-test PRIVATE -lboost_unit_test_framework)
target_include_directories(aoclib-test PRIVATE ${PROJECT_SOURCE_DIR}/aoclib ${Boost_INCLUDE_DIRS})

configure_file("input" ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)

add_test(aoclibTest aoclib-test)
