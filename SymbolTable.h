//
// Created by Derek Stratton on 9/24/2018.
//

#ifndef BEST_C_COMPILER_SYMBOLTABLE_H
#define BEST_C_COMPILER_SYMBOLTABLE_H

#include <list>
#include <map>
#include <utility>
#include <string>

using namespace std;

class SymbolTable {
  public:
    SymbolTable();
    void insert(const pair<string, int> item);
    int search(const string key);
    void writeToFile();
    void pushLevel();
    void popLevel();
    void printTable();
  private:
    //the actual symbol table
    list<map<string, int>> table;
    //the top of the stack is given by table.back()
};

#endif //BEST_C_COMPILER_SYMBOLTABLE_H
