.section .text
.align 1
.syntax unified
.thumb
.global wait_ms
wait_ms:
        mov r11, r0
loop: 
        cmp r11, #0
        bne loop
        bx lapers
.size   wait_ms, .-wait_ms