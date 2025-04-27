#include <iostream>
using namespace std;

void Fmin(int a, int b, int c, int* min) {
    __asm {
        mov eax, a
        mov edx, b
        cmp eax, edx
        cmovg eax, edx

        mov edx, c
        cmp eax, edx
        cmovg eax, edx

        mov edx, min
        mov [edx], eax
    }
}

void Fmax(int a, int b, int c, int* max) {
    __asm {
        mov eax, a
        mov ebx, b
        cmp eax, edx
        cmovl eax, ebx

        mov edx, c
        cmp eax, edx
        cmovl eax, edx

        mov edx, max
        mov [edx], eax
    }
}

int main() {
    int a = 5, b = 25, c = 10;
    int min;
    Fmin(a, b, c, &min);
    int max;
    Fmax(a, b, c, &max);
    cout << "Minimalna wartosc: " << min << endl;
    cout << "Maksymalna wartosc: " << max << endl;
    
    return 0;
}
