#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
#include <map>
#include <string>
#include <set>
#include <list>
#include <iostream>

using namespace std;

class SymbolTableNode2 {
public:
    SymbolTableNode2();
    SymbolTableNode2(string name, set<int> typeArr, list<int> size_decl_list, bool isFunc, list<set<int>> params, bool Defined);
    SymbolTableNode2(SymbolTableNode2 const & other);
    //this operator= is VERY important. you WILL explode if you disregard it
    SymbolTableNode2& operator=(SymbolTableNode2 const & other) = default;
    friend ostream& operator<<(ostream& os, const SymbolTableNode2& node);

    set<int> types;
    string identifier;
    list<int> sizeList; //list of sizes for each dimension
    bool isFunction;
    list<set<int>> paramTypes;
    bool defined;
    //this is really bad style- these 2 vars only used in 3ac
    int offset;
    string tempreg;
};


#endif //PROJECT_NODE_H
