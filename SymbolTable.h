//
// Created by Derek Stratton on 9/24/2018.
//

#ifndef BEST_C_COMPILER_SYMBOLTABLE_H
#define BEST_C_COMPILER_SYMBOLTABLE_H

#include <stack>
#include <map>
#include <utility>
#include <string>

using namespace std;

struct contents{

};

class SymbolTable {
  public:
    SymbolTable();
    void insert(const pair<string, contents> item);
    contents search(const string key);
    void writeToFile();
    void pushLevel();
    void popLevel();
  private:
    stack<map<string, contents>> table;
};

#endif //BEST_C_COMPILER_SYMBOLTABLE_H
