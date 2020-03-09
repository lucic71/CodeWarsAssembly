#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int main() {

    char *str;
    asprintf(&str, "%d", 112);
    printf("%s\n", str);
    free(str);

    return 0;
}
