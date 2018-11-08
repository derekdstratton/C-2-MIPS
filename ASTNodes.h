#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include <string>
#include <iostream>

using namespace std;
#include "include/tree.hh"
#include "SymbolTable.h"

#include "yytokentype.h"

/**
 *
 * @param token
 * @return
 */
string tokenToString2(int token);

class ASTNode {
public:
    ASTNode();

    list<ASTNode*> getChildren();

    /** Copies the ASTNode into a tree.hh tree
     *
     * @param root
     * @param ast A tree.hh to be copied into
     */
    static void copyTree(ASTNode*& root, tree<ASTNode*> & ast);

    virtual set<int> getTypes();
    virtual string getName();
    virtual void setSymbolNode(SymbolTableNode2* symtblnd2);
    virtual list<ASTNode*> getSizes();
    virtual int getVal() {
        cout << "OH NO GOVERNOR MY BLOODY TEA NIGEL" << endl;
        return -1;
    }

    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node);
protected:
    set<int> types;
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    virtual void printNode(std::ostream& os) const;

    /**
     *
     * @param src_node
     * @param ast
     * @param iRoot
     */
    static void copyTreeHelper(ASTNode*& src_node, tree<ASTNode*> & ast, typename tree<ASTNode*>::iterator iRoot);
};


/**
 * In the future this might contain other things like pointers or [], see abstract_declarator
 * I'd say this would be optional children. Like it could be a leaf, or it could have kids like [2+3]
 */
class TypeNode : public ASTNode {
public:
    TypeNode();
    TypeNode(set<int>& type);;

    set<int> getTypes();
protected:
    set<int> types; //todo figure out how this should know types like array and pointer in the int set. encode it.
    void printNode(std::ostream& os) const;
};

class WhileNode : public ASTNode{
public:
    WhileNode(ASTNode* expr, ASTNode* stmt, bool dooo);
private:
    bool doo;
    void printNode(std:: ostream& os) const;
};

class IfNode : public ASTNode {
public:
    IfNode(ASTNode* expr, ASTNode* stmt);
    IfNode(ASTNode* expr, ASTNode* stmt, ASTNode* stmt2);
private:
    bool flag;
    void printNode(std:: ostream& os) const;
};

class UnaryNode : public TypeNode {
public:
    UnaryNode(int x, ASTNode* child);
private:
    int nodeType;
    void printNode(std:: ostream& os) const;
};

//does not include tilde
class BitwiseNode : public ASTNode {
public:
    BitwiseNode(int x, ASTNode* left, ASTNode* right);
private:
    int nodeType;
    void printNode(std:: ostream& os) const{
        os << "BITWISE_" << tokenToString2(nodeType);
    }
};

class LogicalNode : public ASTNode {
public:
    LogicalNode(int x, ASTNode* left, ASTNode* right);
private:
    int nodeType;
    void printNode(std:: ostream& os) const;
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
    AssignNode(ASTNode * lvalue, ASTNode * rvalue);
private:
    int nodeVal;
    void printNode(std::ostream& os) const;
};

/**
 * Represents an empty node. Used for empty/not used statements
 */
class NoneNode : public ASTNode {
public:
    NoneNode();;
private:
    void printNode(std::ostream& os) const;
};

/**
 * Declaration. First is a node of decl specifiers, second is the thing being declared
 */
class DeclNode : public ASTNode {
public:
    DeclNode(ASTNode * first, ASTNode * second);;
private:
    void printNode(std::ostream& os) const;
};

/**
 * Sequence of statements, left to right
 */
class SeqNode : public ASTNode {
public:
    SeqNode(char seq, ASTNode * first, ASTNode * second);
    SeqNode(char seq, list<ASTNode*> statementList);
private:
    char seqType;
    void printNode(std::ostream& os) const;
};

class IdentifierNode : public TypeNode {
public:
    IdentifierNode(string * name);
    ~IdentifierNode();
    string getName();
    void setSymbolNode(SymbolTableNode2* symtblnd2);
private:
    SymbolTableNode2 * symbolTableNode2;
    string identifier;
    list<int> sizeList;
    void printNode(std::ostream& os) const;
};

class IntNode : public TypeNode {
public:
    IntNode(int val);
    int getVal() {
        return nodeVal;
    }
private:
    int nodeVal;
    void printNode(std::ostream& os) const;
};

class CharNode : public TypeNode {
public:
    CharNode(char val);;
private:
    char nodeVal;
    void printNode(std::ostream& os) const;
};

class FloatNode : public TypeNode {
public:
    FloatNode(float val);;
private:
    float nodeVal;
    void printNode(std::ostream& os) const;
};

class StringNode : public TypeNode {
public:
    StringNode(string * val);;
private:
    string nodeVal;
    void printNode(std::ostream& os) const;
};


class CastNode : public TypeNode {
public:
    CastNode(ASTNode * type, ASTNode *nodeToCast);;
private:
    void printNode(std::ostream& os) const;
};

/**
 * Nodes for relations
 */
class RelationalNode : public ASTNode {
public:
    RelationalNode(int type, ASTNode * left, ASTNode * right);;
private:
    int operationType;
    void printNode(std::ostream& os) const;
};

int computeTypeOrder(set<int>& typeSet);

/**
 * If returns a value > 0, then the right side needs casted to be bigger
 * If returns a value < 0, then the left side needs casted to be bigger
 * If returns 0, no casting is needed
 * @param left
 * @param right
 * @return
 */
int compareForCast(set<int>& left, set<int>& right);

/*
 * Simple math operators: +, -, *, /, %
 * left and right MUST both be TypeNode types or it will be bad
 */
class BinaryMathNode : public TypeNode {
public:
    BinaryMathNode(int type, ASTNode * left, ASTNode * right);;
private:
    int operationType;
    void printNode(std::ostream& os) const;
};

//todo could/should this be generalized to other control flow breaks?
//this is more a question to be answered when getting into functions
class ReturnNode : public ASTNode {
public:
    ReturnNode(ASTNode* child);;
private:
    void printNode(std::ostream& os) const;
};


/**
 * Left is the declarator (variable), right is a list of sizes
 */
class ArrayNode : public TypeNode {
public:
    ArrayNode(ASTNode* var, list<ASTNode *> sizes);
    list<ASTNode*> getSizes();
private:
    list<ASTNode *> sizeList;
    void printNode(std::ostream& os) const;
};


/**
 * Needs return type, parameters names and types
 */
class FuncNode : public TypeNode {
public:
    FuncNode(string name, set<int> type, list<pair <string, int>> params);
private:
    list<pair <string, int>> parameters;
    int retType;
    string funcName;
    void printNode(std::ostream& os) const;
};

class ForNode : public ASTNode {
public:
    ForNode(list<ASTNode*> ptrList, bool arr[3]);
private:
    list<ASTNode*> stmtList;
    bool stmtWritten[3];
};

#endif //PROJECT_ASTNODES_H
