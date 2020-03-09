#include <stdio.h>
#include <stdlib.h>

long long *wheat_from_chaff(const long long *crops, size_t count);

int main() {
    const long long crops[10] = {-25,-48,-29,-25,  1, 49,-32,-19,-46,  1 };
    size_t count = sizeof(crops)/sizeof(long long);

    long long *result = wheat_from_chaff(crops, count);
    if (result == NULL) {
        puts("Error!");
        return -1;
    }

    for (size_t i = 0; i < count; i++) {
        printf("%lld ", result[i]);
    }
    puts("");

    free(result);
    return 0;
}

