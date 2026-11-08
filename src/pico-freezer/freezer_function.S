.syntax unified
.cpu cortex-m0plus
.thumb

.section .time_critical.freezer_function, "ax"
.global freezer_function
.thumb_func
.align 2

.extern freezer_vars

@ --- Configuration / Definition Block ---
@ =============================================================================
@ SIO (Single-Cycle IO) REGISTER DEFINITIONS FOR RP2040
@ =============================================================================
.equ SIO_BASE,          0xd0000000  @ SIO Block Base Address

@ --- GPIO Input / Output Registers ---
.equ SIO_GPIO_IN,       0x00000004  @ [RO] Live state of all 30 GPIO pins
.equ SIO_GPIO_OUT,      0x00000010  @ [RW] GPIO output value
.equ SIO_GPIO_OUT_SET,  0x00000014  @ [WO] Atomic bit set for GPIO output
.equ SIO_GPIO_OUT_CLR,  0x00000018  @ [WO] Atomic bit clear for GPIO output
.equ SIO_GPIO_OUT_XOR,  0x0000001c  @ [WO] Atomic bit toggle for GPIO output

@ --- GPIO Output Enable (Direction) Registers ---
.equ SIO_GPIO_OE,       0x00000020  @ [RW] GPIO direction (0=Input, 1=Output)
.equ SIO_GPIO_OE_SET,   0x00000024  @ [WO] Atomic bit set for GPIO direction
.equ SIO_GPIO_OE_CLR,   0x00000028  @ [WO] Atomic bit clear for GPIO direction (Input Mode)
.equ SIO_GPIO_OE_XOR,   0x0000002c  @ [WO] Atomic bit toggle for GPIO direction

@ --- QSPI (Flash Pins) Registers ---
.equ SIO_GPIO_HI_IN,    0x00000008  @ [RO] Live state of QSPI pins
.equ SIO_GPIO_HI_OUT,   0x00000030  @ [RW] QSPI output value
.equ SIO_GPIO_HI_SET,   0x00000034  @ [WO] Atomic bit set for QSPI output
.equ SIO_GPIO_HI_CLR,   0x00000038  @ [WO] Atomic bit clear for QSPI output
.equ SIO_GPIO_HI_XOR,   0x0000003c  @ [WO] Atomic bit toggle for QSPI output
.equ SIO_GPIO_HI_OE,    0x00000040  @ [RW] QSPI direction
.equ SIO_GPIO_HI_OE_SET,0x00000044  @ [WO] Atomic bit set for QSPI direction
.equ SIO_GPIO_HI_OE_CLR,0x00000048  @ [WO] Atomic bit clear for QSPI direction
.equ SIO_GPIO_HI_OE_XOR,0x0000004c  @ [WO] Atomic bit toggle for QSPI direction

@ --- Hardware Inter-Core FIFO (For communication between Core 0 and Core 1) ---
.equ SIO_FIFO_ST,       0x00000050  @ [RW] Status register for FIFO (Full/Empty flags)
.equ SIO_FIFO_WR,       0x00000054  @ [WO] Write data to face-to-face Core FIFO
.equ SIO_FIFO_RD,       0x00000058  @ [RO] Read data from face-to-face Core FIFO

@ --- Hardware Spinlocks (For synchronization between cores) ---
.equ SIO_SPINLOCK_BASE, 0x00000100  @ Base offset for the 32 hardware spinlocks (0x100 - 0x17c)

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
.equ ADR_CHIPS_MASK_WRITE, 0x0000D800 | RW_MASK
.equ ADR_CHIPS, 0x0000D000

.equ FREEZER_STATE, 0x00
.equ FREEZER_ROM, 0x04
.equ FREEZER_RAM, 0x08

.equ FRZ_STATE_DISABLED, 0x00000000
.equ FRZ_STATE_INTERM, 0x00000004
.equ FRZ_STATE_ENABLED, 0x00000008
.equ FRZ_STATE_TEMP_DISABLED, 0x0000000C

@--------------------------------------------------
@ phi2 = 558ns, 138 cycles
@ phi2/2 = 279ns, 69 cycles
@--------------------------------------------------


freezer_function:

    cpsid i                         @1      turn off all interrupts

@ establish base addresses
@ r7: freezer_vars
@ r6: SIO base

    ldr r7, =freezer_vars           @ 1     pointer to variables
    ldr r6, =SIO_BASE               @ 2     Base address for SIO (Single-Cycle IO)

main_loop:
    ldr r1, =PHI2_MASK              @ 2
loop_until_phi2_low:
    ldr r0, [r6, SIO_GPIO_IN]       @ 2     r0 = live state of all 30 pins
    tst r0, r1                      @ 1
    bne loop_until_phi2_low         @ 3

    movs r0, #0                     @ 1     all pins input
    str r0, [r6, #SIO_GPIO_OE]      @ 2

@--------------------------------------------------
@ wait 144ns until address pins are valid
@ 4x9 = 36
@--------------------------------------------------
    movs r0, #9                     @ 1
loop_144ns:
    subs r0, #1                     @ 1
    bne loop_144ns                  @ 3

@--------------------------------------------------
@ now do things according to freezer's state
@--------------------------------------------------
    ldr r0, [r6, #SIO_GPIO_IN]      @ 2     r0 = live state of all 30 pins

    ldr r1, [r7, #FREEZER_STATE]    @ 2     r1 = status of freezer
    ldr r2, =jump_table             @ 2     r2 = jump_table
    ldr r2, [r1, r2]                @ 2     r2 = address of function to be called
    blx r2                          @ 3     subroutine call to function

    str r1, [r7, #FREEZER_STATE]    @ 2     always store status
    b main_loop                     @ 3

@--------------------------------------------------
@ r0: state of GPIOs
@ r1: freezer state
@ r2: address of this routine
@ r6: SIO_BASE
@ r7: variables
@--------------------------------------------------
do_disabled:

    movs r3, r0                     @ 1     save GPIOs
    ldr r2, =CPU_VEC_READ           @ 2
    ands r3, r2                     @ 1
    ldr r2, =CPU_VEC_READ_CMP
    cmp r3, r2                      @ 1
    bne do_disabled_d000            @ 3     no read VEC access

    movs r1, #FRZ_STATE_INTERM      @ 1
    b wait_phi2_high
    
do_disabled_d000:
    ldr r2, =ADR_CHIPS_MASK_WRITE   @ 2     mask out $d800 and read/write
    ands r3, r2                     @ 1
    ldr r2, =ADR_CHIPS              @ 2     WR = low!
    cmp r3, r2                      @ 1
    bne do_disabled_ex              @ 3     no chip address

@--------------------------------------------------
@ now check if 4 or 5 bits are needed
@ D000 GTIA     = 5 bits            1101 0000 000- ----
@ D200 POKEY    = 4 bits            1101 0001 0000 ----
@ D300 PIA      = 4 bits
@ D400 ANTIC    = 4 bits
@--------------------------------------------------

    movs r3, r0                     @ 1     get GPIOs
    ldr r2, =0x000000e0             @ 2
    tst r3, r2                      @ 1
    ldr r2, =0x0000071f             @ 2
    beq do_disabled_mask            @ 3
    subs r2, #16                    @ 1

do_disabled_mask:

    ands    r0, r2                  @ 1     mask out $7ff and bits 

@--------------------------------------------------
@ 51 + 29 = 80 cycles passed (69 per half phi2)
@ Tmds (write data delay = 100ns, 25 cycles)
@ 80-69 = 11, 25-11 = 14
@--------------------------------------------------

@
@   wait 16 cycles
@
    movs r3, #4                     @ 1
wait_16_cyc:
    subs r3, #1
    bne wait_16_cyc

    ldr r2, [r6, #SIO_GPIO_IN]      @ 2     r2 = live state of all 30 pins
    lsrs r2, r2, #16                @ 1
    ldr r3, =0x000000ff             @ 2
    ands r2, r3                     @ 1

    ldr r3, [r7, #FREEZER_RAM]      @ 2
    strb r2, [r3, r0]               @ 2

do_disabled_ex :
    bx lr                           @ 3     jump back to caller

@--------------------------------------------------
@
@--------------------------------------------------
do_intermediate:
    movs r1, #FRZ_STATE_DISABLED    @ 1     diable per default
    movs r3, r0                     @ 1     save GPIOs
    ldr r2, =CPU_VEC_READ           @ 2
    ands r3, r2                     @ 1
    ldr r2, =CPU_VEC_READ_CMP
    cmp r3, r2                      @ 1
    bne wait_phi2_high              @ 3

    movs r1, #FRZ_STATE_ENABLED     @ 1     enable freezer
    b wait_phi2_high                @ 3

@--------------------------------------------------
@
@--------------------------------------------------
do_enabled:
    bx lr                           @ 3     jump back to caller

@--------------------------------------------------
@
@--------------------------------------------------
do_temp_disabled:
    bx lr                           @ 3     jump back to caller

@--------------------------------------------------
@
@--------------------------------------------------
wait_phi2_high:
   ldr r2, =PHI2_MASK
wait_phi2_high_loop:
    ldr r0, [r6, #SIO_GPIO_IN]      @ 2     r0 = live state of all 30 pins
    tst r0, r2
    beq wait_phi2_high_loop

    bx lr                           @ 3     jump back to caller

@ =============================================================================
@ THE JUMP TABLE (Must be aligned and hold 32-bit addresses)
@ =============================================================================
.align 2
jump_table:
    .word do_disabled + 1           @ Address for Index 0 (+1 enforces Thumb Mode!)
    .word do_intermediate + 1       @ Address for Index 1 (+1 enforces Thumb Mode!)
    .word do_enabled + 1            @ Address for Index 2 (+1 enforces Thumb Mode!)
    .word do_temp_disabled + 1      @ Address for Index 3 (+1 enforces Thumb Mode!)
