#include <stdio.h>
#include <stdlib.h>

void interpret(const char* code, char* output);

int main() {
    char result[100];
    char code[100];

    for (int i = 0; i < 0x42; i++) {
        code[i] = '+';
    }
    code[0x41] = 'S';
    code[0x42] = '.';
    code[0x43] = 0;

    interpret(code, result);
    printf("%s\n", result);
    return 0;
}
