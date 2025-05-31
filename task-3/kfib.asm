section .text
global kfib

kfib:
    ; create a new stack frame
    enter 0, 0
    push edi

    ; n
    mov ecx, [ebp + 8]
    ; K
    mov edx, [ebp + 12]

    ; compara n si K
    cmp ecx, edx
    jl caz_mic
    je caz_egal

    ; contor loop de la 1 la K
    mov edi, 1
    ; suma = 0
    xor ebx, ebx

loop_kfib:
    push ecx
    push ebx

    ; n = n - i
    sub ecx, edi

    ; push K
    push edx
    ; push n - i
    push ecx
    ; apel recursiv
    call kfib
    ; curata stiva
    add esp, 8

    pop ebx
    pop ecx

    ; adauga la suma
    add ebx, eax

    ; contor++
    inc edi
    ; compara contorul cu K
    cmp edi, edx
    jle loop_kfib

    ; eax = suma
    mov eax, ebx
    jmp end_kfib

caz_mic:
    ; return 0
    mov eax, 0
    jmp end_kfib

caz_egal:
    ; return 1
    mov eax, 1
    jmp end_kfib

end_kfib:
    pop edi
    leave
    ret

