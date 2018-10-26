#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>

class ASTNode {
public:
    ASTNode(string label, int line, int col, list<Node*> children) {
        nodeLabel = label;
        lineNum = line;
        colNum = col;
        childrenNodes = children;
    }
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

class IntNode : ASTNode {
public:
    IntNode(string label, int line, int col, list<Node*> children, int val) {
        ASTNode(string label, int line, int col, list<Node*> children);
        nodeVal = val;
    };
private:
    int nodeVal;
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel << ": " nodeVal;
    }
};

class CharNode : ASTNode {
public:
    CharNode(string label, int line, int col, list<Node*> children, char val) {
        ASTNode(string label, int line, int col, list<Node*> children);
        nodeVal = val;
    };
private:
    char nodeVal;
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel << ": " nodeVal;
    }
};

class FloatNode : ASTNode {
public:
    FloatNode(string label, int line, int col, list<Node*> children, float val) {
        ASTNode(string label, int line, int col, list<Node*> children);
        nodeVal = val;
    };
private:
    float nodeVal;
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel << ": " nodeVal;
    }
};

class StringNode : ASTNode {
public:
    StringNode(string label, int line, int col, list<Node*> children, char * val) {
        ASTNode(string label, int line, int col, list<Node*> children);
        nodeVal = val; //todo be careful about this line with char *. Account for in lex file
        //we'll need a deep copy, not a shallow, which requires memory
    };
private:
    char * nodeVal;
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel << ": " nodeVal;
    }
};

#endif //PROJECT_ASTNODES_H
