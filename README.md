# Enhanced Processor with Floating-Point Unit

A custom 9-bit processor implemented in SystemVerilog, extended with a Floating-Point Unit (FPU) supporting integer and floating-point arithmetic instructions. Designed and tested on FPGA as part of the Digital Design Laboratory course at HCMUT.

---

## Architecture Overview

The system consists of three main blocks connected through a 9-bit shared bus:

- **Processor Core** — contains 8 general-purpose registers (R0–R7), an integer ALU (AddSub), an instruction register (IR), a program counter (PC), and a Control FSM that sequences all operations.
- **Floating-Point Unit (FPU)** — operates on a custom 9-bit floating-point format: 1 sign bit, 4 exponent bits (bias = 7), 4 fraction bits. Supports floating-point addition via the `addf` instruction.
- **Memory & I/O** — RAM 128×9 stores the program (loaded from `.mif` file). An output register drives 9 LEDs. Address decoding: `A[8:7] = 00` selects RAM, `A[8:7] = 01` selects the LED register.

### Top-Level I/O (DE-series FPGA board)

| Signal | Direction | Description |
|--------|-----------|-------------|
| `CLOCK_50` | Input | 50 MHz system clock |
| `SW[9]` | Input | Run control (synchronized) |
| `KEY[0]` | Input | Active-low reset |
| `LEDR[8:0]` | Output | Result displayed on LEDs |
| `LEDR[9]` | Output | Done flag |

---

## Instruction Set

| Opcode | Instruction | Operation |
|--------|-------------|-----------|
| `000` | `mv Rx, Ry` | `Rx ← Ry` |
| `001` | `mvi Rx, #D` | `Rx ← D` (immediate) |
| `010` | `add Rx, Ry` | `Rx ← Rx + Ry` (integer) |
| `011` | `sub Rx, Ry` | `Rx ← Rx - Ry` (integer) |
| `100` | `ld Rx, [Ry]` | `Rx ← mem[Ry]` |
| `101` | `st Rx, [Ry]` | `mem[Ry] ← Rx` |
| `110` | `mvnz Rx, Ry` | `if G ≠ 0: Rx ← Ry` |
| `111` | `addf Rx, Ry` | `Rx ← Rx + Ry` (floating-point) |

The `addf` instruction activates the FPU block by asserting `AFin`, `GFin`, and `AddSubF` control signals over multiple clock cycles. The bus selection signal `Gout` is 2-bit: `10` selects integer ALU output, `01` selects FPU output.

---

## File Structure

```
enhanced-processor-fpu/
├── enhanced_processor.sv       # Processor core: datapath + Control FSM
├── fpu9.sv                     # 9-bit Floating-Point Unit (addf support)
├── addsub9bit.sv               # 9-bit integer adder/subtractor
├── proc_wrapper_toplevel.sv    # Top-level: connects CPU, RAM, LED register
├── ram128x9.sv                 # 128×9-bit instruction/data memory
├── reg9.sv                     # 9-bit register (used for LED output register)
├── register9bit.sv             # 9-bit general-purpose register
├── pc_reg.sv                   # Program counter register
├── mux8to1_9bit.sv             # 8-to-1 multiplexer for bus selection
├── lab6.mif                    # Memory initialization file (test program)
└── README.md
```

---

## How to Run

1. Open **Intel Quartus Prime** and create a new project.
2. Add all `.sv` files to the project. Set `proc_wrapper_toplevel` as the top-level entity.
3. Assign pins according to your FPGA board (DE1-SoC or equivalent).
4. Load `lab6.mif` as the memory initialization file for `ram128x9`.
5. Compile the project and download the bitstream to the FPGA.
6. Press `KEY[0]` to reset, then toggle `SW[9]` to Run.
7. Observe results on `LEDR[8:0]`; `LEDR[9]` goes high when the program completes.

To simulate before downloading, open **ModelSim** and run RTL simulation with a testbench that drives `clk`, `Resetn`, and `Run`.

---

## Tools

- **Intel Quartus Prime** — synthesis and FPGA programming
- **ModelSim** — RTL simulation and waveform verification
- **Language** — SystemVerilog
