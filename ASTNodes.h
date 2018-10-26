#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

class ASTNode {
public:
    ASTNode(string label, int line, int col, list<Node*> children);
    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node) {
        node.printNode(os);
        return os;
    }
private:
    string nodeLabel;
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel;
    }
};

#endif //PROJECT_ASTNODES_H
