#include <stdlib.h>

#define TEST_SIZE 3

/*
 * Structure to represent a complex number. I prefer to define my own
 * simple struct instead of using complex.h because I'm lazy.
 *
 */

struct complex {

    int a;
    int b;

};

/*
 * Arguments
 * ---------
 *  1. pointer to an array of struct complex
 *
 */

extern void fft(struct complex **polynomial);

int main() {

    struct complex *polynomial = malloc(TEST_SIZE * sizeof(struct complex));

    polynomial[0] = (struct complex) {1, 0};
    polynomial[1] = (struct complex) {1, 1};
    polynomial[2] = (struct complex) {0, 1};

    fft(&polynomial);

    free(polynomial);
    return 0;

}
