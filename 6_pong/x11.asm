section .data
    socket_conn_err_msg     db "Couldn't connect socket", 0xA, 0x0
    x11_address             db 0x1, "/tmp/.X11-unix/X0", 0x0
    x11_address_len         equ $-x11_address

section .bss
    x11_socket:         resd 1

section .text
    global _create_socket
    global _connect_socket

_create_socket:
    mov rax, 41     
    mov rdx, 0
    mov rsi, 1
    mov rdi, 1  
    syscall
    mov dword [x11_socket], eax 
    ret

;-----------------------------------------------------------------------------------------------
_connect_socket:
    mov rax, 42 
    mov rdx, x11_address_len
    mov rsi, x11_address
    mov edi, dword [x11_address]
    syscall
    cmp rax, -1
    je _connect_socket_error
    ret

_connect_socket_error:
    mov rdi, socket_conn_err_msg
    call _print
    ret
    
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
