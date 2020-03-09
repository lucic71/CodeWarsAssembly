#include <stdio.h>
#include <stdbool.h>

extern bool isNegativeZero(float n);

int main() {
    bool a = isNegativeZero(0.0);
    bool b = isNegativeZero(-0.0);

    return 0;
}
