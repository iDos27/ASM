#include <iostream>
using namespace std;

void addBCD(char* numberIN1, char* numberIN2, char* numberOUT, int Size)
{
    int size_copy = Size;
    __asm {
        push ebx;
        mov ecx, size_copy;
        mov esi, numberIN1;
        mov edi, numberIN2;
        mov ebx, numberOUT;
 
        clc;    
    petla: 
        mov al, [esi + ecx - 1];
        adc al, [edi + ecx - 1];
        aaa;
        mov [ebx + ecx - 1], al;
        dec ecx;
        jnz petla;
        pop ebx;
    }
}

void subBCD(char* numberIN1, char* numberIN2, char* numberOUT, int Size)
{
    int size_copy = Size;
    __asm {
        push ebx;
        mov ecx, size_copy;
        mov esi, numberIN1;
        mov edi, numberIN2;
        mov ebx, numberOUT;
 
        clc;    
    petla: 
        mov al, [esi + ecx - 1];
        sbb al, [edi + ecx - 1];
        aas;
        mov [ebx + ecx - 1], al;
        dec ecx;
        jnz petla;
        pop ebx;
    }
}


int main() {
    const int size = 4; // 4 cyfry = liczby 1234 + 5678
    char num1[size] = { 0x01, 0x02, 0x03, 0x04 }; // 1234
    char num2[size] = { 0x05, 0x06, 0x07, 0x08 }; // 5678
    char result[size] = { 0 };

    addBCD(num1, num2, result, size);

    cout << "Wynik dodawania BCD: ";
    bool leadingZero = true;
    for (int i = 0; i < size; i++) {
        int digit = result[i] & 0x0F; // tylko dolna część AL
        if (digit != 0 || !leadingZero || i == size - 1) {
            cout << digit;
            leadingZero = false;
        }
    }
    cout << endl;

    return 0;
}