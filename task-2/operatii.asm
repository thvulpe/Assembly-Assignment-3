section .bss
    ; numar de cuvinte
    nr_cuv resd 1

section .data
    ; delimitatori cuvinte
    delimitatori db " .,", 10, 0

section .text
extern strtok
extern qsort
extern strcmp
extern strlen
global sort
global get_words

; compara(void *cuv1, void *cuv2)
compara:
    ; create a new stack frame
    enter 0, 0
    push ebx
    push esi

    ; cuv1
    mov ecx, [ebp + 8]
    ; *cuv1
    mov ecx, [ecx]
    ; cuv2
    mov edx, [ebp + 12]
    ; *cuv2
    mov edx, [edx]

    push ecx
    push edx

    ; strlen(cuv1)
    push ecx
    call strlen
    ; curata stiva
    add esp, 4
    ; ebx = strlen(cuv1)
    mov ebx, eax

    pop edx
    pop ecx

    push ecx
    push edx

    ; strlen(cuv2)
    push edx
    call strlen
    ; curata stiva
    add esp, 4
    ; esi = strlen(cuv2)
    mov esi, eax

    pop edx
    pop ecx

    ; return strlen(cuv1) - strlen(cuv2)
    mov eax, ebx
    sub eax, esi

    ; daca eax == 0 compara lexicografic
    cmp eax, 0
    jne sfarsit_compara

    ; push *cuv2
    push edx
    ; push *cuv1
    push ecx
    call strcmp
    ; curata stiva
    add esp, 8

sfarsit_compara:
    pop esi
    pop ebx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0, 0

    ; words
    mov eax, [ebp + 8]
    ; number_of_words
    mov ebx, [ebp + 12]
    ; size
    mov ecx, [ebp + 16]

    ; functie de comparatie
    push compara
    ; size
    push ecx
    ; numarul de cuvinte
    push ebx
    ; cuvintele
    push eax
    call qsort
    ; curata stiva
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0

    ; s
    mov esi, [ebp + 8]
    ; words
    mov edi, [ebp + 12]

    push delimitatori
    push esi
    call strtok
    ; curata stiva
    add esp, 8

    ; initializeaza numarul de cuvinte
    mov dword [nr_cuv], 0

split_words:
    ; numarul curent de cuvinte
    mov ebx, dword [nr_cuv]
    ; adauga cuvantul in words
    mov [edi + ebx*4], eax
    ; nr_cuv++
    inc dword [nr_cuv]

    push delimitatori
    ; push NULL
    push 0
    call strtok
    ; curata stiva
    add esp, 8

    ; if (*p == NULL)
    cmp eax, 0
    jne split_words

    ; scrie numarul de cuvinte
    mov dword [ebp + 16], nr_cuv

    leave
    ret

