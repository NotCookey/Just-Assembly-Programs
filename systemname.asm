section .data
    os_name db 500          ; Buffer to store the OS name

section .text
    global _start

_start:
    ; Load the system call number for uname into eax
    mov eax, 122            ; __NR_uname

    ; Set the buffer address to ebx
    mov ebx, os_name

    ; Call the uname system call
    int 0x80                ; Call the kernel

    ; Find the length of the OS name by searching for the null terminator
    mov ecx, 0              ; Counter
    mov edi, ebx            ; Start address of the buffer

.find_length:
    cmp byte [edi], 0       ; Check for null terminator
    je .print_os_name
    inc edi                 ; Move to the next byte
    inc ecx                 ; Increment the counter
    cmp ecx, 500            ; Check if maximum buffer size reached
    jle .find_length        ; Repeat if not reached

.print_os_name:
    ; Print the OS name
    mov eax, 4              ; System call number for write
    mov ebx, 1              ; File descriptor for standard output
    mov edx, ecx            ; OS name length (stored in ecx)
    sub edx, 1              ; Exclude the null terminator from the length
    mov ecx, os_name        ; Buffer address
    int 0x80                ; Call the kernel

    ; Exit the program
    mov eax, 1              ; System call number for exit
    xor ebx, ebx            ; Exit status
    int 0x80                ; Call the kernel
