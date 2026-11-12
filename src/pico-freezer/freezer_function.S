.syntax unified
.cpu cortex-m0plus
.thumb

.section .time_critical.freezer_function, "ax"
.global freezer_function
.thumb_func
.align 2

.extern freezer_vars

@ --- Configuration / Definition Block ---
#include "sio_registers.inc"

@
@ freezer addresses and constants
@
.equ ADR_MASK, 0x0000ffff
.equ DATA_MASK, 0x00ff0000
.equ RW_MASK, 0x01000000
.equ PHI2_MASK, 0x02000000
.equ REF_MASK, 0x04000000
.equ RST_MASK, 0x08000000
.equ FREEZE_MASK, 0x10000000

.equ CPU_VEC, 0x0000fff8
.equ CPU_VEC_READ, CPU_VEC | RW_MASK | FREEZE_MASK
.equ CPU_VEC_READ_CMP, CPU_VEC | RW_MASK
.equ ADR_CHIPS_MASK, 0x0000D800
.equ ADR_CHIPS_MASK_WRITE, ADR_CHIPS_MASK | RW_MASK
.equ ADR_CHIPS, 0x0000D000
.equ MASK_8K, 0x00001fff
.equ MASK_E000, 0x0000e000
.equ MASK_0000, 0x00000000
.equ MASK_2000, 0x00002000

.equ FREEZER_STATE, 0x00
.equ FREEZER_ROM, 0x04
.equ FREEZER_RAM, 0x08
.equ FREEZER_ROM_BANK, 0x0C

.equ FRZ_STATE_DISABLED, 0x00000000
.equ FRZ_STATE_INTERM, 0x00000004
.equ FRZ_STATE_ENABLED, 0x00000008
.equ FRZ_STATE_TEMP_DISABLED, 0x0000000C

@--------------------------------------------------
@ PAL PHI2 ~= 565ns (1.77MHz), 142 Pico cycles at 250MHz (rounded up)
@ PHI2/2 ~= 283ns, 71 Pico cycles at 250MHz (rounded up)
@ CPU addresses will we valid after 140ns after PHI2 low
@ write Data will be available after 100ns after PHI2 high
@ read Data must be provided min. 50ns before phi2 low
@--------------------------------------------------

freezer_function:

    cpsid i                         @1      turn off all interrupts

@ establish base addresses
@ r7: freezer_vars
@ r6: SIO base

    ldr r7, =freezer_vars           @ 2     pointer to variables
    ldr r6, =SIO_BASE               @ 2     Base address for SIO (Single-Cycle IO)

main_loop:
    ldr r2, =PHI2_MASK              @ 2     wait for PHI2 low
wait_phi2_low_loop:
    ldr r0, [r6, #SIO_GPIO_IN]      @ 2
    tst r0, r2                      @ 1
    bne wait_phi2_low_loop          @ 2     taken / 1 final not taken

    ldr r2, =REF_MASK               @ 2     load REF_MASK into r2
    str r2, [r6, #SIO_GPIO_OE]      @ 2     make just REF output; PHI2 stays input
    str r2, [r6, #SIO_GPIO_OUT_SET] @ 2     set ref high
    
    ldr r1, [r7, #FREEZER_STATE]    @ 2     r1 = status of freezer
    ldr r2, =jump_table             @ 2     r2 = jump_table
    ldr r2, [r1, r2]                @ 2     r2 = address of function to be called

    @ GPIO sample at 40 cycles, saved at 41; dispatch at 43 cycles after PHI2 low.
    movs r3, #8                     @ 1
wait_disabled_92ns:
    subs r3, #1                     @ 1
    bne wait_disabled_92ns          @ 2     23 cycles total; 92 ns

    ldr r0, [r6, #SIO_GPIO_IN]      @ 2     refresh GPIO sample after delay
    movs r3, r0                     @ 1     save GPIO sample for state handlers
    bx r2                           @ 2     dispatch after PHI2 falls and address is valid

@--------------------------------------------------
@ r0: state of GPIOs
@ r1: freezer state
@ r2: address of this routine
@ r6: SIO_BASE
@ r7: variables
@--------------------------------------------------

@43-48 cycles from PHI2 low to this point
do_disabled:

do_disabled_d000:
    ldr r2, =ADR_CHIPS_MASK_WRITE   @ 2     mask out $d800 and read/write
    ands r3, r2                     @ 1
    ldr r2, =ADR_CHIPS              @ 2     WR = low!
    cmp r3, r2                      @ 1
    bne do_disabled_vector_check    @ 2     taken / 1 not taken; no D000 write

@--------------------------------------------------
@ now check if 4 or 5 bits are needed
@ D000 GTIA     = 5 bits            1101 0000 000- ----
@ D200 POKEY    = 4 bits            1101 0001 0000 ----
@ D300 PIA      = 4 bits
@ D400 ANTIC    = 4 bits
@--------------------------------------------------

    movs r3, r0                     @ 1     get GPIOs
    ldr r2, =0x00000e00             @ 2
    tst r3, r2                      @ 1
    ldr r2, =0x0000071f             @ 2
    beq do_disabled_mask            @ 2     taken / 1 not taken
    subs r2, #16                    @ 1

do_disabled_mask:

    ands    r0, r2                  @ 1     mask out $7ff and bits 

@--------------------------------------------------
@ 59 source cycles from completed PHI2-low sample to this point (D000 path)
@ Data bus is expected valid about 343ns after PHI2 low; round up to 344ns = 86 cycles
@ 59 + 24 + 1 + 2 = 86 cycles to the GPIO data sample
@--------------------------------------------------

@
@   24-cycle delay loop + 1-cycle NOP + 2-cycle GPIO read = 27 cycles to sample
@
    movs r3, #8                     @ 1     loop total = 24 cycles including setup
wait_24_cyc:
    subs r3, #1                     @ 1
    bne wait_24_cyc                 @ 2     taken / 1 final not taken

    nop                             @ 1     total delay from sample = 25 cycles

@ Read data after at least 344ns from PHI2 low; data is expected valid by ~=343ns

    ldr r2, [r6, #SIO_GPIO_IN]      @ 2     r2 = live state of all 30 pins
    lsrs r2, r2, #16                @ 1     shift data to the rigth
    ldr r3, =0x000000ff             @ 2     keep only lower 8 bits
    ands r2, r3                     @ 1

    ldr r3, [r7, #FREEZER_RAM]      @ 2     get pointer to freezer RAM
    strb r2, [r3, r0]               @ 2     store sampled GPIO data into freezer RAM

    b state_done                    @ 2

do_disabled_vector_check:
    movs r3, r0                     @ 1     restore sampled GPIOs for vector check
    ldr r2, =CPU_VEC_READ           @ 2
    ands r3, r2                     @ 1
    ldr r2, =CPU_VEC_READ_CMP       @ 2
    cmp r3, r2                      @ 1
    bne wait_phi2_high @ 2 taken / 1 not taken; no vector read

    movs r1, #FRZ_STATE_INTERM      @ 1

@ Wait only after this vector check, then commit its state.
@ 250MHz: 1 cycle = 4ns; PAL PHI2 half-cycle ~=283ns = 71 cycles.
@ While low: LDR 2 + TST 1 + BEQ taken 2 = 5 cycles (20ns per poll).
@ Final high poll: LDR 2 + TST 1 + BEQ not taken 1 = 4 cycles (16ns).
wait_phi2_high:
    ldr r2, =PHI2_MASK              @ 2
wait_phi2_high_loop:
    ldr r0, [r6, #SIO_GPIO_IN]      @ 2
    tst r0, r2                      @ 1
    beq wait_phi2_high_loop         @ 2 taken / 1 final not taken

    b state_done                    @ 2

@--------------------------------------------------
@ if there is a second read from CPU_VEC, enable freezer
@--------------------------------------------------
do_intermediate:
    movs r1, #FRZ_STATE_DISABLED    @ 1     diable per default
    ldr r2, =CPU_VEC_READ           @ 2
    ands r3, r2                     @ 1
    ldr r2, =CPU_VEC_READ_CMP       @ 2
    cmp r3, r2                      @ 1
    bne wait_phi2_high              @ 2     taken / 1 not taken

    ldr r2, =REF_MASK               @ 2
    str r2, [r6, #SIO_GPIO_OUT_CLR] @ 2     drive REF low
    movs r1, #FRZ_STATE_ENABLED     @ 1     enable freezer

@224-244ns from PHI2 falling edge here (56 cycles + 0-20ns poll phase)

@ 84ns = 21 cycles at 250MHz
    movs r2, #7                     @ 1
wait_84ns:
    subs r2, #1                     @ 1
    bne wait_84ns                   @ 2     taken / 1 final not taken

    ldr r0, =MASK_8K                @ 2     load 8K mask into r0
    ands r3, r0                     @ 1     mask with 8K mask

    ldr r0, [r7, #FREEZER_ROM]      @ 2     get pointer to freezer ROM
    ldrb r2, [r7, #FREEZER_ROM_BANK] @ 2     get current ROM bank
    lsls r2, r2, #13                @ 1     shift ROM bank to correct position
    orrs r0, r2                     @ 1     add ROM bank offset to pointer
    ldrb r0, [r0, r3]               @ 2     load freezer RAM entry indexed by masked GPIOs
    lsls r0, r0, #16                @ 1     shift data to right position for output
    str r0, [r6, #SIO_GPIO_OUT]     @ 2     output value

@ 364-384ns from PHI2 falling edge to this instruction (91 cycles + poll phase).
    ldr r2, =DATA_MASK              @ 2     load DATA mask into r2
    str r2, [r6, #SIO_GPIO_OE_SET]  @ 2     set DATA bus to output
    b state_done                    @ 2

@--------------------------------------------------
@ freezer enabled respond to
@ RAM : $0000-$1FFF
@ ROM : $2000-$3FFF
@ 43-48 cycles from PHI2 low to this point
@--------------------------------------------------
do_enabled:

    ldr r2, =MASK_E000              @ 2     
    ands r3, r2                     @ 1
    ldr r2, #0                      @ 1
    cmp r3, r2                      @ 1
    bne do_enabled_ram              @ 2     taken / 1 not taken

    ldr r2, =MASK_2000              @ 2
    cmp r3, r2                      @ 1
    bne wait_phi2_high              @ 1/2

do_enabled_rom:
    ldr r2, =RW_MASK                @ 2     check if RW high
    tst r0, r2                      @ 1
    beq wait_phi2_high              @ 1/2   exit if low

    ldr r2, =MASK_8K                @ 2
    ands r0, r2                     @ 1
    ldr r2, [r7, #FREEZER_ROM]      @ 2
    ldrb r2, [r0, r2]               @ 2

@

do_enabled_ram:


    b state_done                    @ 2

@--------------------------------------------------
@
@--------------------------------------------------
do_temp_disabled:
    b state_done                    @ 2

state_done:
    str r1, [r7, #FREEZER_STATE]    @ 2     commit state before the next dispatch
    b main_loop                     @ 2

@ =============================================================================
@ THE JUMP TABLE (Must be aligned and hold 32-bit addresses)
@ =============================================================================
.align 2
jump_table:
    .word do_disabled + 1           @ Address for Index 0 (+1 enforces Thumb Mode!)
    .word do_intermediate + 1       @ Address for Index 1 (+1 enforces Thumb Mode!)
    .word do_enabled + 1            @ Address for Index 2 (+1 enforces Thumb Mode!)
    .word do_temp_disabled + 1      @ Address for Index 3 (+1 enforces Thumb Mode!)
