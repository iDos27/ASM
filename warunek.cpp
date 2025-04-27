#include <iostream>

using namespace std;

void if_1(int a, int b, int& x) {
	if (a < b)
		x = b - a;
}
void if_1_skok(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;
		cmp eax, ebx;
		jge pomin;
		sub ebx, eax;
		mov[edx], ebx;
	pomin:
	}
}
void if_1_cmov(int a, int b, int& x) {
	__asm {
		mov eax, a;		// eax = a
		mov ebx, b;		// ebx = b
		mov edx, x;		// edx = x
		mov esi, b;

		sub ebx, eax;	// ebx = b - a
		mov ecx, 0;		// x = 0
		cmp eax, esi;		// porównanie
		cmovl ecx, ebx;	// jeśli a < b, to x = b - a
		mov[edx], ecx;	// wysłanie wyniku
	
		cmp eax, ebx;
		cmovge eax, ebx;
		sub eax, a;
		mov[edx], ecx;
	}
}

void if_2(int a, int b, int& x) {
	if (a < b)
		x = b - a;
	else
		x = a - b;
}
void if_2_skok(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;
		cmp eax, ebx;
		jge wieksze;
		sub ebx, eax;
		mov[edx], ebx;
		jmp koniec;
	wieksze:
		sub eax, ebx;
		mov[edx], eax;
	koniec:
	}
}
void if_2_cmov(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;

		mov esi, ebx;
		sub esi, eax; // b-a
		mov edi, eax;
		sub edi, ebx; // a-b

		cmp eax, ebx;
		cmovl eax, esi;
		cmovge eax, edi;

		mov[edx], eax;
	}
}

void if_3(int a, int b, int& x) {
	if (a < b)
		x = b * b - a;
}
void if_3_skok(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;
		cmp eax, ebx;
		jge pomin;
		imul ebx, ebx;
		sub ebx, eax;
		mov[edx], ebx;
	pomin:

	}
}
void if_3_cmov(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;
		
		cmp eax, ebx;
	}
}

void if_4(int a, int b, int& x) {
	if (a < b)
		x = a * a + b;
	else
		x = a * a - b;
}
void if_4_skok(int a, int b, int& x) {
	__asm {
		mov eax, a;
		mov ebx, b;
		mov edx, x;
		cmp eax, ebx;
		jge wieksza;
		imul eax, eax;
		add eax, ebx;
		mov[edx], eax;
		jmp koniec;
	wieksza:
		imul eax, eax;
		sub eax, ebx;
		mov[edx], eax;
	koniec:

	}
}
void if_4_cmov(int a, int b, int& x) {
	__asm {
		mov eax, a
		mov ebx, b
		mov edx, x

		mov ecx, a
		imul ecx, ecx; //ecx = a * a

		mov esi, ecx; //kopia a* a
		add esi, ebx; //esi = a * a + b

		mov edi, ecx; //kopia a* a
		sub edi, ebx; //edi = a * a - b

		cmp eax, b

		cmovl eax, esi; //jeśli a < b, to eax = a * a + b
		cmovge eax, edi; //jeśli a >= b, to eax = a * a - b

		mov[edx], eax
	}
}

int main() {
	int a = 13;
	int b = 12;
	int x = 0;
	cout << "#####################################" << endl;
	if_1(a, b, x);
	cout << "Wynikiem if_1 jest:" << x << endl;
	x = 0;
	if_2(a, b, x);
	cout << "Wynikiem if_2 jest:" << x << endl;
	x = 0;
	if_3(a, b, x);
	cout << "Wynikiem if_3 jest:" << x << endl;
	x = 0;
	if_4(a, b, x);
	cout << "Wynikiem if_4 jest:" << x << endl;
	////////////////////////////////////////////
	x = 0;
	cout << "#####################################" << endl;
	if_1_skok(a, b, x);
	cout << "Wynikiem if_1_skok jest:" << x << endl;
	x = 0;
	if_2_skok(a, b, x);
	cout << "Wynikiem if_2_skok jest:" << x << endl;
	x = 0;
	if_3_skok(a, b, x);
	cout << "Wynikiem if_3_skok jest:" << x << endl;
	x = 0;
	if_4_skok(a, b, x);
	cout << "Wynikiem if_4_skok jest:" << x << endl;
	///////////////////////////////////////////
	x = 0;
	cout << "#####################################" << endl;
	if_1_cmov(a, b, x);
	cout << "Wynikiem if_1_cmov jest:" << x << endl;
	x = 0;
	if_2_cmov(a, b, x);
	cout << "Wynikiem if_2_cmov jest:" << x << endl;
	x = 0;
	if_3_cmov(a, b, x);
	cout << "Wynikiem if_3_cmov jest:" << x << endl;
	x = 0;
	if_4_cmov(a, b, x);
	cout << "Wynikiem if_4_cmov jest:" << x << endl;
	cout << "#####################################" << endl;
}