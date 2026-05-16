.486
.model flat, stdcall
option casemap: none
 
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
 
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\ws2_32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
 
include \masm32\macros\macros.asm
 
.data
    h0         dd  67452301h
    h1         dd  0EFCDAB89h
    h2         dd  98BADCFEh
    h3         dd  10325476h
    h4         dd  0C3D2E1F0h
    k          dd  5A827999h
    w0         dd  0
    w1         dd  0
    w2         dd  0
    w3         dd  0
    var_a      dd  0
    var_b      dd  0
    var_c      dd  0
    var_d      dd  0
    var_e      dd  0
    temp       dd  0
    buffer     db  12 dup(0)
    szNewLine  db  13, 10, 0
    hInput     dd  0
    cRead      dd  0
    inBuf      db  4 dup(0)
 
.code
 
start:
    mov eax, 61626364h
    mov w0, eax
    mov eax, 65666768h
    mov w1, eax
    mov eax, 696A6B6Ch
    mov w2, eax
    mov eax, 6D6E6F80h
    mov w3, eax
 
    mov eax, h0
    mov var_a, eax
    mov eax, h1
    mov var_b, eax
    mov eax, h2
    mov var_c, eax
    mov eax, h3
    mov var_d, eax
    mov eax, h4
    mov var_e, eax
 
    mov ecx, 20
 
sha1_loop:
    mov eax, var_a
    rol eax, 5
    mov ebx, eax
     
    mov eax, var_b
    and eax, var_c
    mov edx, var_b
    not edx
    and edx, var_d
    or eax, edx
    add ebx, eax
     
    add ebx, var_e
    add ebx, w0
    add ebx, k
    mov temp, ebx
     
    mov eax, var_e
    mov eax, var_d
    mov var_e, eax
    mov eax, var_c
    mov var_d, eax
    mov eax, var_b
    rol eax, 30
    mov var_c, eax
    mov eax, var_a
    mov var_b, eax
    mov eax, temp
    mov var_a, eax
     
    mov eax, w3
    xor eax, w2
    xor eax, w1
    xor eax, w0
    rol eax, 1
    mov edx, w2
    mov w3, edx
    mov edx, w1
    mov w2, edx
    mov edx, w0
    mov w1, edx
    mov w0, eax
     
    dec ecx
    jnz sha1_loop
 
    mov eax, var_a
    add h0, eax
    mov eax, var_b
    add h1, eax
    mov eax, var_c
    add h2, eax
    mov eax, var_d
    add h3, eax
    mov eax, var_e
    add h4, eax
 
    invoke dwtoa, h0, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    invoke dwtoa, h1, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    invoke dwtoa, h2, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    invoke dwtoa, h3, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    invoke dwtoa, h4, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
 
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hInput, eax
    invoke ReadConsole, hInput, addr inBuf, 1, addr cRead, NULL

    invoke ExitProcess, 0
 
end start