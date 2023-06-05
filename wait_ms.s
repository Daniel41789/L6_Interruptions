.section .text
.align 1
.syntax unified
.thumb
.global wait_ms
wait_ms:
        mov r10, r0
loop: 
        cmp r10, #0
        bne loop
        bx lr
.size   wait_ms, .-wait_ms
