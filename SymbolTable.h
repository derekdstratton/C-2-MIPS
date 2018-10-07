//
// Created by Derek Stratton on 9/24/2018.
//

#ifndef BEST_C_COMPILER_SYMBOLTABLE_H
#define BEST_C_COMPILER_SYMBOLTABLE_H

#include <list>
#include <map>
#include <utility>
#include <string>
#include "Node.h"

using namespace std;

class SymbolTable {
  public:
    SymbolTable();
    bool insert(const pair<string, Node>& item);
    tuple<map<string, Node>::iterator, string> search(const string& key, bool topLevelOnly=false);
    void pushLevel();
    void popLevel();
    friend ostream& operator<<(ostream& os, const SymbolTable& symbolTable);
  private:
    list<map<string, Node>> table;
    //the actual symbol table
    //the top of the stack is given by table.front()
};

#endif //BEST_C_COMPILER_SYMBOLTABLE_H
