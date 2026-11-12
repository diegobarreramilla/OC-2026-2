
section .data
    idx        dd 0          ; indice del ciclo
    limite     dd 0          ; cantidad de elementos
    ptr_arr    dd 0          ; direccion del arreglo
    resultado  dd 0          ; maximo / minimo / sumatoria

section .text
    global maximo, minimo, sumatoria


%macro WHILE 3
%%inicio:
    mov eax, %1
    cmp eax, %2              ; saltamos si comienzo es mayor al final
    jge %%fin                ; idx >= limite termina el ciclo
    call %3                  ;ciclo de cada caso
    jmp %%inicio             ; vuelve a evaluar la condicion
%%fin:
%endmacro


; int maximo(int *arr, int len)

maximo:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov eax, [ebp + 8]       ; arr
    mov [ptr_arr], eax
    mov eax, [ebp + 12]      ; len
    mov [limite], eax

    cmp eax, 0               ; len <= 0 regresa 0
    jle .max_vacio

    mov esi, [ptr_arr]
    mov eax, [esi]           ; max = arr[0]
    mov [resultado], eax

    mov dword [idx], 0       ;empieza ciclo
    WHILE [idx], [limite], cuerpo_max

    mov eax, [resultado]
    jmp .max_fin

.max_vacio:
    xor eax, eax

.max_fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; Ciclo para maximo
cuerpo_max:
    push eax
    push esi

    mov esi, [ptr_arr]
    mov eax, [idx]
    mov eax, [esi + eax*4]   ; eax = arr[idx]

    cmp eax, [resultado]
    jle .cm_siguiente        ;arr[idx] <= max no cambia
    mov [resultado], eax     ; nuevo maximo

.cm_siguiente:
    inc dword [idx]
    pop esi
    pop eax
    ret

; int minimo(int *arr, int len)

minimo:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov eax, [ebp + 8]
    mov [ptr_arr], eax
    mov eax, [ebp + 12]
    mov [limite], eax

    cmp eax, 0
    jle .min_vacio

    mov esi, [ptr_arr]
    mov eax, [esi]           ; min = arr[0]
    mov [resultado], eax

    mov dword [idx], 0
    WHILE [idx], [limite], cuerpo_min

    mov eax, [resultado]
    jmp .min_fin

.min_vacio:
    xor eax, eax

.min_fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; ciclo para minimo
cuerpo_min:
    push eax
    push esi

    mov esi, [ptr_arr]
    mov eax, [idx]
    mov eax, [esi + eax*4]   ; eax = arr[idx]

    cmp eax, [resultado]
    jge .cn_siguiente        ; si arr[idx] >= min, no cambia
    mov [resultado], eax     ; nuevo minimo

.cn_siguiente:
    inc dword [idx]
    pop esi
    pop eax
    ret

; int sumatoria(int *arr, int len)

sumatoria:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov eax, [ebp + 8]
    mov [ptr_arr], eax
    mov eax, [ebp + 12]
    mov [limite], eax

    mov dword [resultado], 0 ; suma = 0 

    cmp eax, 0
    jle .sum_fin

    mov dword [idx], 0
    WHILE [idx], [limite], cuerpo_suma

.sum_fin:
    mov eax, [resultado]

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

;ciclo para sumatoria acumula arr[idx]
cuerpo_suma:
    push eax
    push esi

    mov esi, [ptr_arr]
    mov eax, [idx]
    mov eax, [esi + eax*4]   ; eax = arr[idx]
    add [resultado], eax

    inc dword [idx]
    pop esi
    pop eax
    ret
