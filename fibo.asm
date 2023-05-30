section .data
    msg db 'Fibonacci series:', 0
    limit_msg db 'Enter the limit: ', 0
    format db '%ld ', 0

section .bss
    buffer resb 10        ; Buffer to store user input

section .text
    extern printf        ; Declare external reference to the printf function
    global _start

_start:
    ; Display the limit prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, limit_msg
    mov rdx, 17
    syscall

    ; Read the limit from the user
    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer]
    mov rdx, 10
    syscall

    ; Convert the input to an integer
    xor rax, rax
    xor rdi, rdi
    xor rsi, rsi
    mov r10, 10         ; Multiplier to convert ASCII to integer
    lea r8, [buffer]
    .read_loop:
        cmp byte [r8], 0
        je .end_read
        sub byte [r8], '0'
        imul rax, r10
        add rax, rsi
        mov rsi, rax
        inc r8
        jmp .read_loop
    .end_read:

    ; Call the Fibonacci function and print the series
    mov rdi, rax        ; Move the limit into rdi
    mov rax, 1          ; First Fibonacci number
    call fibonacci      ; Call the Fibonacci function

    ; Exit the program
    mov eax, 60
    xor edi, edi
    syscall

fibonacci:
    ; Set up stack frame
    push rbp
    mov rbp, rsp

    ; Local variables
    sub rsp, 16
    mov qword [rbp-8], 1    ; fib1
    mov qword [rbp-16], 1   ; fib2

    ; Print the series label
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 17
    syscall

    ; Print the first two Fibonacci numbers
    mov rax, qword [rbp-8]
    mov rdi, format
    mov rsi, rax
    xor rax, rax
    call printf

    mov rax, qword [rbp-16]
    mov rdi, format
    mov rsi, rax
    xor rax, rax
    call printf

    ; Calculate and print the remaining Fibonacci numbers
    mov ecx, 2          ; Counter starts from 2
    .fib_loop:
        add ecx, 1
        mov rax, qword [rbp-8]
        add rax, qword [rbp-16]
        mov qword [rbp-8], rax

        mov rdi, format
        mov rsi, rax
        xor rax, rax
        call printf

        mov rax, qword [rbp-16]
        mov qword [rbp-16], rax

        cmp ecx, edi        ; Compare counter with limit
        jl .fib_loop

    ; Clean up stack frame
    mov rsp, rbp
    pop rbp
    ret
