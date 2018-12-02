#include "SymbolTableNode.h"

ostream& operator<<(ostream& os, const SymbolTableNode2& node) {
    os << "Identifier: " << node.identifier;
    os << ", Types: ";
    for (int item : node.types) {
        os << item << "_";
    }
    if (node.sizeList.size() > 0) {
        os << ", Array dimensions: " << node.sizeList.size();
        os << ", Size per dim: ";
        for (auto i : node.sizeList) {
            os << i << " ";
        }
    }
    if (node.isFunction) {
        os << ", Function w/ Params: ";
        for (auto t : node.paramTypes) {
            for (auto q : t) {
                os << q << "_";
            }
        }
    }


    return os;
}

SymbolTableNode2::SymbolTableNode2() {
    set<int> fail;
    types = fail;
    identifier = "";
}

SymbolTableNode2::SymbolTableNode2(string name, set<int> typeArr, list<int> size_decl_list, bool isFunc,
                                   list<set<int>> params, bool Defined) {
    types = typeArr;
    identifier = name;
    sizeList = size_decl_list;
    isFunction = isFunc;
    paramTypes = params;
    defined = Defined;
}

SymbolTableNode2::SymbolTableNode2(SymbolTableNode2 const &other) {
    types = other.types;
    identifier = other.identifier;
    sizeList = other.sizeList;
    isFunction = other.isFunction;
    paramTypes = other.paramTypes;
    defined = other.defined;
}
