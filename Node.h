#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
#include <map>
#include <string>

using namespace std;

class Node {
  public:
    Node(int lineNum, string * specifiers);
  private:
    int lineNumber;
    bool isFunction; //true if function, also the name should include () to prevent matching variables
    string type_specifier;
    string type_qualifier;
    string storage_class_specifier;
    string signed_or_unsigned;
    map<string, Node> struct_or_union_symbols;
    //todo single level SymbolTable for structs/unions, or a map
    int lineNum;
    //todo enums
    friend ostream& operator<<(ostream& os, const Node& node);
};


#endif //PROJECT_NODE_H
