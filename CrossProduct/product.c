#include <stdio.h>

double* crossprod(const double *v1, const double *v2,
                size_t len1, size_t len2);

void print_vector(double *v) {
    for (int i = 0; i < 3; i++) {
        printf("%lf ", v[i]);
    }
    puts("");
}

int main() {
    double v1[3] = {3, 2, 1};
    double v2[3] = {1, 2, 3};

    double* prod = crossprod(v1, v2, 3, 3);

    if (prod == NULL) {
        puts("Either the vectors are NULL or the length is not correct!");
        return -1;
    }

    print_vector(v1);
    print_vector(v2);
    puts("");
    print_vector(prod);

    return 0;
}
