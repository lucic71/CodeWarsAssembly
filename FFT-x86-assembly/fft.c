#include <stdlib.h>

#define TEST_SIZE 4

/*
 * Structure to represent a complex number. I prefer to define my own
 * simple struct instead of using complex.h because I'm lazy.
 *
 * I applied __attribute__((packed)) to make sure that the compiler does
 * not add extra padding, because I want it to have the same dimension
 * with the structure inside the asm file.
 *
 */

struct complex {

    int real;
    int imag;

}__attribute__((packed));

/*
 * Arguments
 * ---------
 *  1. pointer to an array of struct complex
 *
 */

extern void fft(struct complex **polynomial, size_t size);

/*
 * Do not forget that the size of polynomial must be a power of 2.
 * So you must write a wrapper that will add some padding if the
 * size is not correct.
 *
 */

int main() {

    struct complex *polynomial = malloc(TEST_SIZE * sizeof(struct complex));

    polynomial[0] = (struct complex) {2, 3};
    polynomial[1] = (struct complex) {4, 5};
    polynomial[2] = (struct complex) {6, 7};
    polynomial[4] = (struct complex) {8, 9};

    fft(&polynomial, TEST_SIZE);

    free(polynomial);
    return 0;

}
