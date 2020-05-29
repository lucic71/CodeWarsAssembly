extern malloc

global fft

    ; Define the complex number structure.

struc complex

    .real resd 1
    .imag resd 1

endstruc

fft:

    push rbp
    mov rbp, rsp

    ; Local variables:
    ;   0x08 = pointer to a heap array containing even indices of poly
    ;   0x10 = pointer to a heap arary containing odd  incides of poly
    ;   0x18 = saves locally the first  argument of fft
    ;   0x20 = saves locally the second argument of fft

    sub rsp, 0x20

    ; Save first argument of fft because we will work with the register
    ; and don't want to lose the pointer.

    mov [rbp - 0x18], rdi
    mov [rbp - 0x20], rsi

    ; Check if the size of the input is 1. Meaning that we reached the base
    ; case.

    mov rax, rsi
    cmp rax, 1
    jz FFT_RET

    ; Create the heap arrays that will contain the even and odd indices.
    ; Their sizes will be size / 2.

    shr rax, 1
    mov rdi, rax
    call malloc
    mov [rbp - 0x08], rax

    mov rax, [rbp - 0x20]
    shr rax, 1
    mov rdi, rax
    call malloc
    mov [rbp - 0x10], rax

    ; Copy the even and odd indices in the newly created arrays.
    ;
    ; Implementation:
    ; --------------
    ;  The current value of the iterator will be saved in RCX and
    ;  the max value of the iterator will be saved in RDX. We iterate
    ;  until RCX >= RDX. At each step we extract the element from position
    ;  2 * RCX and put it in the first array on position i, and the element 
    ;  from position 2 * RCX + 1 and put it in the second array on position i.
    ;  The source of extraction is the first argument of fft.

    ; Move size / 2 in RDX, put 0 in RCX, put source array in RSI and the first
    ; destination array in RDI. After we load the first element in the first
    ; array, RDI will contain the second array to load the element destinated
    ; to it.

    mov rdx, [rbp - 0x20]
    shr rdx, 1

    xor rcx, rcx

    mov rsi, [rbp - 0x18]
    mov rdi, [rbp - 0x08]

COPY_INDICES:

    inc rcx

    cmp rcx, rdx
    jnz COPY_INDICES


FFT_RET:

    mov rsp, rbp
    pop rbp

    ret

