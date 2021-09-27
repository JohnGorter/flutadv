
#include <iostream>
#include <stdio.h>

using namespace std;

extern "C" __attribute__((visibility("default"))) int test = 0;

extern "C" __attribute__((visibility("default"))) int add(int a, int b)  {
    return a  + b;
}

int main(int args, char** vargs){
    cout << "Hello world!" << endl;
    cout << add(10,10) << endl;
}
