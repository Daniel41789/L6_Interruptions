/* This program blinks the led embedded in the blue pill board. The led is
 * attached to pin PC13. This pin works as a GPIO, then it must be configured,
 * at assembly level, through the following registers:
 * 1) RCC register,
 * 2) GPIOC_CRL register, 
 * 3) GPIOC_CRH register, and
 * 4) GPIOC_ODR register.
 * 
 * The following code is based on the explanation given in this video:
 * https://www.youtube.com/watch?v=KLWzyhOR3-Y,
 */


.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"

.section .text
.align	1
.syntax unified
.thumb
.global __main
__main:
# Setup
        # enabling clock in port A, B and C
        ldr     r0, =RCC_BASE
        mov     r1, 0x1C                        @ loads 16 in r1 to enable clock in port C (IOPC bit)
        str     r1, [r0, RCC_APB2ENR_OFFSET]    @ M[RCC_APB2ENR] gets 16

        # Set pins PA0 & PA4 as digital input
        ldr     r0, =GPIOA_BASE                 @ moves base address of port A
        ldr     r1, =0x44484448                 @ this constant signals the reset state
        str     r1, [r0, GPIOx_CRL_OFFSET]      @ M[GPIOC_CRL] gets 0x44484448

        # set pin PB8-PB15 as digital output
        ldr     r0, =GPIOB_CRH
        ldr     r1, =0x33333333                 @ PC13: output push-pull, max speed 50 MHz
        str     r1, [r0, GPIOx_CRH_OFFSET]      @ M[GPIOC_CRH] gets 0x33333333

        # set led status initial value     
        add     r0, GPIOx_ODR_OFFSET            @ moves address of GPIOC_ODR register to r0
        mov     r1, 0x0
        str     r1, [r7, #4]
loop:   
        cmp     r1, 0x0                         @ if r1 equals zero then turn PC13 on
        bne     L1                              @ else, turns PC13 off
        mov     r3, 0x0                         @ turns PC13 on
        b       L2
L1:     mov     r3, 0x2000                      @ turns PC13 off
L2:     str     r3, [r0]                        @ M[GPIOC_ODR] gets r1 value
        # dirty delay
        ldr     r2, =2666667                    @ r2 gets 2666667
        b       L3
L4:     sub     r2, r2, #1
L3:     cmp     r2, #0
        bge     L4
        eor     r1, #1 @ negates LSB of r1
        b       loop

EXTI0_IRQHandler:
        # Verification of PA0
        ldr r0, =GPIOA_BASE
        ldr r1, [r0, GPIOA_IDR_OFFSET]
        lsr r1, r1, #0
        ands r1, r1, #1
        bne pin

