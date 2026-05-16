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
    message     db  "Hello World", 0
    msgLen      dd  11
    hash        db  0
    buffer      db  12 dup(0)
    szNewLine   db  13, 10, 0
    
    ; Переменные для ReadConsole
    hInput        dd  0           
    cRead         dd  0           
    inputBuffer   db  4 dup(0)    

.code

start:
    xor ebx, ebx
    mov ecx, msgLen
    mov esi, offset message

hash_loop:
    lodsb
    add bl, al
    loop hash_loop

    mov hash, bl
    xor eax, eax
    mov al, hash
    
    invoke dwtoa, eax, addr buffer
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

    ; Завершение работы
    invoke ExitProcess, 0

end start