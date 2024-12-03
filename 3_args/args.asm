section .data
    newline db 0xA

section .text
    global _start

;-----------------------------------------------------------------------------------------------
_start:                         ; Entry point
    pop r12                     ; Get the number of arguments

_loop:
    pop rdi                     ; Get the adress of the argument
    call _print                 ; Print the argument with own subrutine 
    call _new_line              ; Print new line with new subrutine
    dec r12                     ; Loop for every argument
    jnz _loop 

_exit:
    mov rax, 60                 ; syscall: exit
    xor rdi, rdi                ; exit code 0
    syscall

;-----------------------------------------------------------------------------------------------
_print:                         ; Takes the string with null terminator
    mov rsi, rdi
    xor rdx, rdx                ; String lenght counter

_print_lenght_loop:             ; Loop to calculate the lenght untile the 0x0 terminator
    cmp byte [rsi + rdx], 0x0
    je _print_write
    inc rdx                     
    jmp _print_lenght_loop                  

_print_write:
    mov rax, 1                  ; syscall: write
    mov rdi, 1                  ; file descriptor: stdout
    syscall
    ret

;-----------------------------------------------------------------------------------------------
_new_line:
    mov rsi, newline
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall
    ret

;-----------------------------------------------------------------------------------------------
