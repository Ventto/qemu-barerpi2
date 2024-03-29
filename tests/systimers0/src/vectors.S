.section .text

.align 4
/** From ARM Architecture Reference Manual: ARMv7-A and ARMv7-R edition
    B1.8.1 Exception vectors and exception base address
    Interrupt Vector Table */
_vectors_:
        ldr pc, _reset_h
        ldr pc, _undef_h
        ldr pc, _swi_h       /* A8.8.228: Previously called SWI, now SVC */
        ldr pc, _prefetch_h
        ldr pc, _data_h
        ldr pc, _unused_h
        ldr pc, _irq_h
        ldr pc, _fiq_h

/* Constants that hold interrupt service routine's addresses. */
 _reset_h     : .word   _reset
 _undef_h     : .word   undefined_instruction_vector
 _swi_h       : .word   software_interrupt_vector
 _prefetch_h  : .word   prefetch_abort_vector
 _data_h      : .word   data_abort_vector
 _unused_h    : .word   _reset
 _irq_h       : .word   interrupt_vector
 _fiq_h       : .word   fast_interrupt_vector

.global _reset
_reset:
        /* Copy the vector table at 0x8000 to the active table at 0x0000 */
        ldr     r0, =_vectors_
        mov     r1, #0x0000

        /* -- Loads vector table (8*32bits) and increments */
        ldmia   r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
        stmia   r1!,{r2, r3, r4, r5, r6, r7, r8, r9}

        /* -- Loads constants (8*32bits) and increments */
        ldmia   r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
        stmia   r1!,{r2, r3, r4, r5, r6, r7, r8, r9}

        /** B1.3.1: Processor Modes

            | Proc. mode | Encoding     | Privilege Level |
            | IRQ        | 10010 - 0x12 | PL1             |
            | SVC        | 10011 - 0x13 | PL1             |

            B1.3.3: Program status registers (PSR)

                * Mask bits [8:6]:
                    - IRQ: bit[7] - 010
                    - FIQ: bit[6] - 001

                * Mode field [0:4]:
                    (see the table above)

                Ex:
                    0xD2:   [011]           [0]     [10010]
                            ^---(irq+fiq)   ^---(T) ^---(IRQ mode)
                    0xD3:   [011]           [0]     [10010]
                                                    ^---(SVC mode)
            */
        /*  Interrupt stack initialization */
        mov r0,#0xD2
        msr cpsr_c,r0
        mov sp,#(63 * 1024 * 1024)

        /*  Applicative stack initialization */
        mov r0,#0xD3
        msr cpsr_c,r0
        mov sp,#(64 * 1024 * 1024)

        bl  not_main

        /* If main returns for some reason than loop forever */
        b .
