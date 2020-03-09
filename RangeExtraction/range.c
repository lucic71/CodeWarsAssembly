#include <stdio.h>

extern char *range_extraction(const int *args, size_t n);

int main() {
    char *result = range_extraction((const int []){ -3,-2,-1,2,10,15,16,18,19,20 }, 10);
    printf("%s\n", result);

    return 0;
}
