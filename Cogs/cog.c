#include <stdio.h>

extern double cog_rpm(const int cogs[], unsigned count);

int main() {
    int cogs[] = {70, 38, 12};
    double rpm = cog_rpm(cogs, 3);

    printf("%f\n", rpm);
    return 0;
}
