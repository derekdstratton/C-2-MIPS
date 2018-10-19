# C 2 MIPS

For CS 460, Compiler Construction, Fall 2018

### Description:

This project is a C Compiler that translates ANSI C code into 
MIPS Assembly code. The Compiler currently consists of a Symbol
Table, Scanner, and Parser. The Symbol Table works with the Scanner
and Parser to keep track of identifiers read from an input character 
stream. The Scanner returns tokens from an input character stream. The
Parser uses the tokens from the Scanner to generate productions based
on the C Grammar. The compiler is written in C++ and uses Flex and Bison
to scan and parse the input C code. More detailed project information can
be found in the [wiki](https://derekdstratton.github.io/Best-C-Compiler/).

### Team: Scan

- Derek Stratton
- Chris Koh

### Installation: 

```
git clone https://github.com/derekdstratton/C-2-MIPS
cmake Best-C-Compiler
make
```

### Usage:

- To run the Scanner/Parser, type `./ScannerParser [options] file_path`
- To run the Symbol Table driver, type `./SymbolTableDriver`
- To run the Symbol Table Test driver, type `./SymbolTableTest`

### Wiki:

https://derekdstratton.github.io/C-2-MIPS
