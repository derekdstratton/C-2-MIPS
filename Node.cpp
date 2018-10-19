/**
 *
 */
#include "Node.h"

Node::Node(int var, string type_specifier_input, string type_qualifier_input,
        string storage_class_specifier_input, string signed_or_unsigned_input) {
    i = var;
    type_specifier = type_specifier_input;
    type_qualifier = type_qualifier_input;
    storage_class_specifier = storage_class_specifier_input;
    signed_or_unsigned = signed_or_unsigned_input;
}

ostream& operator<<(ostream& os, const Node& node) {
    //os << node.i;
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