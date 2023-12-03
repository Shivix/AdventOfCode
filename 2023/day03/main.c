#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <regex.h>

#define MAX_CHARS 200
typedef char Line[MAX_CHARS];

int max(int a, int b) {
    return (a > b) ? a : b;
}

int main(void) {
    FILE* file = fopen("input", "r");
    if (file == NULL) {
        fprintf(stderr, "Failed to compile regex");
        return 1;
    }

    int part1 = 0;
    int part2 = 0;
    Line line = {'\0'};

    while (fgets(line, MAX_CHARS, file) != NULL) {
        
    }

    printf("part1: %i part2: %i", part1, part2);

    fclose(file);
}
