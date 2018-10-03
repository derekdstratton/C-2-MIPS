cmake_minimum_required(VERSION 3.8)
project(Project)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES driver.cpp Node.cpp Node.h SymbolTable.cpp SymbolTable.h )
add_executable(project ${SOURCE_FILES})