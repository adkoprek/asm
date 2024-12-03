section .data
    question_msg: db "Guess a number: ", 0x0

section .bss

section .text
    global _start

;-----------------------------------------------------------------------------------------------
_start:
    push rbp        ; Prolog
    mov rbp, rsp
    sub rsp, 32

    mov rdi, question_msg
    call _print
    call _get_input

    leave
    mov rax, 60     ; Exit syscall
    xor rdi, rdi    ; Exit code 0
    syscall

;-----------------------------------------------------------------------------------------------
_print:
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1

    xor rdx, rdx
_print_lenght:
    cmp byte [rsi + rdx], 0x0
    je _print_write
    inc rdx
    jmp _print_lenght

_print_write:
    syscall
    xor rax, rax
    ret

;-----------------------------------------------------------------------------------------------
_get_input:
    push rbp            ; Prolog
    mov rbp, rsp
    sub rsp, 128

    ; Read input
    mov rdx, 128
    mov rsi, rsp
    mov rdi, 0          ; 0 - stdin
    mov rax, 0          ; Read syscall
    syscall

    mov byte [rsp + rax], 0x0
    mov rdi, rsp
    call _print

    xor rax, rax        ; Epilog
    leave               
    ret
