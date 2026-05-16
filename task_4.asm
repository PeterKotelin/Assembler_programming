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

.data
    state         dd  12345
    multiplier    dd  1103515245
    increment     dd  12345
    bit_mask      dd  7FFFFFFFh
    buffer        db  12 dup(0)
    szNewLine     db  13, 10, 0
    
    ; Переменные для ReadConsole
    hInput        dd  0           ; Сюда сохраним дескриптор ввода
    cRead         dd  0           ; Сюда Windows запишет число прочитанных байт
    inputBuffer   db  4 dup(0)    ; Буфер для нажатой клавиши (и Enter)

.code

start:
    mov ecx, 10

gen_loop:
    push ecx 

    mov eax, state
    mul multiplier
    add eax, increment
    and eax, bit_mask 
    mov state, eax
    
    invoke dwtoa, eax, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr szNewLine
    
    pop ecx 
    loop gen_loop

    ; --- БЛОК ОЖИДАНИЯ ВВОДА ЧЕРЕЗ READCONSOLE ---
    
    ; 1. Получаем дескриптор стандартного ввода (клавиатуры)
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hInput, eax
    
    ; 2. Вызываем ReadConsole (программа замрет, пока вы не нажмете Enter)
    invoke ReadConsole, 
           hInput,             ; Дескриптор ввода
           addr inputBuffer,   ; Куда записать символы
           1,                  ; Сколько символов ждать (достаточно 1)
           addr cRead,         ; Указатель на переменную для счетчика
           NULL                ; Зарезервировано, всегда NULL

    ; Выход из программы
    invoke ExitProcess, 0

end start