section .bss
    ; ultimul nod procesat
    ultim resd 1
    ; inceputul listei
    inceput resd 1
    ; contor loop exterior
    contor_ext resd 1
    ; contor loop interior
    contor_int resd 1

section .text
global sort

;   struct node {
;    int val;
;    struct node* next;
;   };

;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list
sort:
    ; create a new stack frame
    enter 0, 0

    ; n
    mov eax, [ebp + 8]
    ; pointer la inceputul listei de noduri
    mov ebx, [ebp + 12]

    ; contor_ext  = 1
    mov dword [contor_ext], 1

loop_exterior:
    ; reseteaza contorul interior
    mov dword [contor_int], 0

loop_interior:
    ; valoare contor interior
    mov ecx, dword [contor_int]

    ; adresa nod curent
    lea edx, [ebx+ecx*8]

    ; verifica daca valoarea nodului curent este cea cautata
    ; valoare nod curent
    mov eax, [edx]
    cmp eax, [contor_ext]
    je nod_gasit

    ; daca nu a fost gasit nodul cautat
    inc dword [contor_int]
    mov eax, [contor_int]
    ; compara contorul cu n
    cmp eax, [ebp + 8]
    jl loop_interior
    jmp continua_loop_exterior

nod_gasit:
    ; verifica daca nodul este inceput de lista
    cmp dword [contor_ext], 1
    jne nod_mijloc

    ; seteaza nodul de inceput de lista
    mov dword [inceput], edx
    ; actualizeaza ultimul
    mov dword [ultim], edx
    jmp continua_loop_exterior

nod_mijloc:
    ; pune nodul ca inceput de lista
    mov eax, dword [ultim]
    ; ultim->next = nod_curent
    mov [eax + 4], edx
    mov dword [ultim], edx

continua_loop_exterior:
    inc dword [contor_ext]
    mov eax, dword [contor_ext]
    ; compara contorul cu n
    cmp eax, [ebp + 8]
    jle loop_exterior

    mov eax, dword [inceput]

    leave
    ret

