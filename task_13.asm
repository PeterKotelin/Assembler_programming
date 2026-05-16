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
    v0          dd  01234567h
    v1          dd  89ABCDEFh
    key0        dd  01234567h
    key1        dd  89ABCDEFh
    key2        dd  0FEDCBA98h 
    key3        dd  76543210h
    delta       dd  9E3779B9h
    sum         dd  0
    buffer      db  12 dup(0)
    szNewLine   db  13, 10, 0
    
    ; Переменные для ReadConsole
    hInput        dd  0           
    cRead         dd  0           
    inputBuffer   db  4 dup(0)    

.code

start:
    mov ecx, 32
    xor eax, eax
    mov sum, eax

tea_loop:
    mov eax, sum
    add eax, delta
    mov sum, eax
    
    mov ebx, v1
    shl ebx, 4
    add ebx, key0
    mov edx, v1
    add edx, eax
    add ebx, edx
    mov edx, v1
    shr edx, 5
    add edx, key1
    add ebx, edx
    add ebx, eax
    add v0, ebx
    
    mov ebx, v0
    shl ebx, 4
    add ebx, key2
    mov edx, v0
    add edx, eax
    add ebx, edx
    mov edx, v0
    shr edx, 5
    add edx, key3
    add ebx, edx
    add ebx, eax
    add v1, ebx
    
    loop tea_loop

    invoke dwtoa, v0, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    invoke dwtoa, v1, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hInput, eax
    
    invoke ReadConsole, 
           hInput,            
           addr inputBuffer,   
           1,                  
           addr cRead,         
           NULL               

    ; Завершение программы
    invoke ExitProcess, 0

end start