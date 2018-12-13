#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
#include <map>
#include <string>
#include <set>
#include <list>
#include <iostream>

#include "yytokentype.h"

using namespace std;

class SymbolTableNode2 {
public:
    SymbolTableNode2();
    SymbolTableNode2(string name, set<int> typeArr, list<int> size_decl_list, bool isFunc, list<set<int>> params, bool Defined);
    SymbolTableNode2(SymbolTableNode2 const & other);
    SymbolTableNode2& operator=(SymbolTableNode2 const & other) = default;
    friend ostream& operator<<(ostream& os, const SymbolTableNode2& node);

    set<int> types;
    string identifier;
    list<int> sizeList; //list of sizes for each dimension
    bool isFunction;
    list<set<int>> paramTypes;
    bool defined;
};


#endif //PROJECT_NODE_H
