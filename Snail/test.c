#include <stdio.h>
#include <stdlib.h>

#define SIZE 3

extern int *snail(size_t *outsz, const int **mx, size_t m, size_t n);

int main() {
    int *matrix[SIZE];
    for (int i = 0; i < SIZE; i++) {
        matrix[i] = malloc(SIZE * sizeof(int));
    }

    int counter = 1;

    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            matrix[i][j] = (counter++);
        }
    }

    size_t size;

    int *result = snail(&size, (const int**)matrix, 3, 3);
    if (result == NULL) {
        puts("Error!");
    }

    printf("size is: %d\n", size);

    for (int i = 0; i < size; i++) {
        printf("%d ", result[i]);
    }

    free(result);
    return 0;
}

