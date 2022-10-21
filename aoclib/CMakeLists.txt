add_library(aoclib INTERFACE)
target_compile_features(aoclib INTERFACE cxx_std_20)
target_compile_options(aoclib INTERFACE -Wall -Wextra -Wpedantic -Werror)

add_subdirectory(test)
