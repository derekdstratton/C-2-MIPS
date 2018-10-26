cmake_minimum_required(VERSION 3.7)
project(Project)

set(CMAKE_CXX_STANDARD 11)

# Symbol Table Driver

set(SYMBOL_TABLE_DRIVER SymbolTableDriver.cpp SymbolTableNode.cpp SymbolTableNode.h SymbolTable.cpp SymbolTable.h )
add_executable(SymbolTableDriver.cpp ${SYMBOL_TABLE_DRIVER})

# Symbol Table Test

set(SYMBOL_TABLE_TEST SymbolTableTest.cpp SymbolTableNode.cpp SymbolTableNode.h SymbolTable.cpp SymbolTable.h )
add_executable(SymbolTableTest ${SYMBOL_TABLE_TEST})

# Scanner/Parser

find_package(BISON)
find_package(FLEX)
BISON_TARGET(MyParser parse.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(MyScanner scanner.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})

# AST

add_executable(Tree tree.cpp)

add_executable(Tree2 tree2.cpp)

# https://dreampuf.github.io/GraphvizOnline/

# copy over the test files
file(GLOB TEST_CASES
        "tests/*.c"
        )
file(COPY ${TEST_CASES} DESTINATION ${PROJECT_BINARY_DIR}/tests)

add_executable(ScannerParser SymbolTable.cpp SymbolTable.h SymbolTableNode.cpp SymbolTableNode.h
${BISON_MyParser_OUTPUTS}
${FLEX_MyScanner_OUTPUTS}
)