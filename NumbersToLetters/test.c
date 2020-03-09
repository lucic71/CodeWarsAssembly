#include <stdio.h>
#include <stdlib.h>

extern char* num2alpha(const char** codes, size_t n);

int main() {
    char *result =
        num2alpha((const char *[]){ "26", "26", "29", "28" }, 4ul);

    printf("%s\n", result);

    free(result);
    return 0;
}
