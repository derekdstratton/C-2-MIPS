cmake_minimum_required(VERSION 3.8)
project(Project)

set(CMAKE_CXX_STANDARD 11)

set(SYMBOL_TABLE driver.cpp Node.cpp Node.h SymbolTable.cpp SymbolTable.h )
add_executable(symbol ${SYMBOL_TABLE})

add_executable(scanner lex.yy.cc)

#boost.test for showing requirements in a clean/easy to test in C Lion Way?

# https://cmake.org/cmake/help/v3.0/module/FindFLEX.html