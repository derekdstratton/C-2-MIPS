#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include <string>
#include <iostream>

using namespace std;
#include "include/tree.hh"

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

    list<ASTNode*> getChildren() {
        return childrenNodes;
    }

    /** Copies the ASTNode into a tree.hh tree
     *
     * @param root
     * @param ast A tree.hh to be copied into
     */
    static void copyTree(ASTNode*& root, tree<ASTNode*> & ast) {
        //Make sure the ast is clear
        ast.clear();
        //first insert the top
        auto firstNode = ast.insert(ast.begin(), root);
        //now add the children
        copyTreeHelper(root, ast, firstNode);

    }

    //todo make a virtual function that returns the type of node being looked at


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

    /**
     *
     * @param src_node
     * @param ast
     * @param iRoot
     */
    static void copyTreeHelper(ASTNode*& src_node, tree<ASTNode*> & ast, typename tree<ASTNode*>::iterator iRoot) {
        //Node has children, insert them
        if (src_node->getChildren().size() != 0) {
            for (auto &child : src_node->getChildren()) {
                cout << *child;
                auto newRoot = ast.append_child(iRoot, child);
                copyTreeHelper(child, ast, newRoot);
            }
        }
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
    void printNode(std::ostream& os) const {
        os << nodeLabel;
    }
};

/**
 * Reprsented 3 address code:
 * ASSIGN op1 op2 op3, op3 := op1
 *
 * 2 Children in the node
 * Child 1 is the lvalue, op3
 * Child 2 is the rvalue, op1
 * (op2 is blank)
 */
class AssignNode : public ASTNode {
public:
    AssignNode(list<ASTNode*> children) {
        childrenNodes = children;
    };
private:
    int nodeVal;
    void printNode(std::ostream& os) const {
        os << "ASSIGN";
    }
};

/**
 * Sequence of statements
 */
class SeqNode : public ASTNode {
public:
    SeqNode(list<ASTNode*> children) {
        childrenNodes = children;
    };
private:
    void printNode(std::ostream& os) const {
        os << "STATEMENTS";
    }
};

class IdentifierNode : public ASTNode {
public:
    IdentifierNode(string id, SymbolTableNode * symtblnode) {
        identifier = id;
        symbolTableNode = *symtblnode;
        //childrenNodes = children; should not have any children

    };
private:
    SymbolTableNode symbolTableNode;
    string identifier;
    void printNode(std::ostream& os) const {
        os << "VARIABLE_" << identifier;
    }
};

class IntNode : public ASTNode {
public:
    IntNode(int val) {
        nodeVal = val;
    };
private:
    int nodeVal;
    void printNode(std::ostream& os) const {
        os << "INT_" << nodeVal;
    }
};

class CharNode : public ASTNode {
public:
    CharNode(char val) {
        nodeVal = val;
    };
private:
    char nodeVal;
    void printNode(std::ostream& os) const {
        os << "CHAR_" << nodeVal;
    }
};

class FloatNode : public ASTNode {
public:
    FloatNode(float val) {
        nodeVal = val;
    };
private:
    float nodeVal;
    void printNode(std::ostream& os) const {
        os << "FLOAT_" << nodeVal;
    }
};

#endif //PROJECT_ASTNODES_H
