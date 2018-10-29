#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
#include <map>
#include <string>

using namespace std;

enum type_specifiers {Int, Char, Short, Long, Float, Double, Struct, Union, Enum, TypedefName, Void, NoTS};
enum signed_or_unsigneds {Signed, Unsigned, NoSU};
enum storage_class_specifiers {Auto, Register, Static, Extern, Typedef, NoSCS};
enum type_qualifiers {Const, Volatile, NoTQ};

class SymbolTableNode {
  public:
    SymbolTableNode();
    int getLineNumber();
    int getColumnNumber();
    type_specifiers getTypeSpecifier();
    type_qualifiers getTypeQualifier();
    storage_class_specifiers getStorageClassSpecifier();
    signed_or_unsigneds getSignedOrUnsigned();
    map<string, SymbolTableNode> getStructOrUnionSymbols();
    string getName();
    void setLineNumber(int lineNum);
    void setColumnNumber(int colNum);
    void setTypeSpecifier(type_specifiers ts);
    void setTypeQualifier(type_qualifiers tq);
    void setStorageClassSpecifier(storage_class_specifiers scs);
    void setSignedOrUnsigned(signed_or_unsigneds sou);
    void setStructOrUnionSymbols(map<string, SymbolTableNode> sou);
    void setName(string new_name);
  private:
    string name;
    int lineNumber;
    int columnNumber;
    type_specifiers type_specifier;
    type_qualifiers type_qualifier;
    storage_class_specifiers storage_class_specifier;
    signed_or_unsigneds signed_or_unsigned;
    map<string, SymbolTableNode> struct_or_union_symbols;
    friend ostream& operator<<(ostream& os, const SymbolTableNode& node);
};


#endif //PROJECT_NODE_H
