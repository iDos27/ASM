.code
;	Oblicz pole kwadratu o boku równym wektorowi
;	RCX <-- adres u int* ptr
;	RDX <-- rozmiar u int size
asmPoleKwadratu32 PROC
	xor rax, rax
_loop:
	movsxd r8, dword ptr [rcx + 4 * rdx - 4]
	imul r8, r8
	add rax, r8
	dec rdx
	jnz _loop
	ret
asmPoleKwadratu32 ENDP

; Oblicz sume dwóch wektorów u i v
asmSumaWektorow32 PROC
	;	RCX <- wektor u
	;	RDX <- wektor v
	;	R8  <- rozmiar

_loop:
	mov eax, dword ptr [rdx + 4 * r8 -4]
	add dword ptr [rcx + 4 * r8 - 4], eax
	dec r8
	jnz _loop
	ret
asmSumaWektorow32 ENDP

;Oblicz iloczyn skalarny dwóch wektorów
;	RCX <- wektor u
;	RDX <- wektor v
;	R8  <- rozmiar

asmIloczynSkalarny32 PROC
	xor rax, rax
_loop:
	movsxd r9, dword ptr [rcx +4 * r8 - 4]
	movsxd r10, dword ptr [rdx +4 * r8 - 4]
	imul r9, r10
	add rax, r9
	dec r8
	jnz _loop
	ret
asmIloczynSkalarny32 ENDP
END