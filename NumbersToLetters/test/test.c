#include <stdio.h>

int main() {
    const char* v[3] = {"26", "26", "29"};

    for (int i = 0; i < 3; i++) {
        char *string = v[i];
        printf("%s\n", string);
    }

    return 0;
}
