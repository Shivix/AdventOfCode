#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <regex.h>

#define MAX_CHARS 200
typedef char Line[MAX_CHARS];

int max(int a, int b) {
    return (a > b) ? a : b;
}

regex_t init_regex(const char* pattern) {
    regex_t regex;
    if (regcomp(&regex, pattern, REG_EXTENDED)) {
        perror("Failed to compile regex");
        exit(1);
    }
    return regex;
}
void copy_match_string(char* out, char* line, regmatch_t match) {
    strncpy(out, line + match.rm_so, match.rm_eo - match.rm_so);
}

int main(void) {
    FILE* file = fopen("input", "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    Line line = {'\0'};
    regex_t game_regex = init_regex("Game ([0-9]+):");
    regex_t reveal_regex = init_regex("([0-9]+) ([a-zA-Z]+)");
    int part1 = 0;
    int part2 = 0;

    while (fgets(line, MAX_CHARS, file) != NULL) {
        size_t n_id_matches = 2;
        regmatch_t id_matches[2];
        char match[4] = {'\0'};
        regexec(&game_regex, line, n_id_matches, id_matches, 0);
        copy_match_string(match, line, id_matches[1]);

        int id = atoi(match);
        int red = 0;
        int green = 0;
        int blue = 0;

        size_t max_matches = 3;
        regmatch_t matches[3];
        char* line_pos = line;
        while (regexec(&reveal_regex, line_pos, max_matches, matches, 0) == 0) {
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
    return 0;
}
