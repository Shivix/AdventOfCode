#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <regex.h>

#define MAX_CHARS 200
typedef char Line[MAX_CHARS];

int max(int a, int b) {
    return (a > b) ? a : b;
}

void copy_match_string(char* out, char* line, regmatch_t match) {
    strncpy(out, line + match.rm_so, match.rm_eo - match.rm_so);
}

int main(void) {
    FILE* file = fopen("input", "r");
    if (file == NULL) {
        fprintf(stderr, "Failed to compile regex");
        return 1;
    }

    int part1 = 0;
    int part2 = 0;
    int id = 0;
    Line line = {'\0'};
    regex_t regex;
    if (regcomp(&regex, "([0-9]+) ([a-z]+)", REG_EXTENDED)) {
        fprintf(stderr, "Failed to compile regex");
        return 1;
    }

    while (fgets(line, MAX_CHARS, file) != NULL) {
        ++id;
        int red = 0;
        int green = 0;
        int blue = 0;

        size_t max_matches = 3;
        regmatch_t matches[3];
        char* line_pos = line;
        while (regexec(&regex, line_pos, max_matches, matches, 0) == 0) {
            char colour[10] = {'\0'};
            char amount[10] = {'\0'};
            copy_match_string(amount, line_pos, matches[1]);
            copy_match_string(colour, line_pos, matches[2]);
            if (strcmp(colour, "red") == 0) {
                red = max(red, atoi(amount));
            } else if (strcmp(colour, "green") == 0) {
                green = max(green, atoi(amount));
            } else if (strcmp(colour, "blue") == 0) {
                blue = max(blue, atoi(amount));
            }
            line_pos += matches[0].rm_eo;
        }
        if (red <= 12 && green <= 13 && blue <= 14) {
            part1 += id;
        }
        part2 += red * green * blue;
    }

    printf("part1: %i part2: %i", part1, part2);

    fclose(file);
}
