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

class DeclSpecsNode : public ASTNode {
public:
    //todo it should definitely take more than 1 arg
    DeclSpecsNode(int x) {
        nodeType = x;
    };
private:
    int nodeType;
    void printNode(std::ostream& os) const {
        os << "DECL_SPECIFIERS_" << nodeType;
    }
};

/**
 * Reprsented 3 address code:
 * ASSIGN op1 op2 op3, op3 := op1
 *
 * 2 Children of the node
 * Child 1 is the lvalue, op3
 * Child 2 is the rvalue, op1
 * (op2 is blank)
 */
class AssignNode : public ASTNode {
public:
    AssignNode(ASTNode * lvalue, ASTNode * rvalue) {
        list <ASTNode*> tempList;
        tempList.push_back(lvalue);
        tempList.push_back(rvalue);
        childrenNodes = tempList;
    };
private:
    int nodeVal;
    void printNode(std::ostream& os) const {
        os << "ASSIGN";
    }
};

/**
 * Represents an empty node. Used for empty/not used statements
 */
class NoneNode : public ASTNode {
public:
    NoneNode() {
    };
private:
    void printNode(std::ostream& os) const {
        os << "NONE";
    }
};

/**
 * Declaration. First is a node of decl specifiers, second is the thing being declared
 */
class DeclNode : public ASTNode {
public:
    DeclNode(ASTNode * first, ASTNode * second) {
        list<ASTNode*> tmpList;
        tmpList.push_back(first);
        tmpList.push_back(second);
        childrenNodes = tmpList;
    };
private:
    void printNode(std::ostream& os) const {
        os << "DECLARATION";
    }
};

/**
 * Sequence of statements, left to right
 */
class SeqNode : public ASTNode {
public:
    SeqNode(ASTNode * first, ASTNode * second) {
        list<ASTNode*> tmpList;
        tmpList.push_back(first);
        tmpList.push_back(second);
        childrenNodes = tmpList;
    };
private:
    void printNode(std::ostream& os) const {
        os << "STATEMENTS";
    }
};

class IdentifierNode : public ASTNode {
public:
    IdentifierNode(SymbolTableNode * symtblnode) {
        symbolTableNode = *symtblnode;
        identifier = symbolTableNode.getName();
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

class StringNode : public ASTNode {
public:
    StringNode(char * val) {
        nodeVal = val;
    };
private:
    string nodeVal;
    void printNode(std::ostream& os) const {
        os << "FLOAT_" << nodeVal;
    }
};

/**
 * Nodes for relations
 */
class RelationalNode : public ASTNode {
public:
    RelationalNode(int type, ASTNode * left, ASTNode * right) {
        operationType = type;
        list<ASTNode*> tmplist;
        tmplist.push_back(left);
        tmplist.push_back(right);
        childrenNodes = tmplist;
    };
private:
    int operationType;
    void printNode(std::ostream& os) const {
        string printable;
        switch(operationType){
            case 336:
                printable = "LESSTH";
                break;
            case 337:
                printable = "GREATH";
                break;
            case 270:
                printable = "LE_OP";
                break;
            case 271:
                printable = "GE_OP";
                break;
            case 272:
                printable = "EQ_OP";
                break;
            case 273:
                printbale = "NE_OP";
                break;
            default:
                printable = "sauce";
                break;


        }
        os << "RELATIONAL_" << printable;
    }
};

/*
 * Simple math operators: +, -, *, /, %
 */
class BinaryMathNode : public ASTNode {
public:
    BinaryMathNode(int type, ASTNode * left, ASTNode * right) {
        operationType = type;
        list<ASTNode*> tmplist;
        tmplist.push_back(left);
        tmplist.push_back(right);
        childrenNodes = tmplist;
    };
private:
    int operationType;
    void printNode(std::ostream& os) const {
        string printable;
        switch(operationType) {
            case 338:
                printable = "PLUS";
                break;
            case 339:
                printable = "MINUS";
                break;
            case 329:
                printable = "MUL";
                break;
            case 340:
                printable = "DIV";
                break;
            case 341:
                printable = "MODULO";
                break;
            default:
                printable = "CACTUS";
                break;
        }
        os << "OPERATION_" << printable;
    }
};

//todo could/should this be generalized to other control flow breaks?
//this is more a question to be answered when getting into functions
class ReturnNode : public ASTNode {
public:
    ReturnNode(ASTNode* child) {
        if (child == NULL) {
            list<ASTNode*> emptyList;
            childrenNodes = emptyList;
        } else {
            list<ASTNode*> tmp;
            tmp.push_back(child);
            childrenNodes = tmp;
        }

    };
private:
    void printNode(std::ostream& os) const {
        os << "RETURN";
    }
};

#endif //PROJECT_ASTNODES_H
