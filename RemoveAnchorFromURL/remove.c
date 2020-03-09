#include <stdio.h>
#include <stdlib.h>

extern char* rmurlahr(char *url);

int main() {
    char *modified_url = rmurlahr("www.codewars.com");
    printf("%s\n", modified_url);

    free(modified_url);
    return 0;
}
