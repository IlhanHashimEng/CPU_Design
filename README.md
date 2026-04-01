# Custom CPU from Scratch

> Designing a Custom CPU from Scratch to learn more about CPU and hardware

---

## Overview

- **Architecture:** 16-bit, custom RISC-style
- **Target:** Simulation (Verilog / testbench)
- **Tools:** Verilog HDL 

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

### Entry 001 — 03-03-2026 — Creating Arithmetic and Logical Unit
**What I worked on:**
_Created the ALU unit and describing the registers of the CPU._

**Decisions made:**
- 16 Bit Data register with 32 Registers (2^5). 5 Bit Bitfield to describe each register
- 5 Bit Opcode to describe each instruction

**Problems encountered:**
- No idea how to do the ALU

**Next steps:**
- Creating condition flags

---

### Entry 002 — 26-03-2026 — Creating Flags (OVERFLOW FLAG) 
**What I worked on:**
_Identified and understand the logic behind flags_

**Decisions made:**
- Understand the logic behind Carry, Zero, Overflow and Sign flag


**Addition**
<table style="width:100%; border-collapse:collapse; font-family:monospace;">
  <thead>
    <tr style="background-color:#2d2d2d; color:#ffffff;">
      <th style="border:1px solid #555; padding:10px; text-align:center;">IP1</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">IP2</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">RES</th>
      <th style="border:1px solid #555; padding:10px; text-align:left;">Example</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">OV</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 + 1 = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">1 + 2 = -1</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">1</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 - 1 = 2</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 + 1 = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 + 3 = 2</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">-5 + 1 = -4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 + (-4) = -5</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">1</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 + 1 = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
  </tbody>
</table>

- For addition, the OV flag is 1 only on two cases. Hence the logic equation should be
```
OV = (~IP1[MSB] & ~IP2[MSB] & RES[MSB]) | (IP1[MSB] & IP2[MSB] & ~RES[MSB])
```

**Subtraction**

<table style="width:100%; border-collapse:collapse; font-family:monospace;">
  <thead>
    <tr style="background-color:#2d2d2d; color:#ffffff;">
      <th style="border:1px solid #555; padding:10px; text-align:center;">IP1</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">IP2</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">RES</th>
      <th style="border:1px solid #555; padding:10px; text-align:left;">Example</th>
      <th style="border:1px solid #555; padding:10px; text-align:center;">OV</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 - 2 = 1</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">4 - 5 = -1</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">3 - (-1) = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">1 - (-5) = -1</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">1</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 - 3 = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">1</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 + -3 = -4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#1e1e1e; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">&gt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 - (-2) = 1</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
    <tr style="background-color:#252526; color:#d4d4d4;">
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px; text-align:center; color:#f48771;">&lt;0</td>
      <td style="border:1px solid #555; padding:10px;">-1 - (-1) = 4</td>
      <td style="border:1px solid #555; padding:10px; text-align:center;">0</td>
    </tr>
  </tbody>
</table>

- For Subtraction, the OV flag is 1 in only two cases. Hence the equation is

```
OV = ( ~IP1[MSB] & IP2[MSB] & RES[MSB] ) | ( IP1[MSB] & ~IP2[MSB] & ~RES[MSB])
```

**Problems encountered:**
- None

**Next steps:**
- TBD

## Entry 003 — 30-03-2026 — Creating Flags (Zero, Sign, Carry FLAG) 
**What I worked on:**
_Identified and understand the logic behind flags_

**Decisions made:**
- Understand the logic behind Carry, Zero, and Sign flag

### Carry Flag

```
Carry Flag -> MSB of the result of addition.

result[4:0](5 bit) = src1[3:0](4 bit) + src[3:0](4 bit)

carry = result[MSB]
```
### Sign Flag

```
reg [3:0] result  = 1 0 0 0 -> -ve
                  = 0 1 1 1 -> +ve

Sign Flag = result[3]
```
### Zero Flag

- Zero Flag -> Determines if the result is a zero. We OR the result, if any bits are 1, the last output will be 1. Then the NOT will change it to a 0. Hence, the Zero Flag will be 0.
```
reg [3:0] result  = 0 0 0 0 -> Set    ( Zero Flag = 1 )
                  = 0 0 0 1 -> Reset  ( Zero Flag = 0 )

Zero Flag = ~(result[3] | result [2] | result[1] | result[0])
          = ~(| result)
```
## Entry 004 — 01-04-2026 — RTL Implementation of Flags (Zero, Sign, Carry FLAG) 
**What I worked on:**
_Implement the flags in Verilog HDL_

**Decisions made:**
- Created a different always block to handle the flag process


---