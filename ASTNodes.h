#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include <string>
#include <iostream>

using namespace std;

class ASTNode {
public:
    ASTNode() {
        nodeLabel = "NA";
        //cout << "default";
    }
    ASTNode(string label, int line, int col, list<ASTNode*> children) {
        nodeLabel = label;
        lineNum = line;
        colNum = col;
        childrenNodes = children;
    }
    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node) {
        node.printNode(os);
        return os;
    }
protected:
    string nodeLabel;
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel;
    }
};

class TypeValueNode : public ASTNode {
public:
    TypeValueNode(string label, int line, int col, list<ASTNode*> children, int val, string type) {
        nodeLabel = label;
        lineNum = line;
        colNum = col;
        childrenNodes = children;
        nodeVal = val;
        //todo deal with type using enum
    };
private:
    int nodeVal;
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel << ": " << nodeVal;
    }
};

#endif //PROJECT_ASTNODES_H
