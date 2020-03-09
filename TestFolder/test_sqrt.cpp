#include <iostream>
#include <vector>

int* foo() {
    return nullptr;
}

int main() {
    int *var = foo();

    return 0;
}
