.include "exti_map.inc"
.extern wait_ms

.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb
.global EXTI_Handler
EXTI_Handler:
    ldr r0, =EXTI_BASE
    ldr r1, [r0, EXTI_PR_OFFSET]
    ldr r0, =0x40
    cmp r1, r0
    beq EXTI6_Handler
    ldr r0, =EXTI_BASE
    ldr r1, [r0, EXTI_PR_OFFSET]
    ldr r0, =0x80
    cmp r1, r0
    beq EXTI7_Handler
    bx lr

EXTI6_Handler:
    adds    r5, r5, #1
    ldr     r0, =EXTI_BASE
    ldr     r1, [r0, EXTI_PR_OFFSET]
    orr     r1, r1, 0x40
    str     r1, [r0, EXTI_PR_OFFSET]
    bx      lr

EXTI7_Handler:
    eor     r4, r4, #1
    and     r4, r4, #1
    ldr     r0, =EXTI_BASE
    ldr     r1, [r0, EXTI_PR_OFFSET]
    orr     r1, r1, 0x80
    str     r1, [r0, EXTI_PR_OFFSET]
    bx      lr
    