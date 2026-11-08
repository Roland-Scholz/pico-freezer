/*
================================================================================
DATA TRANSFER (LOAD & STORE) - ALL RAM ACCESSES TAKE EXACTLY 2 CYCLES
================================================================================
ldr   Rd, [Rb, #imm]   ; Rd = Memory[Rb + imm]       (32-bit, imm = 0..124, div4)
ldr   Rd, [Rb, Ro]     ; Rd = Memory[Rb + Ro]        (32-bit, index register)
ldr   Rd, [sp, #imm]   ; Rd = Memory[sp + imm]       (32-bit stack, imm = 0..1020, div4)
str   Rd, [Rb, #imm]   ; Memory[Rb + imm] = Rd       (32-bit, imm = 0..124, div4)
str   Rd, [Rb, Ro]     ; Memory[Rb + Ro] = Rd        (32-bit, index register)
str   Rd, [sp, #imm]   ; Memory[sp + imm] = Rd       (32-bit stack, imm = 0..1020, div4)

ldrb  Rd, [Rb, #imm]   ; Rd = Memory[Rb + imm]       (8-bit, imm = 0..31)
ldrb  Rd, [Rb, Ro]     ; Rd = Memory[Rb + Ro]        (8-bit, index register)
strb  Rd, [Rb, #imm]   ; Memory[Rb + imm] = Rd       (8-bit, imm = 0..31)
strb  Rd, [Rb, Ro]     ; Memory[Rb + Ro] = Rd        (8-bit, index register)

ldrh  Rd, [Rb, #imm]   ; Rd = Memory[Rb + imm]       (16-bit, imm = 0..62, div2)
ldrh  Rd, [Rb, Ro]     ; Rd = Memory[Rb + Ro]        (16-bit, index register)
strh  Rd, [Rb, #imm]   ; Memory[Rb + imm] = Rd       (16-bit, imm = 0..62, div2)
strh  Rd, [Rb, Ro]     ; Memory[Rb + Ro] = Rd        (16-bit, index register)

ldrsb Rd, [Rb, Ro]     ; Rd = SignExtend(Memory[Rb + Ro]) (8-bit signed)
ldrsh Rd, [Rb, Ro]     ; Rd = SignExtend(Memory[Rb + Ro]) (16-bit signed)

================================================================================
REGISTER MOVEMENT & CONSTANTS - 1 CYCLE
================================================================================
movs  Rd, #imm         ; Rd = imm                    (Low reg, imm = 0..255, sets flags)
mov   Rd, Rm           ; Rd = Rm                     (Low to Low, sets flags)
mov   R_high, R        ; Rd = Rm                     (High reg involved, NO flags)
mvns  Rd, Rm           ; Rd = NOT Rm                 (Bitwise NOT, sets flags)

================================================================================
ARITHMETIC - 1 CYCLE (MUL TAKES 1-3 CYCLES)
================================================================================
adds  Rd, Rn, Rm       ; Rd = Rn + Rm
subs  Rd, Rn, Rm       ; Rd = Rn - Rm
adds  Rd, #imm         ; Rd = Rd + imm               (imm = 0..255)
adds  Rd, Rn, #imm     ; Rd = Rn + imm               (imm = 0..7)
subs  Rd, #imm         ; Rd = Rd - imm               (imm = 0..255)
subs  Rd, Rn, #imm     ; Rd = Rn - imm               (imm = 0..7)
adcs  Rd, Rm           ; Rd = Rd + Rm + Carry
sbcs  Rd, Rm           ; Rd = Rd - Rm - NOT Carry
muls  Rd, Rm           ; Rd = Rd * Rm                (Destructive, 1-3 cycles)
rsbs  Rd, Rn, #0       ; Rd = 0 - Rn                 (Negate value)

================================================================================
LOGIC & SHIFTS - 1 CYCLE
================================================================================
ands  Rd, Rm           ; Rd = Rd AND Rm
orrs  Rd, Rm           ; Rd = Rd OR Rm
eors  Rd, Rm           ; Rd = Rd XOR Rm
bics  Rd, Rm           ; Rd = Rd AND (NOT Rm)        (Bit clear)
lsls  Rd, Rm, #imm     ; Rd = Rm << imm              (Logical shift left, imm = 0..31)
lsrs  Rd, Rm, #imm     ; Rd = Rm >> imm              (Logical shift right, imm = 1..32)
asrs  Rd, Rm, #imm     ; Rd = Rm >> imm              (Arithmetic shift right, signs)
lsls  Rd, Rm           ; Rd = Rd << Rm               (Shift by register value)
lsrs  Rd, Rm           ; Rd = Rd >> Rm               (Shift by register value)
asrs  Rd, Rm           ; Rd = Rd >> Rm               (Shift by register value)
rors  Rd, Rm           ; Rd = Rotate_Right(Rd, Rm)

================================================================================
COMPARES & BIT TESTS - 1 CYCLE (ONLY UPDATES FLAGS Z, N, C, V)
================================================================================
cmp   Rn, Rm           ; Calculates Rn - Rm          (Compare registers)
cmp   Rn, #imm         ; Calculates Rn - imm         (Compare with imm = 0..255)
cmn   Rn, Rm           ; Calculates Rn + Rm          (Compare negative)
tst   Rn, Rm           ; Calculates Rn AND Rm        (Bit test)

================================================================================
BRANCHES - 3 CYCLES IF TAKEN, 1 CYCLE IF NOT TAKEN
================================================================================
b     label            ; Unconditional jump          (3 cycles)
b{cond} label          ; Conditional jump            (3 cycles taken / 1 cycle not)
bx    Rm               ; Jump to address in Rm       (3 cycles, e.g., bx lr)
bl    label            ; Call function               (3 cycles, stores return in lr)
blx   Rm               ; Call function from Rm       (3 cycles)

Suffixes {cond}:
eq (==), ne (!=), cs/hs (Carry/👁️>=), cc/lo (No Carry/👁️<), mi (-), pl (+), 
hi (> unsigned), ls (<= unsigned), ge (>= signed), lt (< signed), 
gt (> signed), le (<= signed)

================================================================================
STACK OPERATIONS - 1 + N CYCLES (N = NUMBER OF REGISTERS)
================================================================================
push  {reglist}        ; Push registers onto stack   (e.g., push {r4-r6, lr})
pop   {reglist}        ; Pop registers from stack    (e.g., pop {r4-r6, pc})

================================================================================
SPECIAL & SYSTEM - 1 CYCLE
================================================================================
rev   Rd, Rm           ; Byte reverse 32-bit         (Endianness swap)
rev16 Rd, Rm           ; Byte reverse 16-bit halves
sxtb  Rd, Rm           ; Sign extend byte to 32-bit
sxth  Rd, Rm           ; Sign extend halfword to 32-bit
uxtb  Rd, Rm           ; Zero extend byte to 32-bit
uxth  Rd, Rm           ; Zero extend halfword to 32-bit
cpsid i                ; Disable interrupts globally
cpsie i                ; Enable interrupts globally
nop                    ; No operation
wfi                    ; Wait for interrupt          (Low power standby)
bkpt  #imm             ; Software breakpoint         (Halts CPU for debugger)
*/