section .data
    msg_inicio db "Escribe una cadena: ", 0
    msg_minus  db "En minusculas: ", 0
    msg_mayus  db "En mayusculas: ", 0
    salto      db 10, 0

section .bss
    cadena resb 255

section .text
    global _start

_start:
    call clrscr

    mov edx, msg_inicio
    call puts

    mov edx, cadena
    mov ax, 255
    call captura

    mov edx, cadena
    call Minusculas
    mov edx, msg_minus
    call puts
    mov edx, cadena
    call puts
    mov edx, salto
    call puts

    mov edx, cadena
    call Mayusculas
    mov edx, msg_mayus
    call puts
    mov edx, cadena
    call puts
    mov edx, salto
    call puts

    mov eax, 1
    xor ebx, ebx
    int 0x80

; putchar: imprime el caracter que recibe en AL.
; Usa sys_write (eax=4, ebx=1).

putchar:
    push eax
    push ebx
    push ecx
    push edx

    mov [char_buffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buffer
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; puts: imprime la cadena apuntada por EDX hasta el byte nulo
; Conserva EDX para que el llamador no pierda el puntero

puts:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, edx
.puts_loop:
    cmp byte [esi], 0
    je .puts_done

    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, 1
    int 0x80

    inc esi
    jmp .puts_loop

.puts_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; getch: lee un caracter sin mostrarlo
; Guarda/restaura el modo canonico con los procedimientos
; indicados en la practica

getch:
    call canonical_off
    push ebx
    push ecx
    push edx
    push esi

    sub esp, 4
    mov eax, 3
    xor ebx, ebx
    mov ecx, esp
    mov edx, 1
    int 0x80
    mov al, [esp]
    add esp, 4

    pop esi
    pop edx
    pop ecx
    pop ebx
    push eax
    call canonical_on
    pop eax
    ret


; getche: lee un caracter y lo muestra (con echo)

getche:
    call getch
    call putchar
    ret

; Captura AX-1 caracteres maximo (se reserva 1 byte para NUL)
; EDX apunta al buffer. Enter finaliza. Backspace borra si hay
; algo capturado. Los caracteres se muestran con putchar

captura:
    push ebp
    push ebx
    push ecx
    push esi
    push edi

    mov esi, edx
    movzx ebp, ax
    xor edi, edi

    cmp ebp, 1
    jbe .captura_fin
    dec ebp

.captura_leer:
    call getche

    cmp al, 10
    je .captura_fin
    cmp al, 13
    je .captura_fin

    cmp al, 8
    je .captura_borrar
    cmp al, 127
    je .captura_borrar

    cmp edi, ebp
    jae .captura_leer

    mov [esi + edi], al
    inc edi
    jmp .captura_leer

.captura_borrar:
    cmp edi, 0
    je .captura_leer

    dec edi
    mov byte [esi + edi], 0

    mov al, 8
    call putchar
    mov al, ' '
    call putchar
    mov al, 8
    call putchar
    jmp .captura_leer

.captura_fin:
    mov byte [esi + edi], 0
    mov al, 10
    call putchar

    pop edi
    pop esi
    pop ecx
    pop ebx
    pop ebp
    ret

Mayusculas:
    push eax
    push edx
.mayus_ciclo:
    mov al, [edx]
    test al, al
    jz .mayus_fin
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
    test al, al
    jz .minus_fin
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


clrscr:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, clear_sequence
    mov edx, clear_length
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

section .data
    clear_sequence db 27, "[2J", 27, "[H"
    clear_length equ $ - clear_sequence
    char_buffer db 0


canonical_off:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, 54              ; sys_ioctl
    xor ebx, ebx             ; stdin
    mov ecx, 0x5401          ; TCGETS
    mov edx, termios_original
    int 0x80
    test eax, eax
    js .canonical_off_fin

    mov esi, termios_original
    mov edi, termios_temporal
    mov ecx, 9
    cld
    rep movsd

    mov byte [termios_temporal + 22], 0
    mov byte [termios_temporal + 23], 1

    ; Aplicar el estado temporal.
    mov eax, 54
    xor ebx, ebx
    mov ecx, 0x5402          ; TCSETS
    mov edx, termios_temporal
    int 0x80

.canonical_off_fin:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret




canonical_on:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 54              ; sys_ioctl
    xor ebx, ebx             ; stdin
    mov ecx, 0x5402          ; TCSETS
    mov edx, termios_original
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

section .bss
    termios_original resb 36
    termios_temporal resb 36
