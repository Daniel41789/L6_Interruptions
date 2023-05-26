.extern wait_ms
.extern systick_map.inc
.thumb
.syntax unified
.global Systick_Initialize
Systick_Initialize:
    ldr r0, =SYSTICK_BASE               @ load Systick base address in r0
    mov r1, #0                          @ r1 <-- 0
    str r1, [r0, STK_CTRL_OFFSET]       @ Disable Systick (STK_CRL = 0)
    mov r2, #262                        @ r2 <-- 262
    str r2, [r0, STK_LOAD_OFFSET]       @ STK_LOAD = 262
    mov r1, #0                          @ r1 <-- 0
    str r1, [r0, STK_VAL_OFFSET]        @ restart Systick counter 

    # Priority configuration of Systick
    ldr r2, =SCB_BASE                    
    ldr r3, =SCB_SHPR1_OFFSET
    add r2, r2, r3
    mov r3, #(1<<4)
    strb r3, [r2, #11]

    # Enable Systick with interrupt
    ldr r1, [r0, STK_CTRL_OFFSET]       
    orr r1, r1, #3
    str r1, [r0, STK_CTRL_OFFSET]
    bx lr

.global Systick_Handler
Systick_Handler:
    mov r0, #1 
    bl wait_ms
    bx lr 

