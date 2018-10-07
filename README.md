# Best-C-Compiler
Ever.

flex scanner.l
bison parse.y -d
bison parse.y
g++ -std=c++11 parse.tab.c lex.yy.c SymbolTable.cpp Node.cpp
