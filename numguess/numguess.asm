section .data
    intro_msg:      db "Guess a number between 1 and 30, you have 3 tries", 0xA, 0x0
    question_msg:   db "Guess a number: ", 0x0
    bigger_msg:     db "The guessed number is too big", 0xA, 0x0
    smaller_msg:    db "The guessed number is too small", 0xA, 0x0
    won_msg:        db "You won!", 0xA, 0x0
    lost_msg:       db "You lost, the number was: ", 0x0

section .bss

section .text
    global _start

;-----------------------------------------------------------------------------------------------
_start:
    mov rdi, intro_msg
    call _print
    call _game

;-----------------------------------------------------------------------------------------------
_game:
    push rbp
    mov rbp, rsp
    sub rbp, 16

_game_loop:
    call _rnd_num
    mov r12, rax
    mov rbx, 4

_game_loop_loop:
    dec rbx
    cmp rbx, 0
    je _round_lost

    mov rdi, question_msg
    call _print
    call _get_number

    cmp r12, rax
    je _guessed_correct
    jl _guessed_bigger
    jg _guessed_smaller

_guessed_bigger:
    mov rdi, bigger_msg
    call _print
    jmp _game_loop_loop

_guessed_smaller:
    mov rdi, smaller_msg
    call _print
    jmp _game_loop_loop

_guessed_correct:
    mov rdi, won_msg
    call _print
    jmp _game_loop

_round_lost:
    mov rdi, lost_msg
    call _print
    lea rsi, [rbp - 8]
    mov rdi, r12
    call _to_string
    mov rdi, rax
    call _print
    jmp _game_loop

;-----------------------------------------------------------------------------------------------
_rnd_num:
    rdtsc               ; Gnereate "Random number" into edx:eax
    xor edx, edx
    mov ecx, 30
    div ecx
    mov eax, edx
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
_get_number:
    push rbp         
    mov rbp, rsp
    sub rsp, 16

    ; Read input
    mov rdx, 16
    lea rsi, [rbp - 16] ; The input buffer 
    mov rdi, 0          ; 0 - stdin
    mov rax, 0          ; Read syscall
    syscall

    mov byte [rbp + rax - 17], 0x0
    lea rdi, [rbp - 16]
    call _to_number

    leave               
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
    xor r8, r8
    xor rax, rax

_to_number_add_digit:
    mov cl, byte [rdi + r8]
    sub cl, 48
    add al, cl
    inc r8

    cmp byte [rdi + r8], 0xA
    je _to_number_exit
    cmp rdx, r8
    je _to_number_exit

    imul rax, 10
    jmp _to_number_add_digit

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
