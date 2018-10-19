#include "Node.h"

/**
 * Default Constructor for a Node. Sets default values. Other values must be manually set.
 *
 */
Node::Node() : lineNumber(-1), columnNumber(-1), type_specifier(NoTS), type_qualifier(NoTQ),
    storage_class_specifier(NoSCS), signed_or_unsigned(NoSU){
}

/**
 * The operator << overload for Node so it can be output to files or stdout
 *
 * @param os The output stream being put to.
 * @param node The node being output.
 * @return A reference to the ostream to allow for chaining.
 */
ostream& operator<<(ostream& os, const Node& node) {
    os << "Line Number: " << node.lineNumber << ", ";
    os << "Column Number: " << node.columnNumber << ", ";
    os << "Declaration Specifiers: ";
    if (node.type_specifier != NoTS) { //todo make these not suck
        os << node.type_specifier << " ";
    }
    if (node.type_qualifier != NoTQ) {
        os << node.type_qualifier << " ";
    }
    if (node.storage_class_specifier != NoSCS) {
        os << node.storage_class_specifier << " ";
    }
    if (node.signed_or_unsigned != NoSU) {
        os << node.signed_or_unsigned << " ";
    }
    return os;
}

int Node::getLineNumber() {
    return lineNumber;
}

int Node::getColumnNumber() {
    return columnNumber;
}

type_specifiers Node::getTypeSpecifier() {
    return type_specifier;
}

type_qualifiers Node::getTypeQualifier() {
    return type_qualifier;
}

storage_class_specifiers Node::getStorageClassSpecifier() {
    return storage_class_specifier;
}

signed_or_unsigneds Node::getSignedOrUnsigned() {
    return signed_or_unsigned;
}

map<string, Node> Node::getStructOrUnionSymbols() {
    return struct_or_union_symbols;
}

void Node::setLineNumber(int lineNum) {
    lineNumber = lineNum;
}

void Node::setColumnNumber(int colNum) {
    columnNumber = colNum;
}

void Node::setTypeSpecifier(type_specifiers ts) {
    type_specifier = ts;
}

void Node::setTypeQualifier(type_qualifiers tq) {
    type_qualifier = tq;
}

void Node::setStorageClassSpecifier(storage_class_specifiers scs) {
    storage_class_specifier = scs;
}

void Node::setSignedOrUnsigned(signed_or_unsigneds sou) {
    signed_or_unsigned = sou;
}

void Node::setStructOrUnionSymbols(map<string, Node> sou) {
    struct_or_union_symbols = sou;
}
