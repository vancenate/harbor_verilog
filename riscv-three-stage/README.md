# RISCV_Three_Stage
RISC-V 3 stage in-order pipeline in verilog

This is a simple RISC-V 3-stage pipeline processor buid using RV32I instruction set. Currently the core is not available for production purposes.
This Project has been done under the mentorship of Prof. Joycee Mekie @ IIT Gandhinagar and student mentor Jitesh Sah.  

## Features

1. Three-stage inorder pipeline processor
2. Complete Modular code and separate stages
3. RV32I instruction sets
3. Data forwarding enabled
4. Stalls
5. Catches exception

## Building Toolchains For Ubuntu

Install RV32I toolchains.

    # Ubuntu packages needed:
    sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
        gperf libtool patchutils bc zlib1g-dev git libexpat1-dev
    
    git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
    cd riscv-gnu-toolchain
    
    mkdir build; cd build
    ../configure --with-arch=rv32im --prefix=/opt/riscv32i
    make -j$(nproc)

## Building Toolchains For macOS

**Option 1 — xPack (recommended, no build from source)**

Uses the current RISC-V embedded GCC; binaries are named `riscv-none-elf-*` (the repo Makefile supports this).

1. Install Node.js and npm, then xpm:
   ```bash
   npm install --location=global xpm@latest
   ```
2. From this repo (or any folder where you want the toolchain on PATH):
   ```bash
   xpm init
   xpm install @xpack-dev-tools/riscv-none-elf-gcc@latest --verbose
   ```
3. Add the xPack bin folder to your PATH, e.g. for this repo:
   ```bash
   export PATH="$(pwd)/xpacks/.bin:$PATH"
   ```
   Or use the global xPacks bin path shown by `xpm install` (e.g. under `~/Library/xPacks/` or `$HOME/.local/share/xPacks/`).
4. Verify: `riscv-none-elf-gcc --version`

**Option 2 — Homebrew**

Pre-built RISC-V toolchain (multilib includes RV32I). Binaries are named `riscv64-unknown-elf-*`; override in the Makefile when building.

1. Tap and install:
   ```bash
   brew tap riscv-software-src/riscv
   brew install riscv-tools
   ```
2. When building in `mem_generator`, use the correct prefix:
   ```bash
   cd mem_generator
   make addition CROSS_COMPILE=riscv64-unknown-elf-
   ```
   Or set once: `export CROSS_COMPILE=riscv64-unknown-elf-` then run `make addition`, etc.

**Option 3 — Build from source on macOS**

If you prefer to build the GNU toolchain yourself (same as Ubuntu flow, different deps):

1. Install Xcode Command Line Tools: `xcode-select --install`
2. Install Homebrew build dependencies (macOS equivalents of the Ubuntu packages):
   ```bash
   brew install autoconf automake libtool curl gmp libmpc mpfr gawk bison flex texinfo gperf gnu-patchutils bc zlib git expat
   ```
3. Clone and build (use `sysctl -n hw.ncpu` instead of `nproc` for parallel jobs):
   ```bash
   git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain
   cd riscv-gnu-toolchain
   mkdir build && cd build
   ../configure --with-arch=rv32im --prefix=/opt/riscv32i
   make -j$(sysctl -n hw.ncpu)
   sudo make install
   ```
   Then add `/opt/riscv32i/bin` to your PATH. The resulting binaries are typically `riscv32-unknown-elf-*` or `riscv64-unknown-elf-*`; if they don’t match the Makefile default, use `CROSS_COMPILE=<prefix>` as in Option 2.

**Note:** The old toolchain name `riscv-none-embed-gcc` is deprecated; the current name is `riscv-none-elf-gcc`. This repo’s Makefile defaults to `riscv-none-elf-*` and supports overrides via `CROSS_COMPILE`.


## Building Toolchains For Windows
    We will install the xPack GNU RISC-V Embedded GCC binaries for windows using NPM and XPM. 
        # Windows packages needed:
        - Install npm from here https://www.npmjs.com/get-npm
        - npm i xpm
        - xpm install --global @xpack-dev-tools/riscv-none-embed-gcc@latest
            
    After installing the xPack GNU toolchain, add the tool chain to the path. 
    The tool chain can be found at the following path 
      C:\Users\ilg\AppData\Roaming\xPacks\GNU RISC-V Embedded GCC\8.2.1-3.1\bin
    
    
- You are good to go! Test the toolchain by cross-compiling any C code.
- Windows (xPack): run `riscv-none-elf-gcc` (or the older `riscv-none-embed-gcc` if using a legacy install).
- Linux / macOS (xPack): run `riscv-none-elf-gcc`.
- macOS / Linux (Homebrew or from-source): run `riscv64-unknown-elf-gcc` or `riscv32-unknown-elf-gcc` depending on your install. 

## Files list

| Folder         | Description                                       |
| -------------- | ------------------------------------------------- |
| mem_generator  | Contains imem and dmem hex files and C code files |
| modules        | Verilog modules for all three stages and pipeline |
| simulation     | Makefile and output files                         |

## Installing Icarus Verilog

    # Ubuntu package needed to run the RTL simulation
    sudo apt install iverilog

    # macOS (Homebrew)
    brew install icarus-verilog
    
    or
    # For Windows download and install iverilog from here 
    http://iverilog.icarus.com/
    
## To simulate the C code 
    cd simulation
    make <C code file name>

    Only running make without parameters will get help.

    make
    make addition         simulates the C code for addition
    make sort             simulates the C code for bubble sort
    make negative         simulates the C code for negative number addition
    make fibonacci        simulates the C code for fibonacci series
    make shifting         simulates the C code for shifting of number
    make xor              simulates the C code for xor
    make clean            clean

- **After this step, a pipeline.vcd file will be generated** 
- **To see the waveform of the simulation, run the following command:** 
        
    gtkwave pipeline.vcd

- **To generate the hex file for IMEM and DMEM without simulating run:**

    cd mem_generator
    make <C code file name>

- **The python script included in the imem_dmem folder converts the binary generated by the compiler to hex format**

| Files Generated       | Description                                       |
| --------------------- | ------------------------------------------------- |
| code.elf              | Elf file for the simulated C code                 |
| code.dis              | Disassembly file for the simulated C code         |
| imem.bin              | Binary for the instrcution memory                 |
| imem.hex              | Hex file for instruction memory                   |
| dmem.bin              | Binary for the data memory                        |
| dmem.hex              | Hex file for data memory                          |

## Screnshots

![alt text](https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/pipeline_overview.png)
![alt text](https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/stages_function.png)

**Register Forwarding**

When the data value of a register is calculated in a previous instruction and the updated value is used for the next instruction, the problem of data hazard occurs. To overcome this the updated register value is directly transfered from the writeback stage to execute stage.

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/data_forwarding.png" alt="Register Forwarding"> 


**Branch Penalty**

When the branch is taken during the execute stage, it needs to stall the instructions that have been fetched into the pipeline, which causes a delay/stall of two instructions, so the extra cost of the branch is two.

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/branch.png" alt="Branch Penalty">

## C codes used for testing the pipeline

**Fibonacci Sequence**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/fibonacci_test.png" alt="Fibonacci Sequence">

**Sorting an array**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/sorting_test.png" alt="Sorting" >

**Addition of two numbers**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/addition_test.png" alt="Addition">


**Shifting**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/shifting_test.png" alt="Shifting">

**Negative integers**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/negative_test.png" alt="Shifting" >


**Waveform for all the wires**

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/screenshots/wave.png" alt="wave" >

## 

###

## Supported Instruction Set Architecture

<img src="https://github.com/adityatripathiiit/RISCV_Three_Stage/blob/master/design docs/supported_instruction_set.jpg" alt="ISA" >



## Memory Interface

There is a single memory module for both instruction and data memory. Instruction memory is read only while data memory is both read and write.

## Known issues

* An ideal memory has been assumed for this project, i.e. the instruction and data memory are always read/write valid.
* Branch instructions have two stalls which can be reduced to one, to optimise the functioning.
* No overflow handling in ALU operations
