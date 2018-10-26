#include "ASTNodes.h"

ASTNode::ASTNode(){
    nodeLabel = "";
    lineNum = 0;
    colNum = 0;
}

ASTNode::ASTNode(string label, int line, int col, list<ASTNode*> children) {
    nodeLabel = label;
    lineNum = line;
    colNum = col;
    childrenNodes = children;
}