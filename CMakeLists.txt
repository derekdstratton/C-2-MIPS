cmake_minimum_required(VERSION 3.10)
project(Project)

set(CMAKE_C_STANDARD 11)

add_executable(Driver driver.cpp SymbolTable.cpp)