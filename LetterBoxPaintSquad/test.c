#include <stdio.h>
#include <stdlib.h>

extern int *paint_letterboxes(int start, int end);

int main() {
    int *result = paint_letterboxes(125, 132);

    if (result == NULL) {
        puts("Error");
        return -1;
    }

    for (int i = 0; i < 10; i++) {
        printf("%d ", result[i];
    }
    puts("");

    free(result);
    return 0;
}
