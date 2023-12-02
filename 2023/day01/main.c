#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX_CHARS 100
typedef char Line[MAX_CHARS];

int part1(Line line, size_t i) {
    if (isdigit(line[i])) {
        return line[i] - '0';
    }
    return 0;
}

int part2(Line line, size_t i) {
    if (isdigit(line[i])) {
        return line[i] - '0';
    }
    Line word = {'\0'};
    size_t j = 0;
    while (line[i] != '\0') {
        word[j++] = line[i++];
        if (strcmp(word, "one") == 0) {
            return 1;
        }
        if (strcmp(word, "two") == 0) {
            return 2;
        }
        if (strcmp(word, "three") == 0) {
            return 3;
        }
        if (strcmp(word, "four") == 0) {
            return 4;
        }
        if (strcmp(word, "five") == 0) {
            return 5;
        }
        if (strcmp(word, "six") == 0) {
            return 6;
        }
        if (strcmp(word, "seven") == 0) {
            return 7;
        }
        if (strcmp(word, "eight") == 0) {
            return 8;
        }
        if (strcmp(word, "nine") == 0) {
            return 9;
        }
    }
    return 0;
}

int main(int argc, char* argv[]) {
    FILE* file = fopen("input", "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    int (*is_digit)(Line, size_t) = part1;
    if (argc == 2 && strcmp(argv[1], "--part2") == 0) {
        is_digit = part2;
    }

    Line line = {'\0'};
    int result = 0;

    while (fgets(line, MAX_CHARS, file) != NULL) {
        printf("%s", line);
        int first;
        int second;
        size_t i = 0;
        do {
            first = is_digit(line, i++);
        } while (!first);
        for (i = 0; line[i + 1] != '\0'; ++i) {
            int value = is_digit(line, i);
            if (value) {
                second = value;
            }
        }
        printf("val: %i%i\n", first, second);
        result += first * 10 + second;
    }

    printf("%i", result);

    fclose(file);
    return 0;
}
