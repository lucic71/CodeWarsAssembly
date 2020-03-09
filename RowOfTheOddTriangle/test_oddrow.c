#include <stdio.h>

extern unsigned long long *oddrow(int row);

int main() {
    unsigned long long *row = oddrow(2001);

    for (int i = 0; i < 2001; i++) {
        printf("%llu\n", row[i]);
    }

    return 0;

}
