cmake_minimum_required(VERSION 3.16)
project(AdventOfCode)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_CXX_STANDARD 20)

add_subdirectory(2022)
add_subdirectory(2023)

enable_testing()
add_subdirectory(aoclib)
