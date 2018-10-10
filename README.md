# Best-C-Compiler
Ever.

flex scanner.l
bison parse.y -d
bison parse.y
g++ -std=c++11 parse.tab.c lex.yy.c SymbolTable.cpp Node.cpp

https://github.com/derekdstratton/Best-C-Compiler/wiki

todo add docs for running with cmake

git clone *name*
cmake *Best-C-Compiler*
make
./ScannerParser