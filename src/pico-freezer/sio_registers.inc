@ RP2040 SIO (Single-Cycle IO) register definitions
.equ SIO_BASE,          0xd0000000  @ SIO block base address

@ GPIO input / output registers
.equ SIO_GPIO_IN,       0x00000004  @ [RO] Live state of all 30 GPIO pins
.equ SIO_GPIO_OUT,      0x00000010  @ [RW] GPIO output value
.equ SIO_GPIO_OUT_SET,  0x00000014  @ [WO] Atomic bit set for GPIO output
.equ SIO_GPIO_OUT_CLR,  0x00000018  @ [WO] Atomic bit clear for GPIO output
.equ SIO_GPIO_OUT_XOR,  0x0000001c  @ [WO] Atomic bit toggle for GPIO output

@ GPIO output enable (direction) registers
.equ SIO_GPIO_OE,       0x00000020  @ [RW] GPIO direction (0=Input, 1=Output)
.equ SIO_GPIO_OE_SET,   0x00000024  @ [WO] Atomic bit set for GPIO direction
.equ SIO_GPIO_OE_CLR,   0x00000028  @ [WO] Atomic bit clear for GPIO direction (Input Mode)
.equ SIO_GPIO_OE_XOR,   0x0000002c  @ [WO] Atomic bit toggle for GPIO direction

@ QSPI (flash pins) registers
.equ SIO_GPIO_HI_IN,    0x00000008  @ [RO] Live state of QSPI pins
.equ SIO_GPIO_HI_OUT,   0x00000030  @ [RW] QSPI output value
.equ SIO_GPIO_HI_SET,   0x00000034  @ [WO] Atomic bit set for QSPI output
.equ SIO_GPIO_HI_CLR,   0x00000038  @ [WO] Atomic bit clear for QSPI output
.equ SIO_GPIO_HI_XOR,   0x0000003c  @ [WO] Atomic bit toggle for QSPI output
.equ SIO_GPIO_HI_OE,    0x00000040  @ [RW] QSPI direction
.equ SIO_GPIO_HI_OE_SET,0x00000044  @ [WO] Atomic bit set for QSPI direction
.equ SIO_GPIO_HI_OE_CLR,0x00000048  @ [WO] Atomic bit clear for QSPI direction
.equ SIO_GPIO_HI_OE_XOR,0x0000004c  @ [WO] Atomic bit toggle for QSPI direction

@ Hardware inter-core FIFO registers
.equ SIO_FIFO_ST,       0x00000050  @ [RW] Status register for FIFO (Full/Empty flags)
.equ SIO_FIFO_WR,       0x00000054  @ [WO] Write data to face-to-face Core FIFO
.equ SIO_FIFO_RD,       0x00000058  @ [RO] Read data from face-to-face Core FIFO

@ Hardware spinlock registers (32 locks, offsets 0x100-0x17c)
.equ SIO_SPINLOCK_BASE, 0x00000100