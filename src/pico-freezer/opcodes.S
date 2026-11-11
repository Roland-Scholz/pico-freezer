/*
CORTEX-M0+ THUMB (ARMv6-M) INSTRUCTION REFERENCE
Cycle counts are core cycles with zero wait states. Memory wait states and
system/peripheral stalls add cycles. "var." means the duration is not fixed.

| Takte | Opcode / operands    | Beschreibung                                       |
+-------+----------------------+----------------------------------------------------+

DATA TRANSFER
| 2     | ldr  Rt, [Rn, #imm]  | Word load; imm = 0..124, multiple of 4             |
| 2     | ldr  Rt, [Rn, Rm]    | Word load, register offset                         |
| 2     | ldr  Rt, [sp, #imm]  | Word load from stack; imm = 0..1020, /4            |
| 2     | ldr  Rt, [pc, #imm]  | PC-relative word load (literal pool)               |
| 2     | ldrb Rt, [Rn, #imm]  | Byte load; imm = 0..31                             |
| 2     | ldrb Rt, [Rn, Rm]    | Byte load, register offset                         |
| 2     | ldrh Rt, [Rn, #imm]  | Halfword load; imm = 0..62, /2                     |
| 2     | ldrh Rt, [Rn, Rm]    | Halfword load, register offset                     |
| 2     | ldrsb Rt, [Rn, Rm]   | Signed byte load                                   |
| 2     | ldrsh Rt, [Rn, Rm]   | Signed halfword load                               |
| 2     | str  Rt, [Rn, #imm]  | Word store; imm = 0..124, multiple of 4            |
| 2     | str  Rt, [Rn, Rm]    | Word store, register offset                        |
| 2     | str  Rt, [sp, #imm]  | Word store to stack; imm = 0..1020, /4             |
| 2     | strb Rt, [Rn, #imm]  | Byte store; imm = 0..31                            |
| 2     | strb Rt, [Rn, Rm]    | Byte store, register offset                        |
| 2     | strh Rt, [Rn, #imm]  | Halfword store; imm = 0..62, /2                    |
| 2     | strh Rt, [Rn, Rm]    | Halfword store, register offset                    |
| 1+N   | ldmia Rn!, {reglist} | Load multiple; N = number of registers             |
| 1+N   | stmia Rn!, {reglist} | Store multiple; N = number of registers            |

ADDRESS GENERATION & REGISTER MOVEMENT
| 1     | adr Rd, label        | PC-relative address generation                     |
| 1     | add Rd, sp, #imm     | SP-relative address; imm = 0..1020, /4             |
| 1     | add sp, #imm         | Adjust SP up; imm = 0..508, /4                     |
| 1     | sub sp, #imm         | Adjust SP down; imm = 0..508, /4                   |
| 1     | movs Rd, #imm        | Move immediate; low register, imm = 0..255         |
| 1     | movs Rd, Rm          | Move low registers; sets flags                     |
| 1     | mov Rd, Rm           | Move involving high register; no flags             |

ARITHMETIC
| 1     | adds Rd, Rn, Rm      | Add registers; sets flags                          |
| 1     | adds Rd, #imm        | Add to Rd; imm = 0..255                            |
| 1     | adds Rd, Rn, #imm    | Add immediate; imm = 0..7                          |
| 1     | add Rd, Rm           | Add registers, including high registers; no flags  |
| 1     | subs Rd, Rn, Rm      | Subtract registers; sets flags                     |
| 1     | subs Rd, #imm        | Subtract from Rd; imm = 0..255                     |
| 1     | subs Rd, Rn, #imm    | Subtract immediate; imm = 0..7                     |
| 1     | adcs Rd, Rm          | Add with carry                                     |
| 1     | sbcs Rd, Rm          | Subtract with carry                                |
| var.  | muls Rd, Rm          | Multiply; result replaces Rd                       |
| 1     | rsbs Rd, Rn, #0      | Reverse subtract from zero (negate)                |

LOGIC & SHIFTS
| 1     | ands Rd, Rm          | Bitwise AND                                        |
| 1     | eors Rd, Rm          | Bitwise XOR                                        |
| 1     | orrs Rd, Rm          | Bitwise OR; Rd = Rd OR Rm; sets N/Z flags          |
| 1     | bics Rd, Rm          | Rd = Rd AND NOT Rm                                 |
| 1     | mvns Rd, Rm          | Bitwise NOT                                        |
| 1     | lsls Rd, Rm, #imm    | Logical shift left; imm = 0..31                    |
| 1     | lsrs Rd, Rm, #imm    | Logical shift right; imm = 1..32                   |
| 1     | asrs Rd, Rm, #imm    | Arithmetic shift right; imm = 1..32                |
| 1     | lsls Rd, Rm          | Logical shift left by register                     |
| 1     | lsrs Rd, Rm          | Logical shift right by register                    |
| 1     | asrs Rd, Rm          | Arithmetic shift right by register                 |
| 1     | rors Rd, Rm          | Rotate right by register                           |

COMPARE & TEST (update flags, do not store a result)
| 1     | cmp Rn, Rm           | Compare registers (Rn - Rm)                        |
| 1     | cmp Rn, #imm         | Compare immediate; imm = 0..255                    |
| 1     | cmn Rn, Rm           | Compare negative (Rn + Rm)                         |
| 1     | tst Rn, Rm           | Test bits (Rn AND Rm)                              |

BRANCHES
| 2     | b label              | Unconditional branch                               |
| 1/2   | b{cond} label        | Conditional branch: not taken / taken              |
| 1/2   | cbz Rn, label        | Branch if zero: not taken / taken                  |
| 1/2   | cbnz Rn, label       | Branch if nonzero: not taken / taken               |
| 2     | bx Rm                | Branch to register (e.g. bx lr)                    |
| 3     | bl label             | Branch with link; call, return address in lr       |
| 2     | blx Rm               | Branch with link to register                       |

Condition suffixes for B: eq (equal), ne (not equal), cs/hs (carry set),
cc/lo (carry clear), mi (minus), pl (plus), vs (overflow), vc (no overflow),
hi (unsigned higher), ls (unsigned lower or same), ge (signed greater/equal),
lt (signed less), gt (signed greater), le (signed less/equal).

STACK OPERATIONS
| 1+N   | push {reglist}       | Push registers; N = number of registers            |
| 1+N   | pop {reglist}        | Pop registers; N = number of registers             |

SPECIAL, SYSTEM & HINT INSTRUCTIONS
| 1     | rev Rd, Rm           | Reverse byte order                                 |
| 1     | rev16 Rd, Rm         | Reverse bytes in each halfword                     |
| 1     | revsh Rd, Rm         | Reverse low halfword bytes, sign extend            |
| 1     | sxtb Rd, Rm          | Sign-extend byte                                   |
| 1     | sxth Rd, Rm          | Sign-extend halfword                               |
| 1     | uxtb Rd, Rm          | Zero-extend byte                                   |
| 1     | uxth Rd, Rm          | Zero-extend halfword                               |
| 1     | mrs Rd, special_reg  | Read special register                              |
| 1     | msr special_reg, Rn  | Write special register                             |
| 1     | cpsie i              | Enable interrupts                                  |
| 1     | cpsid i              | Disable interrupts                                 |
| 1     | it{x{y{z}}} cond     | If-Then block for conditional execution            |
| 1     | nop                  | No operation                                       |
| var.  | dmb                  | Data memory barrier; may wait for memory           |
| var.  | dsb                  | Data synchronization barrier; waits for completion |
| var.  | isb                  | Instruction synchronization barrier                |
| var.  | wfe                  | Wait for event; resumes on event                   |
| var.  | wfi                  | Wait for interrupt                                 |
| var.  | sev                  | Send event to cores/event mechanism                |
| 1     | yield                | Hint to scheduler or multithreading logic          |
| var.  | svc #imm             | Supervisor call; exception-entry latency applies   |
| var.  | bkpt #imm            | Breakpoint; behavior depends on debugger           |
| var.  | udf #imm             | Undefined instruction; causes an exception         |

This list covers the architectural Cortex-M0+ Thumb instruction set, not
Thumb-2 instructions or assembler pseudo-instructions. N is the register count.
*/