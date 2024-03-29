#include <inttypes.h>
#include <stdio.h>

#include "bcm2835_systimers.h"
#include "irq.h"

#define DEFAULT_TIMER   3

extern int wait_for_timer;

void __attribute__((isr("ABORT"))) reset_vector(void)
{
    printf("\ninterrupt: ABORT\n");
}

void __attribute__((isr("UNDEF"))) undefined_instruction_vector(void)
{
    printf("interrupt: UNDEF\n");
    while(1)
    {

    }
}

void __attribute__((isr("SWI"))) software_interrupt_vector(void)
{
    printf("interrupt: SWI\n");
    while(1)
    {

    }
}

void __attribute__((isr("ABORT"))) prefetch_abort_vector(void)
{
    printf("\ninterrupt: ABORT\n");
}

void __attribute__((isr("ABORT"))) data_abort_vector(void)
{
    printf("\ninterrupt: ABORT\n");
}

void __attribute__((isr("IRQ"))) interrupt_vector(void)
{
    uint32_t cpsr = disable_irqs();

    bcm2835_st_ack_timer(DEFAULT_TIMER);

    wait_for_timer = 0;

    printf("\ninterrupt: IRQ\n");

    restore_irqs(cpsr);
}

void __attribute__((isr("FIQ"))) fast_interrupt_vector(void)
{
    printf("\ninterrupt: FIQ\n");
}
