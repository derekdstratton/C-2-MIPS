#include "SymbolTableNode.h"

/**
 * Default Constructor for a Node. Sets default values. Other values must be manually set.
 *
 */
SymbolTableNode::SymbolTableNode() : lineNumber(-1), columnNumber(-1), type_specifier(Int), type_qualifier(NoTQ),
    storage_class_specifier(NoSCS), signed_or_unsigned(NoSU){
}

/**
 * The operator << overload for Node so it can be output to files or stdout
 *
 * @param os The output stream being put to.
 * @param node The node being output.
 * @return A reference to the ostream to allow for chaining.
 */
ostream& operator<<(ostream& os, const SymbolTableNode& node) {
    os << "Identifier: " << node.name << ", ";
    os << "Line Number: " << node.lineNumber << ", ";
    os << "Column Number: " << node.columnNumber << ", ";
    os << "Declaration Specifiers: ";
    if (node.type_specifier != NoTS) {
        string s;
        switch (node.type_specifier) {
            case Int:
                s = "int";
                break;
            case Char:
                s = "char";
                break;
            case Short:
                s = "short";
                break;
            case Long:
                s = "long";
                break;
            case Float:
                s = "float";
                break;
            case Double:
                s = "double";
                break;
            case Struct:
                s = "struct";
                break;
            case Union:
                s = "union";
                break;
            case TypedefName:
                s = "not implemented";
                break;
            case Void:
                s = "void";
                break;
            default:
                break;
        }
        os << s << " ";
    }
    if (node.type_qualifier != NoTQ) {
        string s;
        switch(node.type_qualifier) {
            case Const:
                s = "const";
                break;
            case Volatile:
                s = "volatile";
                break;
            default:
                break;
        }
        os << s << " ";
    }
    if (node.storage_class_specifier != NoSCS) {
        //{Auto, Register, Static, Extern, Typedef, NoSCS};
        string s;
        switch (node.storage_class_specifier) {
            case Auto:
                s = "auto";
                break;
            case Register:
                s = "register";
                break;
            case Static:
                s = "static";
                break;
            case Extern:
                s = "extern";
                break;
            case Typedef:
                s = "typedef";
                break;
            default:
                break;
        }
        os << s<< " ";
    }
    if (node.signed_or_unsigned != NoSU) {
        string s;
        switch(node.signed_or_unsigned) {
            case Signed:
                s = "signed";
                break;
            case Unsigned:
                s = "unsigned";
                break;
            default:
                break;
        }
        os << s<< " ";
    }
    return os;
}

int SymbolTableNode::getLineNumber() {
    return lineNumber;
}

int SymbolTableNode::getColumnNumber() {
    return columnNumber;
}

type_specifiers SymbolTableNode::getTypeSpecifier() {
    return type_specifier;
}

type_qualifiers SymbolTableNode::getTypeQualifier() {
    return type_qualifier;
}

storage_class_specifiers SymbolTableNode::getStorageClassSpecifier() {
    return storage_class_specifier;
}

signed_or_unsigneds SymbolTableNode::getSignedOrUnsigned() {
    return signed_or_unsigned;
}

map<string, SymbolTableNode> SymbolTableNode::getStructOrUnionSymbols() {
    return struct_or_union_symbols;
}

void SymbolTableNode::setLineNumber(int lineNum) {
    lineNumber = lineNum;
}

void SymbolTableNode::setColumnNumber(int colNum) {
    columnNumber = colNum;
}

void SymbolTableNode::setTypeSpecifier(type_specifiers ts) {
    type_specifier = ts;
}

void SymbolTableNode::setTypeQualifier(type_qualifiers tq) {
    type_qualifier = tq;
}

void SymbolTableNode::setStorageClassSpecifier(storage_class_specifiers scs) {
    storage_class_specifier = scs;
}

void SymbolTableNode::setSignedOrUnsigned(signed_or_unsigneds sou) {
    signed_or_unsigned = sou;
}

void SymbolTableNode::setStructOrUnionSymbols(map<string, SymbolTableNode> sou) {
    struct_or_union_symbols = sou;
}

string SymbolTableNode::getName() {
    return name;
}

void SymbolTableNode::setName(string new_name) {
    name = new_name;
}

ostream& operator<<(ostream& os, const SymbolTableNode2& node) {
    os << "Identifier: " << node.identifier;
    os << ", Types: " << "needs implemented in <<";
    os << ", Array dimensions: " << node.sizeList.size();
    os << ", Size per dim: ";
    for (auto i : node.sizeList) {
        os << i << " ";
    }

    return os;
}