#include <stdio.h>
#include <stdlib.h>

extern const char *automorphic(unsigned int num);

int main(int argc, char **argv) {
    char *string = automorphic(atoi(argv[1]));
    printf("%s\n", string);

    return 0;
}
