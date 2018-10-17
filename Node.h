#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
using namespace std;

class Node {
  public:
    Node(int var, string type_specifier_input, string type_qualifier_input,
         string storage_class_specifier_input, string signed_or_unsigned_input);
    int i;
    bool isFunction; //true if function, also the name should include () to prevent matching variables
    string type_specifier;
    string type_qualifier;
    string storage_class_specifier;
    string signed_or_unsigned;
    int lineNum;
    //todo struct or union or enums
    friend ostream& operator<<(ostream& os, const Node& node);
};


#endif //PROJECT_NODE_H
