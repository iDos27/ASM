; Suma wektorow 32
asmSumVecVec32 PROC
; RCX	= w
; RDX	= v
; R8	= m

_loop:
	cmp r8, 0
	je _koniec
	mov r10d, dword ptr [rcx + 4 * r8 - 4]	; RSI = w[i]
	mov r11d, dword ptr [rdx + 4 * r8 - 4]	; RDI = v[i]
	add r10d, r11d
	mov dword ptr [rcx + 4 * r8 - 4], r10d
	dec r8
	jnz _loop

_koniec:
	ret
asmSumVecVec32 ENDP

; Suma wektorow 64

asmSumVecVec64 PROC
; RCX = w
; RDX = v
; R8 = i
_loop:
	cmp r8, 0
	je _koniec
	mov r10, qword ptr [rcx + 8 * r8 - 8]
	mov r11, qword ptr [rdx + 8 * r8 - 8]
	add r10, r11
	mov qword ptr [rcx + 8 * r8 - 8], r10
	dec r8
	jnz _loop
_koniec:
ret
asmSumVecVec64 ENDP

; Macierz 3 stopnia mod 8

asmModTab3D PROC USES rsi rdi rbx
; RCX = tab
; RDX = n
; R8 = m
; R9 = k
_loop_i:
	cmp rdx, 0
	je _end
	mov rsi, qword ptr [rcx + 8 * rdx - 8]	;tab[i]

	mov r10, r8
	_loop_j:
		cmp r10d, 0
		je _next_i
		mov rdi, qword ptr [rsi + 8 * r10 - 8] ;tab[i][j]

		mov r11, r9
		_loop_k:
			cmp r11, 0
			je _next_j
			mov eax, dword ptr[rdi + 4 * r11 - 4]; tab[i][j][k]
			and eax, 7 ; modulo z liczby ktora jest potega dwojki to and eax, mod-1
			mov dword ptr [rdi + 4 * r11 - 4], eax

			dec r11
			jmp _loop_k
		_next_j:
			dec r10
			jmp _loop_j
	_next_i:
		dec rdx
		jmp _loop_i

_end:
	ret
asmModTab3D ENDP
