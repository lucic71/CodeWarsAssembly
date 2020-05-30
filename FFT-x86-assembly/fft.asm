extern malloc

global fft

    ; Define the complex number structure.

struc complex

    .real resd 1
    .imag resd 1

endstruc

section .data

    complex_struc_sz dd 8

section .text

fft:

    push rbp
    mov rbp, rsp

    ; Local variables:
    ;   0x08 = pointer to a heap array containing even indices of poly
    ;   0x10 = pointer to a heap arary containing odd  incides of poly
    ;   0x18 = saves locally the first  argument of fft - polynomial
    ;   0x20 = saves locally the second argument of fft - size
    ;   0x28 = size / 2

    sub rsp, 0x28

    ; Save first argument of fft because we will work with the register
    ; and don't want to lose the pointer.

    mov [rbp - 0x18], rdi
    mov [rbp - 0x20], rsi

    ; Check if the size of the input is 1. Meaning that we reached the base
    ; case.

    mov rax, rsi
    cmp rax, 1
    jz FFT_RET

    ; Save size / 2 in local_0x28 because we will use it multiple times during
    ; this subroutine.

    shr rax, 1
    mov [rbp - 0x28], rax

    ; Create the heap arrays that will contain the even and odd indices.
    ; Their sizes will be (size / 2) * sizeof (struc complex)

    imul rax, [complex_struc_sz]
    mov rdi, rax
    call malloc
    mov [rbp - 0x08], rax

    mov rax, [rbp - 0x28]

    imul rax, [complex_struc_sz]
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

    ; Move size in RDX, put 0 in RCX, put source array in RSI.
    ;
    ; We will load elements from source array and put them in the first and the
    ; second array in the following way:
    ;
    ;   - R8 and R9 will contain the current write pointer where we can write new
    ;       data in the arrays
    ;
    ;   - load data from source array
    ;   - put write pointer from R8 in RDI and write to that pointer
    ;   - update write pointer by writing the new value in RDI to R8
    ;
    ;   - load data from source array
    ;   - put write pointer from R9 in RDI and write to that pointer
    ;   - update write pointer by writing the new value in RDI to R9

    mov rdx, [rbp - 0x20]

    xor rcx, rcx

    mov rsi, [rbp - 0x18]
    mov rsi, [rsi]

    mov r8, [rbp - 0x08]
    mov r9, [rbp - 0x10]

COPY_INDICES:

    lodsq
    mov rdi, r8
    stosq
    mov r8, rdi

    lodsq
    mov rdi, r9
    stosq
    mov r9, rdi

    add rcx, 2 

    cmp rcx, rdx
    jnz COPY_INDICES

DIVIDE_AND_CONQUER:

    ; The new calls to fft will make changes to the first argument
    ; because we send a pointer to the array of struc complex.

    lea rdi, [rbp - 0x08]
    mov rsi, [rbp - 0x28]
    call fft

    lea rdi, [rbp - 0x10]
    mov rsi, [rbp - 0x28]
    call fft

ANGLE:

    ; Compute the angle, it is equal to 2 * pi / n. We will first
    ; push pi and 2 on the stack and multiply them. Then we push
    ; 1 and size and divide them, the result wil be multiplied with
    ; 2 * pi.
    ;
    ; Note: We could also save 2 * pi in rodata to be more elegant.

    ; Multiply pi and 2.

    fldpi

    push qword 2
    fild qword [rsp]
    add rsp, 0x08

    fmulp

    ; Divide 1 and size.

    fld1
    fild qword [rbp - 0x20]
    fdivp

    ; Multiply (2 * pi) and (1 / size)

    fmulp


FFT_RET:

    mov rsp, rbp
    pop rbp

    ret

