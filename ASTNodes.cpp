#include "ASTNodes.h"

ASTNode::ASTNode(string label, int line, int col, list<Node*> children) {
    nodeLabel = label;
    lineNum = line;
    colNum = col;
    childrenNodes = children;
}