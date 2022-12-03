cmake_minimum_required(VERSION 3.16)
project(AdventOfCode)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

add_subdirectory(days)

enable_testing()
add_subdirectory(aoclib)
