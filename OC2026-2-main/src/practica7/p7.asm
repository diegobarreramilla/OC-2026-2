section .data
    msg_in  db "Ingresa cadena: ", 0
    len_in  equ $ - msg_in
    salto   db 10

section .bss
    ; Reservar 64 ytes
    buffer_in  resb 64
    buffer_out resb 64

section .text
    global _start

_start:
    ; 1. Desplegar 
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in
    mov edx, len_in
    int 80h

    ; 2. Capturar cadena 
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer_in
    mov edx, 64
    int 80h

    ; 3. Convertir cadena a entero con signo 
    mov esi, buffer_in
    call ATOI
    ; EAX contiene ahora el entero con signo
    
    add eax, 24

    ; 4. Convertir entero a cadena ASCII base 10
    mov edi, buffer_out
    call ITOA
    ; ECX contiene la longitud de la cadena generada

    ; 5. Desplegar el numero convertido
    mov eax, 4
    mov ebx, 1
    mov edx, ecx        ; Longitud retornada por ITOA
    mov ecx, buffer_out ; Dirección del buffer de salida
    int 80h

    ; salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, salto
    mov edx, 1
    int 80h

    ; 6. Terminar programa
    mov eax, 1
    xor ebx, ebx
    int 80h

ATOI:
    push ebx
    push ecx
    push edx

    xor eax, eax    ; Acumulador del valor numerico
    xor ebx, ebx    ; almacen temporal para el caracter
    xor ecx, ecx    ; Bandera de signo (0 = positivo, 1 = negativo)

.saltar_espacios:
    mov bl, byte [esi]
    cmp bl, ' '
    je .siguiente_espacio
    cmp bl, 9       ; Tabulador
    je .siguiente_espacio
    jmp .revisar_signo

.siguiente_espacio:
    inc esi
    jmp .saltar_espacios

.revisar_signo:
    cmp bl, '-'
    jne .revisar_positivo
    mov ecx, 1      ; Marcar bandera como negativo
    inc esi
    jmp .ciclo_digitos

.revisar_positivo:
    cmp bl, '+'
    jne .ciclo_digitos
    inc esi         ; Ignorar el '+'

.ciclo_digitos:
    mov bl, byte [esi]
    ; Parada al encontrar primer caracter que no es digito (incluye '.', letras o '\0')
    cmp bl, '0'
    jb .fin_atoi
    cmp bl, '9'
    ja .fin_atoi

    sub bl, '0'     ; Convertir ASCII a valor 
    mov edx, 10
    mul edx         ; EAX = EAX * 10
    add eax, ebx    ; EAX = EAX + ddgito actual

    inc esi
    jmp .ciclo_digitos

.fin_atoi:
    cmp ecx, 1
    jne .salir_atoi
    neg eax         ; Aplicar signo si la bandera indica negativo

.salir_atoi:
    pop edx
    pop ecx
    pop ebx
    ret


ITOA:
    push ebx
    push edx
    push esi

    mov esi, edi    ; Guardar inicio del buffer para calcular longitud al final
    xor ecx, ecx    ; Contador de dígitos apilados

    ; Comprobar y reservar espacio para el signo
    cmp eax, 0
    jge .positivo
    mov byte [edi], '-'
    inc edi
    neg eax         ; Hacer positivo para las divisiones

.positivo:
    mov ebx, 10

.divisiones:
    xor edx, edx    ; Limpiar parte alta del dividendo 
    div ebx         ; Dividir entre 10. Cociente en EAX, residuo en EDX
    push edx        ; Guardar digito en la pila 
    inc ecx
    cmp eax, 0
    jnz .divisiones ; Repetir si el cociente no es 0

    mov edx, ecx    ; Copiar contador de digito para el ciclo de extraccion

.extraccion:
    pop eax
    add al, '0'     ; Convertir a ASCII
    mov byte [edi], al
    inc edi
    dec edx
    jnz .extraccion

    ; Calcular longitud total (puntero actual - inicio)
    mov ecx, edi
    sub ecx, esi

    pop esi
    pop edx
    pop ebx
    ret