section .data
section .bss

section .text
    global _start

;-----------------------------------------------------------------------------------------------
_start:                         
    ; Get the number of arguments
    pop r12                     
    cmp r12, 2                  
    jne _error
    add rsp, 8
    pop rdi                     

    ; Create stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 64

    ; Convert argument to integer
    call _to_number
    mov qword [rbp - 8], rax


    ; Fibonacci sequence init
    mov qword [rbp - 24], 1
    mov qword [rbp - 16], 1

    ; Print First two fibonacci numbers
    lea rsi, [rbp - 25]        
    sub qword [rbp - 8], 2
    mov rdi, 1
    call _to_string
    mov rdi, rsi
    call _print
    mov rdi, rsi
    call _print
    

_start_loop:
    ; Calculate the next fibonacci number
    dec qword [rbp - 8]
    mov r8, qword [rbp - 24]
    mov r9, qword [rbp - 16]
    mov qword [rbp - 24], r9
    add qword [rbp - 16], r8

    ; Convert number to string and print it
    mov rdi, qword[rbp - 16]
    lea rsi, [rbp - 25]        
    call _to_string

    mov rdi, rax
    call _print

    ; Loop
    cmp qword [rbp - 8], 0
    jz _exit
    jnz _start_loop

_exit:
    mov rax, 60                
    xor rdi, rdi                
    leave
    syscall

_error:
    mov rax, 60
    mov rdi, 1
    leave
    syscall

;-----------------------------------------------------------------------------------------------
_print:                         
    call _strlen
    mov rdx, rax
    mov rsi, rdi
    mov rdi, 1                  
    mov rax, 1                 
    syscall
    ret

;-----------------------------------------------------------------------------------------------
_strlen:
    xor rax, rax

_strlen_loop:
    cmp byte [rdi + rax], 0x0
    je _strlen_exit
    inc rax
    jmp _strlen_loop                  

_strlen_exit:
    ret

;-----------------------------------------------------------------------------------------------
_to_number:
    call _strlen
    mov rdx, rax
    xor rbx, rbx
    xor rax, rax

_to_number_loop:
    mov cl, byte [rdi + rbx]
    sub cl, 48
    add al, cl
    inc rbx
    cmp rdx, rbx
    je _to_number_exit

    imul rax, 10
    jmp _to_number_loop

_to_number_exit:
    ret

;-----------------------------------------------------------------------------------------------
_to_string:
    mov rax, rdi
    xor rcx, rcx
    mov r12, 10

    mov byte [rsi], 0x0
    dec rsi
    mov byte [rsi], 0xA
    dec rsi

_to_string_loop:
    xor rdx, rdx
    div r12
    add dl, 48
    mov byte [rsi], dl
    cmp rax, 0
    je _to_string_exit
    dec rsi
    jmp _to_string_loop


_to_string_exit:
    mov rax, rsi
    ret 
