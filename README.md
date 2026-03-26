# Custom CPU from Scratch

> Designing a Custom CPU from Scratch to learn more about CPU and hardware

---

## Overview

- **Architecture:** 16-bit, custom RISC-style
- **Target:** Simulation (Verilog / testbench)
- **Tools:** Verilog HDL, `timescale 1ns / 1ps`

---

## Goals

- [ ] Goal 1
- [ ] Goal 2
- [ ] Goal 3

---

### Instruction Set Architecture (ISA)

### Instruction Register Layout (32-bit IR)

| Bits      | Field         | Description                        |
|-----------|---------------|------------------------------------|
| IR[31:27] | `oper_type`   | 5-bit opcode                       |
| IR[26:22] | `rdst`        | Destination register               |
| IR[21:17] | `rsrc1`       | Source register 1                  |
| IR[16]    | `imm_mode`    | 0 = register mode, 1 = immediate   |
| IR[15:11] | `rsrc2`       | Source register 2 (register mode)  |
| IR[15:0]  | `isrc`        | 16-bit immediate value (imm mode)  |

### Supported Instructions

| Opcode    | Mnemonic  | Operation                                      |
|-----------|-----------|------------------------------------------------|
| `5'b00000`| `movsgpr` | Move SGPR → GPR[rdst]                          |
| `5'b00001`| `mov`     | Move immediate or GPR[rsrc1] → GPR[rdst]       |
| `5'b00010`| `add`     | GPR[rsrc1] + rsrc2/imm → GPR[rdst]             |
| `5'b00011`| `sub`     | GPR[rsrc1] - rsrc2/imm → GPR[rdst]             |
| `5'b00100`| `mul`     | GPR[rsrc1] × rsrc2/imm → GPR[rdst] + SGPR     |
| `5'b00101`| `ror`     | Bitwise OR  → GPR[rdst]                        |
| `5'b00110`| `rand`    | Bitwise AND → GPR[rdst]                        |
| `5'b00111`| `rxor`    | Bitwise XOR → GPR[rdst]                        |
| `5'b01000`| `rxnor`   | Bitwise XNOR → GPR[rdst]                      |
| `5'b01001`| `rnand`   | Bitwise NAND → GPR[rdst]                      |
| `5'b01010`| `rnor`    | Bitwise NOR → GPR[rdst]                       |
| `5'b01011`| `rnot`    | Bitwise NOT → GPR[rdst]                       |

### Registers

- **GPR[0..31]** — 32 general-purpose registers, each 16-bit wide
- **SGPR** — 16-bit special register storing the upper 16 bits of a multiplication result
- **mul_res** — internal 32-bit wire used to capture full multiplication product before splitting

### Addressing Modes

- **Register mode** (`imm_mode = 0`): operand sourced from `GPR[rsrc2]`
- **Immediate mode** (`imm_mode = 1`): operand is the 16-bit literal embedded in `IR[15:0]`
---

## Progress Log

### Entry 001 — YYYY-MM-DD — _Title_
**What I worked on:**
_Created the ALU unit and describing the registers of the CPU._

**Decisions made:**
- 16 Bit Data register with 32 Registers (2^5). 5 Bit Bitfield to describe each register
- 5 Bit Opcode to describe each instruction

**Problems encountered:**
_Describe any blockers or bugs._

**Next steps:**
- [ ] Next task

---