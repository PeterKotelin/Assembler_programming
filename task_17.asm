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
sbox        db  63h, 7Ch, 77h, 7Bh, 0F2h, 6Bh, 6Fh, 0C5h
db  30h, 01h, 67h, 2Bh, 0FEh, 0D7h, 0ABh, 76h
db  0CAh, 82h, 0C9h, 7Dh, 0FAh, 59h, 47h, 0F0h
db  0ADh, 0D4h, 0A2h, 0AFh, 9Ch, 0A4h, 72h, 0C0h
db  0B7h, 0FDh, 93h, 26h, 36h, 3Fh, 0F7h, 0CCh
db  34h, 0A5h, 0E5h, 0F1h, 71h, 0D8h, 31h, 15h
db  04h, 0C7h, 23h, 0C3h, 18h, 96h, 05h, 9Ah
db  07h, 12h, 80h, 0E2h, 0EBh, 27h, 0B2h, 75h
db  09h, 83h, 2Ch, 1Ah, 1Bh, 6Eh, 5Ah, 0A0h
db  52h, 3Bh, 0D6h, 0B3h, 29h, 0E3h, 2Fh, 84h
db  53h, 0D1h, 00h, 0EDh, 20h, 0FCh, 0B1h, 5Bh
db  6Ah, 0CBh, 0BEh, 39h, 4Ah, 4Ch, 58h, 0CFh
db  0D0h, 0EFh, 0AAh, 0FBh, 43h, 4Dh, 33h, 85h
db  45h, 0F9h, 02h, 7Fh, 50h, 3Ch, 9Fh, 0A8h
db  51h, 0A3h, 40h, 8Fh, 92h, 9Dh, 38h, 0F5h
db  0BCh, 0B6h, 0DAh, 21h, 10h, 0FFh, 0F3h, 0D2h
db  0CDh, 0Ch, 13h, 0ECh, 5Fh, 97h, 44h, 17h
db  0C4h, 0A7h, 7Eh, 3Dh, 64h, 5Dh, 19h, 73h
db  60h, 81h, 4Fh, 0DCh, 22h, 2Ah, 90h, 88h
db  46h, 0EEh, 0B8h, 14h, 0DEh, 5Eh, 0Bh, 0DBh
db  0E0h, 32h, 3Ah, 0Ah, 49h, 06h, 24h, 5Ch
db  0C2h, 0D3h, 0ACh, 62h, 91h, 95h, 0E4h, 79h
db  0E7h, 0C8h, 37h, 6Dh, 8Dh, 0D5h, 4Eh, 0A9h
db  6Ch, 56h, 0F4h, 0EAh, 65h, 7Ah, 0E8h, 0E6h
db  78h, 80h, 0E9h, 60h, 51h, 7Fh, 0A1h, 42h
db  30h, 66h, 68h, 98h, 16h, 0D4h, 0A4h, 5Ch
db  0CCh, 5Dh, 65h, 0B6h, 92h, 6Ch, 42h, 0E0h
db  0E9h, 0D3h, 62h, 76h, 11h, 14h, 63h, 55h
db  21h, 0Ch, 7Dh
input_data  db  00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h
db  08h, 09h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
output      db  16 dup(0)
buffer      db  12 dup(0)
szNewLine   db  13, 10, 0
hInput      dd  0
cRead       dd  0
inBuf       db  4 dup(0)

.code

start:
mov ecx, 16
mov esi, offset input_data
mov edi, offset output
mov ebx, offset sbox

subbytes_loop:
lodsb
xlat
stosb
loop subbytes_loop

mov ecx, 16
mov esi, offset output


print_loop:
push ecx
xor eax, eax
lodsb
invoke dwtoa, eax, addr buffer
invoke StdOut, addr buffer
invoke StdOut, addr szNewLine
pop ecx
loop print_loop

invoke GetStdHandle, STD_INPUT_HANDLE
mov hInput, eax
invoke ReadConsole, hInput, addr inBuf, 1, addr cRead, NULL

invoke ExitProcess, 0


end start