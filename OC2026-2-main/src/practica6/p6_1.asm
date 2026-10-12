%include "../../lib/pc_io.inc"   

extern getch
extern putchar
extern puts
extern clrscr

section .data
    msg_inicio db "Escribe una cadena: ", 0
    msg_minus  db "En minusculas: ", 0
    msg_mayus  db "En mayusculas: ", 0
    salto      db 10, 0

section .bss
    cadena resb 255
    tecla  resb 1

section .text
    global _start

_start:
    ; Limpiar pantalla
    call clrscr

    ; Mostrar mensaje
    mov edx, msg_inicio
    call imprimir

    ; Capturar 
    mov edx, cadena
    mov ax, 255
    call captura

    ; minusculas
    mov edx, cadena
    call Minusculas

    mov edx, msg_minus
    call imprimir
    mov edx, cadena
    call imprimir
    mov edx, salto
    call imprimir

    ; mayusculas
    mov edx, cadena
    call Mayusculas

    mov edx, msg_mayus
    call imprimir
    mov edx, cadena
    call imprimir
    mov edx, salto
    call imprimir

    ; Terminar programa
    mov eax, 1
    xor ebx, ebx
    int 80h

captura:
    push ebp
    push ebx
    push ecx
    push edi
    push esi

    mov esi, edx
    movzx ebp, ax
    xor edi, edi

    ; AX debe permitir al menos el nulo
    cmp ebp, 1
    jb .captura_fin
    dec ebp

.captura_leer:
    ; getch devuelve el caracter en AL
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp
    call getch
    mov [tecla], al
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ; Enter termina la captura
    cmp byte [tecla], 10
    je .captura_fin

    ; retroceso
    cmp byte [tecla], 8
    je .captura_borrar

    ; No exceder el limite
    cmp edi, ebp
    jae .captura_leer

    ; Guardar el caracter
    mov al, [tecla]
    mov [esi + edi], al
    inc edi

    ; Mostrar el caracter capturado
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp
    mov al, [tecla]
    call putchar
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    jmp .captura_leer

.captura_borrar:
    ; No borrar si no hay caracteres
    cmp edi, 0
    je .captura_leer

    dec edi
    mov byte [esi + edi], 0

    ; Borrar visualmente: retroceso, espacio, retroceso
    mov al, 8
    call mostrar_caracter
    mov al, ' '
    call mostrar_caracter
    mov al, 8
    call mostrar_caracter

    jmp .captura_leer

.captura_fin:
    mov byte [esi + edi], 0

    ; Salto de linea al terminar
    mov al, 10
    call mostrar_caracter

    pop esi
    pop edi
    pop ecx
    pop ebx
    pop ebp
    ret


Mayusculas:
    push eax
    push edx

.mayus_ciclo:
    mov al, [edx]
    cmp al, 0
    je .mayus_fin

    cmp al, 'a'
    jb .mayus_sig
    cmp al, 'z'
    ja .mayus_sig

    sub byte [edx], 32

.mayus_sig:
    inc edx
    jmp .mayus_ciclo

.mayus_fin:
    pop edx
    pop eax
    ret

Minusculas:
    push eax
    push edx

.minus_ciclo:
    mov al, [edx]
    cmp al, 0
    je .minus_fin

    cmp al, 'A'
    jb .minus_sig
    cmp al, 'Z'
    ja .minus_sig

    add byte [edx], 32

.minus_sig:
    inc edx
    jmp .minus_ciclo

.minus_fin:
    pop edx
    pop eax
    ret

imprimir:
    push eax
    push ebx
    push ecx
    push esi
    push edi
    push ebp

    call puts

    pop ebp
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret


mostrar_caracter:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    call putchar

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
