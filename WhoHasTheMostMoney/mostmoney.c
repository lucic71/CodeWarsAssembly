#include <stdio.h>

struct student;
extern const char *mostmoney(const struct student *v, size_t n);

struct student {
    char name[9];
    unsigned fives;
    unsigned tens;
    unsigned twenties;
};

int main() {
    const char *result = mostmoney((const struct student[]){ {"Cameron", 2, 2, 0},
        {"Geoff", 0, 3, 0} }, 2);


    printf("%s\n", result);
    return 0;
}
