#include <stdio.h>

struct intvl;
extern int sumintvls(const struct intvl *v, size_t n);

struct intvl {
    int first;
    int second;
};

int main() {

    int x = sumintvls((const struct intvl[]){{1, 5}}, 1);
    printf("%d\n", x);

    return 0;
}

