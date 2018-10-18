/**
 *
 */
#include "Node.h"

Node::Node(int lineNum, string * specifiers) {
    lineNumber = lineNum;
    type_specifier = specifiers[0];
    type_qualifier = specifiers[1];
    storage_class_specifier = specifiers[2];
    signed_or_unsigned = specifiers[3];
}

ostream& operator<<(ostream& os, const Node& node) {
    os << "Line Number: " << node.lineNumber << ", ";
    os << "Declaration Specifiers: ";
    if (node.type_specifier != "none") {
        os << node.type_specifier << " ";
    }
    if (node.type_qualifier != "none") {
        os << node.type_qualifier << " ";
    }
    if (node.storage_class_specifier != "none") {
        os << node.storage_class_specifier << " ";
    }
    if (node.signed_or_unsigned != "none") {
        os << node.signed_or_unsigned << " ";
    }
    return os;
}