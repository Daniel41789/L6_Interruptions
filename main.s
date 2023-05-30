.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "systick_map.inc"
.include "gpio_map.inc"
.include "nvic_reg_map.inc"
.include "afio_map.inc"
.include "exti_map.inc"
.include "rcc_map.inc"
.extern wait_ms
.extern Ini_SysTick

speed: 
        # Prologue
        push {r7}                               @ backs r7 up
        sub sp, sp, #4                          @ reserves a 4 bytes function frame
        add r7, sp, #0
        # Function Body
        // Compare
        bne L1
        
L1: 

decrement:
        # Prologue
        push {r7, lr}                           @ backs r7 and lr up
        sub sp, sp, #8                          @ reserves a 8 bytes function frame
        add r7, sp, #0                          @ updates r7
        str r0, [r7, #4]                        @ backs function argument
        # Function body
        ldr r0, [r7, #4]                        @ r0 <-- function argument
        subs r0, r0, #1                         @ counter--
        str r0, [r7, #4]                        @ store counter
        ldr r0, [r7, #4]                        @ r0 <-- counter
        # Epilogue
        adds r7, r7, #8
        mov sp, r7
        pop {r7}
        pop {lr}
        bx lr

increase:
        # Prologue
        push {r7, lr}                           @ backs r7 and lr up
        sub sp, sp, #8                          @ reserves a 8 bytes function frame
        add r7, sp, #0                          @ updates r7
        str r0, [r7, #4]                        @ backs function argument 
        # Function Body
        ldr r0, [r7, #4]                        @ r0 <-- function argument
        adds r0, r0, #1                         @ counter++
        str r0, [r7, #4]
        ldr r0, [r7, #4]
        # Epilogue
        adds r7, r7, #8
        mov sp, r7
        pop {r7}
        pop {lr}
        bx lr


.section .text
.align	1
.syntax unified
.thumb
.global __main
__main:
        # Setup
        push {r7, lr}
        sub sp, sp, #16
        add r7, sp, #0

        # enabling clock in port A, B and C
        ldr     r0, =RCC_BASE
        mov     r1, 0x1C                        @ loads 16 in r1 to enable clock in port C (IOPC bit)
        str     r1, [r0, RCC_APB2ENR_OFFSET]    @ M[RCC_APB2ENR] gets 16

        # Set pins PA0 & PA4 as digital input
        ldr     r0, =GPIOA_BASE                 @ moves base address of port A
        ldr     r1, =0x44484448                 @ this constant signals the reset state
        str     r1, [r0, GPIOx_CRL_OFFSET]      @ M[GPIOC_CRL] gets 0x44484448

        # set pin PB8-PB15 as digital output
        ldr     r0, =GPIOB_BASE
        ldr     r1, =0x33333333                 @ PC13: output push-pull, max speed 50 MHz
        str     r1, [r0, GPIOx_CRH_OFFSET]      @ M[GPIOC_CRH] gets 0x33333333

        ldr r0, =AFIO_BASE
        mov r1, #0
        ldr r1, [r0, AFIO_EXTICR1_OFFSET]
        ldr r0, =EXTI_BASE
        mov r1, #0
        str r1, [r0, EXTI_FTST_OFFSET]
        ldr r1, =0x11
        str r1, [r0, EXTI_RTST_OFFSET]
        str r1, [r0, EXTI_IMR_OFFSET]
        ldr r0, =NVIC_BASE
        ldr r1, =0x440
        str r1, [r0, NVIC_ISER0_OFFSET]

        # set led status initial value     
        ldr     r0, =GPIOB_BASE                  @ moves address of GPIOC_ODR register to r0
        mov     r1, 0x0
        str     r1, [r0, GPIOx_ODR_OFFSET]
        mov r1, #0                              @ counter <-- 0
        str r1, [r7, #4]                        @ Store counter


loop:   
        # Counter 0 or 1
        bl speed
        // Compare status counter
        bne L5
        ldr r0, [r7, #4]
        bl increase
        str r0, [r7, #4]
        b L6
L5:
L6:
b loop
