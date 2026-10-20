
%define bskey 8

extern getch
extern putchar
extern puts
extern clrscr

section .data
    msg_inicio db "Escribe una cadena (maximo 254 caracteres): ", 0
    msg_minus  db "En minusculas: ", 0
    salto      db 10, 0

section .bss
    cadena resb 255
    tecla  resb 1

section .text
    global _start

_start:
    call clrscr

    ; Solicitar la cadena
    mov edx, msg_inicio
    call imprimir

    ; Capturar la cadena
    mov edx, cadena
    mov ax, 255
    call captura

    ; Convertir la cadena original a minusculas
    mov edx, cadena
    call Minusculas

    ; Mostrar el resultado
    mov edx, msg_minus
    call imprimir

    mov edx, cadena
    call imprimir

    mov edx, salto
    call imprimir

    ; Terminar programa
    mov eax, 1
    xor ebx, ebx
    int 80h


; =========================================
; CAPTURA
; EDX = direccion del buffer
; AX  = capacidad total, incluyendo nulo
; =========================================
captura:
    push ebp
    push ebx
    push ecx
    push edi
    push esi

    mov esi, edx
    movzx ebp, ax
    xor edi, edi

    cmp ebp, 1
    jb .captura_fin
    dec ebp

.captura_leer:
    call getch
    mov [tecla], al

    ; Enter termina la captura
    cmp byte [tecla], 10
    je .captura_fin
    cmp byte [tecla], 13
    je .captura_fin

    ; Manejar retroceso
    cmp byte [tecla], bskey
    je .captura_borrar

    ; Verificar capacidad
    cmp edi, ebp
    jae .captura_leer

    ; Guardar caracter
    mov al, [tecla]
    mov [esi + edi], al
    inc edi

    ; Mostrar caracter escrito
    call mostrar_caracter

    jmp .captura_leer

.captura_borrar:
    cmp edi, 0
    je .captura_leer

    dec edi
    mov byte [esi + edi], 0

    ; Borrar visualmente el caracter
    mov al, 8
    call mostrar_caracter
    mov al, ' '
    call mostrar_caracter
    mov al, 8
    call mostrar_caracter

    jmp .captura_leer

.captura_fin:
    ; Terminar la cadena con nulo
    mov byte [esi + edi], 0

    ; Mostrar salto de linea
    mov al, 10
    call mostrar_caracter

    pop esi
    pop edi
    pop ecx
    pop ebx
    pop ebp
    ret


; =========================================
; MINUSCULAS
; EDX = direccion de la cadena
; Convierte A-Z en a-z
; =========================================
Minusculas:
    push eax
    push edx

.minus_ciclo:
    mov al, [edx]

    ; Fin de la cadena
    cmp al, 0
    je .minus_fin

    ; Verificar si es una mayuscula
    cmp al, 'A'
    jb .minus_sig
    cmp al, 'Z'
    ja .minus_sig

    ; Convertir a minuscula
    add byte [edx], 32

.minus_sig:
    inc edx
    jmp .minus_ciclo

.minus_fin:
    pop edx
    pop eax
    ret


; =========================================
; IMPRIMIR CADENA
; EDX = direccion de la cadena
; =========================================
imprimir:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    call puts

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


; =========================================
; MOSTRAR CARACTER
; AL = caracter
; =========================================
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
