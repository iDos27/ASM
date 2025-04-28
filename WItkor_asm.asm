.CODE
bezwzgledna PROC
;RCX - a
mov rax, rcx;
test rax, rax;
jns dodatnia;
neg rax;
dodatnia:
add rax, rcx;
ret;

bezwzgledna ENDP

ifnojump PROC uses rbx rdi, a:qword, b:qword, x:qword, y:qword
;RCX = a
;RDX = b
;R8 = x
;R9 = y
mov rbx, rcx;
imul rbx, rdx;
add rbx, r8;
mov rdi, rcx;
imul rdi, rdx;
sub rdi, r8;
cmp r8,100;
mov rax, rbx;
cmovg rax,rdi;
mov [r9], rax;
ret;
ifnojump ENDP

mymul64 PROC a:qword, b:qword, c:qword, d:qword, e:qword, f:qword
;RCX = a
;RDX = b
;R8 = c
;R9 = d
;stos = e,f
mov r11, f;R11 = f
mov r12, e;;R12 = e
mov rax, rcx;
imul rax, rdx; a*b
imul r8,2; 2c
imul r9, 4; 4d
imul r8,r9; 2c*4d
add rax, r8; ab+2c*4d
imul r12,8; 8e
imul r11,16; 16f
imul r12, r11; 8e*16f
add rax, r12; ab+2c*4d+8e*16f
ret;
mymul64 ENDP

ifnojump2 PROC a:qword, b:qword
;RCX = a
;RDX = b
mov r10, rdx; b
imul r10, r10; b*b
mov r8,rcx; a
sub r8, r10; a-b*b
mov r9, r10; b*b
sub r9, rcx; b*b - a
cmp rcx, rdx;
mov rax, r8;
cmovl rax, r9;
ret;
ifnojump2 ENDP

howmany PROC tab:ptr, val:qword, y:qword
;RCX = *tab
;RDX = val
;R8 = y
xor r9, r9;
lea rsi, [rcx];
mov rbx, 100;
xor rax, rax;
cld;
petla:
lodsd;
cmp rax, rdx;
je found;
jmp not_found;
found:
inc r9;
not_found:
dec rbx;
jnz petla;
mov [r8], r9;
ret;
howmany ENDP

fun64 PROC a:qword, b:qword, c:qword, d:qword, e:qword, f:qword, g:qword, h:qword
;RCX = a
;RDX = b
;R8 = c
;R9 = d
;stos = e,f,g,h
mov r14, rdx;
mov r13,h;
mov r12, g;
mov r11, f;
mov r10, e;
mov rax, rcx; a
imul rax; a*a
imul rax, r14; aa*b
mov rbx, rax; kopia dla dzielenia
xor rdx, rdx; czysci do modulo
mov rax, r8;
idiv r9; c/d reszta w rdx
mov rax, rbx; przywrocenie
add rax, rdx;
add r10, r11;
add r12, r13;
mov rbx, rax;
mov rax, r10;
xor rdx, rdx; czysci do modulo
idiv r12;
mov rdx, rax; przeniesienie wyniku
mov rax, rbx; przywrocenie
sub rax, rdx;
ret;
fun64 ENDP

tcp PROC tab:ptr, n:qword
;RCX = tab
;RDX = n (liczba elementow)
lea rsi, [rcx];
lea rdi, [rcx];
petla:
lodsd;
mov rax,3;
stosd;
dec rdx;
jz skip;
lodsd;
mov rax,4;
stosd;
dec rdx;
jz skip;
lodsd;
mov rax,5;
stosd;
dec rdx;
jnz petla;
skip:
ret;
tcp ENDP

ifnojump3 PROC a:qword, b:qword
;RCX = a
;RDX = b
mov r8, rcx; a
mov r9, rdx;b
imul rdx, rdx; bb
imul rcx, rcx; aa
sub rcx, rdx; aa-bb
mov rbx, r9; b
sub rbx, r8; b-a
cmp r8,r9;
mov rax, rcx;
cmovg rax, rbx;
ret;
ifnojump3 ENDP

fun64_2 PROC a:qword, b:qword, c:qword, d:qword, e:qword, f:qword
;RCX = a
;RDX = b
;R8 = c
;R9 = d
;stos = e,f
mov r11, f;
mov r10, e;
add rcx, rdx; a+b
add r10, r11; e+f
imul rcx,rcx; (a+b)^2
imul r10,r10; (e+f)^2
mov rax, r8;
xor rdx, rdx;
idiv r9; c/d a chcemy % (rdx)
add rcx, rdx;
sub rcx, r10;
mov rax, rcx;
mov r8, 16
xor rdx, rdx;
idiv r8;
ret;
fun64_2 ENDP

ostatnie PROC tab:ptr, n:qword
;RCX = **tab
;RDX = n
mov r10, rdx; i=max
petlaN:
mov rsi, [rcx +8*r10-8]; rsi = mm[i]
mov r11, rdx; j=max
petlaM:
mov rdi, [rcx +8*r11-8]; rdi = mm[j]
mov ebx, [rsi +4*r11-4]; rbx = mm[i][j]
mov [rdi +4*r10-4], ebx;
dec r11;
jnz petlaM;
dec r10;
jnz petlaN;
ret;
ostatnie ENDP
END