cmake_minimum_required(VERSION 3.7)
project(Project)

set(CMAKE_CXX_STANDARD 11)

# Symbol Table

set(SYMBOL_TABLE SymbolTableDriver.cpp Node.cpp Node.h SymbolTable.cpp SymbolTable.h )
add_executable(SymbolTable ${SYMBOL_TABLE})

# Scanner/Parser

find_package(BISON)
find_package(FLEX)
BISON_TARGET(MyParser parse.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(MyScanner scanner.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})

# copy over the test files
file(GLOB TEST_CASES
        "tests/*.c"
        )
file(COPY ${TEST_CASES} DESTINATION ${PROJECT_BINARY_DIR}/tests)

add_executable(ScannerParser SymbolTable.cpp SymbolTable.h Node.cpp Node.h
${BISON_MyParser_OUTPUTS}
${FLEX_MyScanner_OUTPUTS}
)