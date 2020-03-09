#include <stdio.h>

extern char *duration(long seconds);

int main() {
    char *date= duration(0);
    *date= duration(1);
    *date= duration(3600);
    return 0;
}
