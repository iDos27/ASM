#include <iostream>
using namespace std;
// (32) Program zwracajcy numer indeksu pierwszego wystąpienia danego znaku
int find_cpp(char* tab, char znak)
{
	int n = 0, poz;
	while (tab[n])
		if (tab[n++] == znak)
		{
			poz = n;
			break;
		}
	return --poz;
}

int find_asm(char* tab,int n, char znak) {
	int poz;
	__asm {
		pushfd;
		xor eax, eax;
		mov al, znak;
		mov edi, tab;
		mov ecx, n;
		cld;
		repne scasb;
		mov eax, n;
		sub eax, ecx;
		dec eax;
		mov poz, eax;
		popfd;
	}
	return poz;
}
// (32) Program usuwający prawe spacje z łańcucha znaków
char* del_space_r(char* tab, int n)
{
	__asm {
		pushfd;
		xor eax, eax;
		mov edi, tab;
		mov ecx, n;
		cld;
		repne scasb;
		sub edi, 2;
		std;
		mov ecx, n;
		mov al, 32;
		repe scasb;
		add edi, 2;
		mov[edi], 00h;
		popfd;
	}
	return tab;
}

// NIE DZIAŁA!!!!!!!!!!!!!!!
// (32) Program usuwający lewe spacje z łańcucha znaków
char* del_space_l(char* tab, int n)
{
	__asm {
		pushfd;
		xor eax, eax;
		mov edi, tab;
		mov ecx, n;
		std;
		repne scasb;
		sub edi, 2;
		cld;
		mov ecx, n;
		mov al, 32;
		repe scasb;
		add edi, 2;
		mov[edi], 00h;
		popfd;
	}
	return tab;
}
// (32) Funkcja kopiująca łańcuch znaków z Tab1 do Tab2
char* kopiuj_lancuch(char* tab1, char* tab2) {
	__asm {
		pushfd;
		xor eax, eax;
		mov edi, tab2;
		mov esi, tab1;

	kopiuj:
		lodsb;
		stosb;
		test al, al;
		jnz kopiuj;

		popfd;
	}
}
// (32) Funkcja kopiująca łańcuch od indeksu X do Y
void kopiuj_lancuch_od_do(char* tab1, char* tab2, int X, int Y) {
	__asm {
		pushfd
		xor eax, eax;
		mov edi, tab2;
		mov esi, tab1;
		mov ecx, Y;
		mov edx, X;

		// Skok do indeksu X
		add esi, edx;

		// Kopiowanie znaków
	kopiuj:
		cmp edx, ecx;
		jg koniec;
		lodsb;
		stosb;
		inc edx;
		jmp kopiuj;

	koniec:
		mov[edi], 0;
		popfd;
	}
}

void licz_2022(const unsigned short* tab, int* wynik, int size) {
    __asm {
        pushfd;
        mov edi, tab;        // EDI = adres tablicy
        mov ecx, size;       // ECX = liczba elementów
        mov ax, 2022;        // AX = szukana wartość 2022
        xor ebx, ebx;        // EBX = licznik wystąpień = 0

    petla:
        repne scasw;         // szukaj 2022 w tablicy, zmniejszając ECX
        jne koniec;          // jeśli ECX = 0 i nie znaleziono, koniec
        inc ebx;             // znaleziono 2022 -> inkrementuj licznik
        jmp petla;           // szukaj dalej

    koniec:
        mov edx, wynik;      // EDX = adres wyniku
        mov [edx], ebx;      // zapisz licznik do *wynik
        popfd;
    }
}

int main() {
	// Pierwsze wystąpienie znaku
	char tab[] = "helllo world!";
	char znak = 'o';

	int wynik_cpp = find_cpp(tab,znak);
	int wynik_asm = find_asm(tab,13,znak);

	cout << "find_cpp: " << wynik_cpp << endl;
	cout << "find_asm: " << wynik_asm << endl;
	//////////////////////////////////////////////
	cout << endl << "Usuwanie prawych spacji:" << endl;
	char tekst[100] = "Hello world!        ";
	cout << "Przed: " << tekst << ";" << endl;
	int dlugosc = strlen(tekst) + 1;
	del_space_r(tekst, dlugosc);
	cout << "Po: " << tekst << ";" << endl;

	cout << endl << "Usuwanie lewych spacji:" << endl;
	char tekst2[100] = "         Hello world";
	cout << "Przed: " << tekst2 << ";" << endl;
	del_space_l(tekst2, dlugosc);
	cout << "Po: " << tekst2 << ";" << endl;

	////////////////////////////////////
	cout << endl << "Kopiowanie calosci: " << endl;
	char tab1[] = "Dzien doberek :3";
	char tab2[] = "Zla nocka :(";
	cout << "Przed: " << tab1 << endl << tab2 << endl;
	kopiuj_lancuch(tab1, tab2);
	cout << "Po: " << tab1 << endl << tab2 << endl;
	
	///////////////////////////////////
	cout << endl << "Kopiowanie od-do:" << endl;
	char tab3[] = "Witam siema yo";
	char tab4[50];
	int X = 6;
	int Y = 10;
	kopiuj_lancuch_od_do(tab3, tab4, X, Y);
	cout << "Tab2: " << tab4 << endl;

	return 0;
}