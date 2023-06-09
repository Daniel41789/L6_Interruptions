.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

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
        cmp r5, #1
        bne L1
        mov r0, #1000
        adds r7, r7, #4
        mov sp, r7
        pop {r7}
        bx lr
L1: 
        cmp r5, #2
        bne L2
        mov r0, #500
        adds r7, r7, #4
        mov sp, r7
        pop {r7}
        bx lr
L2:
        cmp r5, #3
        bne L3
        mov r0, #250
        adds r7, r7, #4
        mov sp, r7
        pop {r7}
        bx lr
L3:
        cmp r5, #4
        bne L4
        mov r0, #125
        adds r7, r7, #4
        mov sp, r7
        pop {r7}
        bx lr
L4:
        mov r5, #1
        # Epilogue
        mov r0, #1000
        adds r7, r7, #4
        mov sp, r7
        pop {r7}
        bx lr

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
        bl Ini_SysTick
        # enabling clock in port A, B and C
        ldr     r0, =RCC_BASE
        mov     r2, 0x1C                        @ loads 16 in r1 to enable clock in port C (IOPC bit)
        str     r2, [r0, RCC_APB2ENR_OFFSET]    @ M[RCC_APB2ENR] gets 16

        # Set pins PA6 & PA7 as digital input
        ldr     r0, =GPIOA_BASE                 @ moves base address of port A
        ldr     r2, =0x88444444                 @ this constant signals the reset state
        str     r2, [r0, GPIOx_CRL_OFFSET]      @ M[GPIOC_CRL] gets 0x88444444

        # set pin PB6 and PB7 as digital output
        ldr     r0, =GPIOB_BASE
        ldr     r2, =0x33444444                 @ PC13: output push-pull, max speed 50 MHz
        str     r2, [r0, GPIOx_CRL_OFFSET]      @ M[GPIOC_CRH] gets 0x33444444

        # set pin PB8-PB14 as digital output
        ldr     r0, =GPIOB_BASE
        ldr     r2, =0x33333333                 @ PC13: output push-pull, max speed 50 MHz
        str     r2, [r0, GPIOx_CRH_OFFSET]      @ M[GPIOC_CRH] gets 0x33333333

        #Configuración del mapeo de las interrupcines externas
        ldr r0, =AFIO_BASE
        eor r1, r1
        str r1, [r0, AFIO_EXTICR2_OFFSET]
        # Configuración del disparador
        ldr r0, =EXTI_BASE
        eor r1, r1                              @ Limpieza del registro
        str r1, [r0, EXTI_FTST_OFFSET]          @ Desactivamos el flanco de bajada
        ldr r1, =(0x3 << 6)                     @ Activación de PR de 6 y 7 y habilitación del flanco de subida
        str r1, [r0, EXTI_RTST_OFFSET]          @ Flanco de subida
        str r1, [r0, EXTI_IMR_OFFSET]           
        ldr r0, =NVIC_BASE
        ldr r1, =(0x1 << 23)                    @ habilitación de EXTI Line[9:5]
        str r1, [r0, NVIC_ISER0_OFFSET]

        # set led status initial value     
        ldr     r0, =GPIOB_BASE                  @ moves address of GPIOC_ODR register to r0
        mov     r1, 0x0
        str     r1, [r0, GPIOx_ODR_OFFSET]

        mov r1, #0                               @ counter <-- 0
        str r1, [r7, #4]                         @ Store counter

        # Delay <-- 1000ms
        mov r1, #1000                            @ delay <-- 1000ms
        str r1, [r7, #8]                         @ store ms

        mov r4, #1                               @ set mode status as increment

        mov r5, #1                               @ r5 <-- speed x 1

loop:   
        # Counter 0 or 1
        bl speed                                @ jump to speed function
        str r0, [r7, #8]                        @ store ms
        # Compare counter status
        cmp r4, #1                              @ compare r8 with 1
        bne L5                                  @ branch if r8 not equal 1 to L5
        ldr r0, [r7, #4]                        @ r0 <-- counter
        bl increase                             @ jump to increase function
        str r0, [r7, #4]                        @ store return of increase function in counter
        b L6                                    @ jump to L6
L5:
        ldr r0, [r7, #4]                        @ r0 <-- counter
        bl decrement                            @ jump to decrement function
        str r0, [r7, #4]                        @ store return of decrement function in counter
L6:
        # Turn LEDs ON 
        ldr r0, =GPIOB_BASE                     
        ldr r1, [r7, #4]                        @ r1 <-- counter
        mov r2, r1                              @ r2 <-- r1 
        lsl r2, r2, #6                          @ counter << 6
        str r2, [r0, GPIOx_ODR_OFFSET]
        ldr r0, [r7, #8]                        @ r0 <-- ms
        bl wait_ms                              @ jump to wait_ms function
        b loop                                  @ jump to loop
