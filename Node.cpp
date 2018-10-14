/**
 *
 */
#include "Node.h"

Node::Node(int var) {
    i = var;
}

ostream& operator<<(ostream& os, const Node& node) {
    os << node.i;
    return os;
}