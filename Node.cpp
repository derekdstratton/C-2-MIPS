#include "Node.h"

/**
 * Constructor for a Node. Constructs with the line number and specifiers
 *
 * @param lineNum The line number of the symbol being inserted
 * @param specifiers An array of strings corresponding to the type specifier, type
 * qualifier, storage class specifier, and if it is signed or unsigned
 */
Node::Node(int lineNum, string * specifiers) {
    lineNumber = lineNum;
    type_specifier = specifiers[0];
    type_qualifier = specifiers[1];
    storage_class_specifier = specifiers[2];
    signed_or_unsigned = specifiers[3];
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