extern calloc, free
extern malloc
global queue_enqueue, queue_dequeue, queue_front, queue_is_empty

struc node
    .data resq 1
    .next resq 1
endstruc

node_sz equ 0x10

struc queue
    .front resq 1
    .back  resq 1
endstruc

queue_sz equ 0x10

section .text

; ########## queue_enqueue ##########
queue_enqueue:

allocate_node:
    push rbp
    mov rbp, rsp

    ; Allocate memory for a Node.
    push rdi
    push rsi

    mov rdi, node_sz
    mov rsi, 1
    call calloc

    pop rsi
    pop rdi

    ; Set data in Node.
    mov [rax + node.data], rsi

check_queue:
    push rax
    call queue_is_empty

    test al, al
    pop rax
    jz nonempty_queue_enqueue

empty_queue_enqueue:
    ; Update front and back in Queue.
    mov [rdi + queue.front], rax
    mov [rdi + queue.back],  rax

    jmp queue_enqueue_done

nonempty_queue_enqueue:
    ; Update the .next field from .back of the queue.
    mov rdx, [rdi + queue.back]
    mov [rdx + node.next], rax

    ; Update the .back field in Queue.
    mov [rdi + queue.back], rax

queue_enqueue_done:
    mov rsp, rbp
    pop rbp

    ret ; TODO
; ########## queue_enqueue done ##########

; ########## queue_dequeue ##########
queue_dequeue:
    push rbp
    mov rbp, rsp

    ; Save value to be returned.
    mov rax, [rdi + queue.front]
    mov rax, [rax + node.data]
    push rax

    ; Save the pointer to be free'd on stack.
    push qword [rdi]

    ; Move .front pointer to the second element
    mov rax, [rdi + queue.front]
    mov rax, [rax + node.next]
    mov [rdi + queue.front], rax

    ; If queue becomes empty then update .back too.
    call queue_is_empty
    test al, al
    jz update_back_done

update_back:
    mov qword [rdi + queue.back], 0x00

update_back_done:

    ; Free the node.
    pop rdi
    call free

    ; Return value is .data from the previous .front.
    pop rax

    mov rsp, rbp
    pop rbp

    ret ; TODO
; ########## queue_dequeue done ##########

; ########## queue_front ##########
queue_front:
    mov rax, [rdi + queue.front]
    mov rax, [rax + node.data]

    ret ; TODO
; ########## queue_front done ##########

queue_is_empty:
    mov rax, [rdi + queue.front]
    test rax, rax
    sete al

    ret
