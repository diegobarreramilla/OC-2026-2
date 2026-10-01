%include "../../lib/pc_io.inc"

section .text
    global _start

_start:

    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
   

    ; x-X
    mov al, 'X'
    mov byte [msg+23], al 

    ; Imprimir cadena
    mov edx, msg
    call puts

    ; Fin de programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0