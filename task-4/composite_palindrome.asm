section .bss
    ; vectorul care retine indicii in back
    sol resd 16
    ; palindrom maxim
    pal_max resb 151
    ; lungime palindrom maxim
    len_pal_max resd 1

section .text
global check_palindrome
global composite_palindrome
extern strcat
extern strlen
extern strcmp
extern strcpy
extern malloc
extern free

check_palindrome:
    ; create a new stack frame
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi

    ; str
    mov ebx, [ebp + 8]
    ; len
    mov edi, [ebp + 12]

    ; index curent
    xor ecx, ecx

.loop_palindrom:
    ; push len
    push edi

    ; j = len
    sub edi, ecx
    ; j--
    dec edi

    xor edx, edx
    ; str[len-i-1]
    mov dl, byte [ebx + edi]

    ; pop len
    pop edi

    xor eax, eax
    ; str[i]
    mov al, byte [ebx + ecx]

    ; compara caracterele
    cmp dl, al
    jne .nu_palindrom

    ; i++
    inc ecx
    cmp ecx, edi
    jl .loop_palindrom 

    ; return 1;
    mov eax, 1
    jmp .end_palindrom

.nu_palindrom:
    ; return 0;
    mov eax, 0

.end_palindrom:
    pop esi
    pop edi
    pop ebx

    mov esp, ebp
    pop ebp
    ret

; returneaza 1 daca este un subsir valid si 0 in caz contrar
; int ok(int k)
ok:
    push ebp
    mov ebp, esp
    push esi

    ; k
    mov esi, [ebp + 8]

    ; i = 1
    mov ecx, 1

    ; daca k = 1 atunci e valid
    cmp ecx, esi
    jge .is_ok

.loop_ok:
    cmp ecx, esi
    jge .end_loop_ok

    ; sol[i]
    mov eax, [sol + ecx*4]

    ; if (sol[i] >= sol[k]) return 0;
    cmp eax, dword [sol + esi*4]
    jge .not_ok

    ; i++
    inc ecx
    jmp .loop_ok

.end_loop_ok:
    ; return 1
    jmp .is_ok

.is_ok:
    ; return 1;
    mov eax, 1
    jmp .end_ok

.not_ok:
    ; return 0;
    mov eax, 0
    jmp .end_ok

.end_ok:
    pop esi

    mov esp, ebp
    pop ebp
    ret

; verifica daca cuvantul format dintr-un subsir este palindrom
; si daca este candidat pentru rezultat
; void proceseaza_subsir(int k, char **strs)
proceseaza_subsir:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    ; int k
    mov esi, [ebp + 8]
    ; char **strs
    mov edi, [ebp + 12]

    ; i = 1;
    mov ecx, 1

    push ecx

    ; construieste cuvantul prin concatenare
    ; cuv = malloc(151 * sizeof(char));
    push 151
    call malloc
    ; curata stiva
    add esp, 4
    ; eax = cuv
    ; cuv[0] = '\n'
    mov byte [eax], 0

    pop ecx
.loop:
    cmp ecx, esi
    jg .end_loop

    ; sol[i]
    mov ebx, [sol + ecx*4]
    ; strs[sol[i]]
    mov edx, [edi + ebx*4]

    push ecx
    push eax

    ; push strs[sol[i]]
    push edx
    ; push cuv
    push eax
    call strcat
    ; curata stiva
    add esp, 8

    pop eax
    pop ecx

    ; i++;
    inc ecx
    jmp .loop

.end_loop:
    ; edi = cuv
    mov edi, eax

    ; push cuv
    push eax
    call strlen
    ; curata stiva
    add esp, 4
    ; ebx = strlen(cuv);
    mov ebx, eax

    ; verifica daca cuvantul format e palindrom
    ; push strlen(cuv)
    push ebx
    ; push cuv
    push edi
    call check_palindrome
    ; curata stiva
    add esp, 8

    ; if (!check_palindrome(cuv)) return;
    cmp eax, 1
    jne .end

.palindrom:
    cmp ebx, dword [len_pal_max]
    ; if (strlen(cuv) > strlen(len_pal_max))
    jg .nou_maxim
    ; if (strlen(cuv) == strlen(len_pal_max))
    je .compara_lexicografic
    jmp .end

.compara_lexicografic:
    push pal_max
    ; push cuv
    push edi
    call strcmp
    ; curata stiva
    add esp, 8

    ; if (strcmp(cuv, pal_max) < 0)
    cmp eax, 0
    jl .nou_maxim
    jmp .end

.nou_maxim:
    ; len_pal_max = strlen(cuv);
    mov dword [len_pal_max], ebx

    ; strcpy(pal_max, cuv)
    ; push cuv
    push edi
    push pal_max
    call strcpy
    ; curata stiva
    add esp, 8

    jmp .end

.end:
    ; free(cuv)
    push edi
    call free
    ; curata stiva
    add esp, 4

    pop ebx
    pop edi
    pop esi

    mov esp, ebp
    pop ebp
    ret

; void Back(int k, int nr_cuv, char **strs)
back:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx

    ; int k
    mov edi, [ebp + 8]
    ; int nr_cuv
    mov esi, [ebp + 12]
    ; char **strs
    mov ebx, [ebp + 16]

    ; i = 0;
    xor ecx, ecx

.loop:
    ; sol[k] = i;
    mov dword [sol + edi*4], ecx

    ; salveaza ecx
    push ecx

    push edi
    call ok
    ; curata stiva
    add esp, 4

    ; restaureaza ecx
    pop ecx

    ; if (ok(k))
    cmp eax, 1
    jne .continue_loop

    ; salveaza ecx
    push ecx

    ; proceseaza_subsir(k, strs)
    push ebx
    push edi
    call proceseaza_subsir
    ; curata stiva
    add esp, 8

    ; eax = k;
    mov eax, edi
    ; eax++;
    inc eax

    ; back(k + 1, nr_cuv, strs)
    ; push strs
    push ebx
    ; push nr_cuv
    push esi
    ; push k + 1
    push eax
    call back
    ; curata stiva
    add esp, 12

    ; restaureaza ecx
    pop ecx
    jmp .continue_loop

.continue_loop:
    ; i++;
    inc ecx
    ; if (i < nr_cuv)
    cmp ecx, esi
    jl .loop

.end:
    pop ebx
    pop esi
    pop edi

    mov esp, ebp
    pop ebp
    ret

composite_palindrome:
    ; create a new stack frame
    push ebp
    mov ebp, esp
    push esi
    push edi

    ; initializeaza palindromul maxim
    mov byte [pal_max], 0
    ; initializeaza lungimea palindromului maxim
    mov dword [len_pal_max], 0

    ; char **strs
    mov esi, [ebp + 8]
    ; int len
    mov edi, [ebp + 12]

    ; back(1, len, strs);
    push esi
    push edi
    ; push k (k = 1)
    push 1
    call back
    ; curata stiva
    add esp, 12

    ; return pal_max;
    ; eax = 1000 * sizeof(char)
    push 1000
    ; eax = char*
    call malloc
    ; curata stiva
    add esp, 4

    ; strcpy(eax, pal_max)
    push pal_max
    push eax
    call strcpy
    ; curata stiva
    add esp, 8

    pop edi
    pop esi

    mov esp, ebp
    pop ebp
    ret

