

#include <stdio.h>

extern int add(int a, int b);

int main(int argc, char** argv) {
    printf("a + b = %d", add(300, 20));
}