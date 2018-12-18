#ifndef BEST_C_COMPILER_SYMBOLTABLE_H
#define BEST_C_COMPILER_SYMBOLTABLE_H

#include <list>
#include <map>
#include <utility>
#include <string>
#include "SymbolTableNode.h"

using namespace std;

class SymbolTable {
  public:
    SymbolTable();
    void swapLevels(){
        auto a = table.front();
        table.pop_front();
        auto b = table.front();
        table.pop_front();
        table.push_front(a);
        table.push_front(b);
    }
    tuple<bool, bool> insert(const pair<string, SymbolTableNode2>& item);
    tuple<SymbolTableNode2*, string> search(const string& key, bool topLevelOnly=false);
    void pushLevel();
    bool popLevel();
    bool getMode() const;
    void setMode(const bool& newMode);
    friend ostream& operator<<(ostream& os, const SymbolTable& symbolTable);
  private:
    list<map<string, SymbolTableNode2>> table;
    //the actual symbol table
    //the top of the stack is given by table.front()
    bool insertMode; //if true, in insert mode. if false, in lookup mode.
};

#endif //BEST_C_COMPILER_SYMBOLTABLE_H
