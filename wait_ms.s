.thumb
.global wait_ms
wait_ms:
        # Prologue
        push    {r7}                @ backs r7 up
        sub     sp, sp, #28         @ reserves a 32-byte function frame
        add     r7, sp, #0          @ updates r7
        str     r0, [r7]            @ backs ms up
        # Body function
        mov     r0, #255            @ ticks = 255, adjust to achieve 1 ms delay
        str     r0, [r7, #16]       @ store ticks
# for (i = 0; i < ms; i++)
        mov     r0, #0              @ i = 0;
        str     r0, [r7, #8]        @ store i
        b       F0                  @ branch to F3
# for (j = 0; j < tick; j++)
F1:     mov     r0, #0              @ j = 0;
        str     r0, [r7, #12]       @ store j
        b       F2                  @ branch to F5
F3:     ldr     r0, [r7, #12]       @ r0 <-- j
        add     r0, #1              @ j++
        str     r0, [r7, #12]       @ store j
F2:     ldr     r0, [r7, #12]       @ r0 <-- j
        ldr     r1, [r7, #16]       @ r1 <-- ticks
        cmp     r0, r1              @ compare j with ticks 
        blt     F3                  @ branch if j is less than ticks
        ldr     r0, [r7, #8]        @ r0 <-- i
        add     r0, #1              @ i++
        str     r0, [r7, #8]        @ store i
F0:     ldr     r0, [r7, #8]        @ r0 <-- i
        ldr     r1, [r7]            @ r1 <-- ms
        cmp     r0, r1              @ compare i with ms
        blt     F1                  @ branch if i is less than ms
        # Epilogue
        adds    r7, r7, #28
        mov	    sp, r7
        pop	    {r7}
        bx	    lr
