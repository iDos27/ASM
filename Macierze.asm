.code
;	SUMA ELEMENTÓW W MACIERZY JAK W SRODKU SĄ int
;	RCX <- int ** A
;	RDX <- int	rows
;	R8  <- int	cols
asmSumElems32 PROC USES rsi
	xor rax, rax								; RAX <- 0
_rows_loop:
	mov rsi, qword ptr[rcx + 8 * rdx - 8]		; RSI <- A[i]
	mov r10, r8									; R10 <- j
_cols_loop:
	movsxd r11, dword ptr[rsi + 4 * r10 - 4]	; R11 <- (INT64) A[i][j]
	add rax, r11								; RAX <- RAX + R11
	dec r10										; R10 <- j--
	jnz _cols_loop
	dec rdx										; RDX <- i--
	jnz _rows_loop
	ret
asmSumElems32 ENDP

;	SUMA ELEMENTÓW W MACIERZY JAK W SRODKU SĄ INT64
;	RCX <- INT64**
;	RDX <- int	rows
;	R8  <- int	cols
asmSumElems64 PROC USES rsi
	xor rax, rax								; RAX <- 0
_rows_loop:
	mov rsi, qword ptr[rcx + 8 * rdx - 8]		; RSI <- A[i]
	mov r10, r8									; R10 <- j
_cols_loop:
	add rax, qword ptr[rsi + 8 * r10 - 8]	; RAX <- RAX + A[i][j]
	dec r10										; R10 <- j--
	jnz _cols_loop
	dec rdx										; RDX <- i--
	jnz _rows_loop
	ret
asmSumElems64 ENDP

;	DODAWANIE DWÓCH MACIERZY
;	RCX  <- int ** W
;	RDX  <- int ** A
;	R8	 <- int ** B
;	R9	 <- int		rows
;	stos <- int		cols
asmAddMatMat32 PROC USES rbx rsi rdi, W:qword, A:qword, B:qword, rows:dword, cols:dword
	movsxd r10, cols
_rows_loop:
	mov rdi, qword ptr[rcx + 8 * r9 - 8]	; RDI <- W[i]
	mov rsi, qword ptr[rdx + 8 * r9 - 8]	; RSI <- A[i]
	mov rbx, qword ptr[r8  + 8 * r9 - 8]	; RBX <- B[i]
	mov r11, r10							; R11 <- j
_cols_loop:
	mov eax, dword ptr[rsi + 4 * r11 - 4]	; EAX <- A[i][j]
	add eax, dword ptr[rbx + 4 * r11 - 4]	; EAX <- A[i][j] + B[i][j]
	mov dword ptr[rdi + 4 * r11 - 4], eax	; W[i][j] <- A[i][j] + B[i][j]
	dec r11									; j--
	jnz _cols_loop
	dec r9									; i--
	jnz _rows_loop
	ret
asmAddMatMat32 ENDP


; Iloczyn Macierzy i Wektora
;	RCX		<- int  * w
;	RDX		<- int ** A
;	R8		<- int  * b
;	R9		<- int	rows
;	stos	<- int cols
asmMulMatVec32 PROC USES rbx rsi, w:qword, A:qword, b:qword, rows:dword, cols:dword
	movsxd r10, cols
_rows_loop:
	mov rsi, qword ptr[rdx + 8 * r9 - 8]		; RSI <- A[i]
	mov rbx, r10								; RBX <- cols
	xor r11, r11								; R11 <- wynik
_cols_loop:
	mov eax, dword ptr[rsi + 4 * rbx - 4]		; EAX <- A[i][j]
	imul eax, dword ptr[r8 + 4 * rbx - 4]		; EAX <- A[i][j] * b[j]
	add r11d, eax								; R11 <- A[i][j] * b[j]
	dec rbx										; --j
	jnz _cols_loop
	mov dword ptr[rcx + 4 * r9 - 4], r11d		; W[i] <- R11
	dec r9										; --i
	jnz _rows_loop

	ret
asmMulMatVec32 ENDP

; MNOZENIE MACIERZY
; RCX	<- int ** W
; RDX	<- int ** A
; R8 	<- int ** B
; R9	<- int    aRows
; stos	<- int	  common
; stos	<- int	  bCols
asmMulMatMat32 PROC USES rbx rsi rdi r12 r13, W:qword, A:qword, B:qword, aRows:dword, common:dword, bCols:dword
	movsxd r10, common
	movsxd r11, bCols
_aRows_loop:
	mov rsi, qword ptr[rdx + 8 * r9 - 8]
	mov rdi, qword ptr[rcx + 8 * r9 - 8]
	mov r12, r11
_bCols_loop:
	xor eax, eax
	mov r13, r10
_common_loop:
	mov rbx, qword ptr[r8 + 8 * r13 - 8]
	mov ebx, dword ptr[rbx + 4 * r12 - 4]		; EBX <- A[i][j]
	imul ebx, dword ptr[rsi + 4 * r13 - 4]		; EBX <- A[i][k] * B[k][j]
	add eax, ebx								; EAX += A[i][k] * B[k][j]
	dec r13
	jnz _common_loop
	mov dword ptr[rdi + 4 * r12 - 4], eax		; W[i][j] = EAX
	dec r12										; j--
	jnz _bCols_loop
	dec r9										; i--
	jnz _aRows_loop
	ret
asmMulMatMat32 ENDP

; Zerowanie przekątnej macierzy int32
; RCX <- int** W
; RDX <- int   rows
; R8  <- int   cols
asmZeroMat32 PROC USES rsi, W:qword, rows:dword, cols:dword
	mov r9, rdx				; r9 = rows
_rows_loop:
	cmp r9, 0
	je _done

	mov rsi, qword ptr [rcx + 8 * r9 - 8]	; rsi = W[i]
	
	; Zeruj tylko W[i][i]
	mov dword ptr [rsi + 4 * r9 - 4], 0

	dec r9					; i--
	jmp _rows_loop

_done:
	ret
asmZeroMat32 ENDP

; Ustawianie 0 na przekątnej, a reszta to 1
; RCX <- int** W
; RDX <- int   rows
; R8  <- int   cols
asmZeroOneMat32 PROC USES rsi, W:qword, rows:dword, cols:dword
	mov r9, rdx				; r9 = rows
_rows_loop:
	cmp r9, 0
	je _done

	mov rsi, qword ptr [rcx + 8 * r9 - 8]	; rsi = W[i]

	mov r10, r8				; r10 = cols
_cols_loop:
	cmp r10, 0
	je _next_row

	; Sprawdzamy, czy jesteśmy na przekątnej
	cmp r9, r10
	je _on_diag		; Jeśli i == j, przejdź do ustawiania przekątnej

	; Jeśli nie na przekątnej, ustaw 1
	mov dword ptr [rsi + 4 * r10 - 4], 1
	jmp _next_col

_on_diag:
	mov dword ptr [rsi + 4 * r10 - 4], 0

_next_col:
	dec r10					; j--
	jnz _cols_loop

_next_row:
	dec r9					; i--
	jnz _rows_loop

_done:
	ret
asmZeroOneMat32 ENDP


END