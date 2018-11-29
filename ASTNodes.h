#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

//Included libraries

#include <list>
#include <string>
#include <iostream>
#include <fstream>

#include "include/tree.hh"
#include "SymbolTable.h"
#include "yytokentype.h"
#include "astnodetype.h"

using namespace std;

//Helper Functions

string tokenToString2(int token);
int getByteSize(set<int> typeSet);
int computeTypeOrder(set<int>& typeSet);
int compareForCast(set<int>& left, set<int>& right);

/**
 * Main base class for all Abstract Syntax Tree nodes
 */
class ASTNode {
public:
    ASTNode();
    list<ASTNode*> getChildren();
    static void copyTree(ASTNode*& root, tree<ASTNode*> & ast);
    virtual int getLineNum();
    virtual int getNodeType();
    virtual set<int> getTypes();
    virtual string getName();
    virtual void setSymbolNode(SymbolTableNode2* symtblnd2);
    virtual int getDimensions();
    virtual list<ASTNode*> getSizes();
    virtual int getVal();
    virtual char getSeqType();
    virtual int getOpType();
    virtual string walk();
    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node);
protected:
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    static int registerCnt;
    static int labelCnt;
    static SymbolTable table3ac;
    static vector<vector<string>> main3ac;
    //private helper functions
    virtual void printNode(std::ostream& os) const;
    static void copyTreeHelper(ASTNode*& src_node, tree<ASTNode*> & ast, typename tree<ASTNode*>::iterator iRoot);
};

/**
 * In the future this might contain other things like pointers or [], see abstract_declarator
 * I'd say this would be optional children. Like it could be a leaf, or it could have kids like [2+3]
 */
class TypeNode : public ASTNode {
public:
    TypeNode();
    explicit TypeNode(set<int>& type);
    int getNodeType() override;
    set<int> getTypes() override;
    void checkType();
protected:
    set<int> types;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 * Left is the declarator (variable), right is a list of sizes
 */
class ArrayNode : public TypeNode {
public:
    ArrayNode(ASTNode* var, list<ASTNode *> sizes);
    list<ASTNode*> getSizes() override;
    int getDimensions() override;
    int getNodeType() override;
private:
    list<ASTNode *> sizeList;
    void printNode(std::ostream& os) const override;
    string walk() override;
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
class AssignNode : public TypeNode {
public:
    AssignNode(ASTNode * lvalue, ASTNode * rvalue);
    int getNodeType() override;
private:
    int nodeVal;
    void printNode(std::ostream& os) const override;
    string walk() override;
};


/**
 * Simple math operators: +, -, *, /, %
 * left and right MUST both be TypeNode types or it will be bad
 */
class BinaryMathNode : public TypeNode {
public:
    BinaryMathNode(int type, ASTNode * left, ASTNode * right);
    int getNodeType() override;
    int getOpType() override;
private:
    int operationType;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 * does not include tilde
 */
class BitwiseNode : public TypeNode {
public:
    BitwiseNode(int x, ASTNode* left, ASTNode* right);
    int getNodeType() override;
private:
    int nodeType;
    void printNode(std:: ostream& os) const override;
};

/**
 * Right hand side is a TypeNode, left is the Type to cast to
 */
class CastNode : public TypeNode {
public:
    CastNode(ASTNode * type, ASTNode *nodeToCast);
    int getNodeType() override;
private:
    void printNode(std::ostream& os) const override;
};

/**
 * Declaration. First is a node of decl specifiers, second is the thing being declared
 */
class DeclNode : public ASTNode {
public:
    DeclNode(ASTNode * first, ASTNode * second);;
    int getNodeType() override;
private:
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 * For loop node with everything in appropriate positions
 */
class ForNode : public ASTNode {
public:
    ForNode(list<ASTNode*> ptrList, bool arr[3], ASTNode * stmt);
    int getNodeType() override {
        return FORNODE;
    }
private:
    bool stmtWritten[3];
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 * @brief node for functions. Stores function name, parameter types if it is a prototype/definition
 */
class FuncNode : public TypeNode {
public:
    FuncNode(string name, list<set<int>> types, list<ASTNode*> children, list<pair<string, set<int>>> arguments, int type);
    string getName() override;
    int getNodeType() override;
private:
    string funcName;
    list<set<int>> paramTypes; //for prototypes
    list<pair<string, set<int>>> args; //for definitions
    void printNode(std::ostream& os) const override;
    int funcType; //0 for prototype, 1 for definition, 2 for call
    string walk() override;
};

/**
 * Node for if, including the expression to evaluate and stuff in the braces
 */
class IfNode : public ASTNode {
public:
    IfNode(ASTNode* expr, ASTNode* stmt);
    IfNode(ASTNode* expr, ASTNode* stmt, ASTNode* stmt2);
    int getNodeType() override;
private:
    bool flag; //Set to true if it's an if node, set to 0 if it's an if else node
    void printNode(std:: ostream& os) const override;
    string walk() override;
};


/**
 *
 */
class LogicalNode : public ASTNode {
public:
    LogicalNode(int x, ASTNode* left, ASTNode* right);
    int getNodeType() override;
private:
    int nodeType;
    void printNode(std:: ostream& os) const override;
    string walk() override;
};

/**
 * Nodes for relations
 */
class RelationalNode : public ASTNode {
public:
    RelationalNode(int type, ASTNode * left, ASTNode * right);
    int getNodeType() override;
    int getOpType() override;
private:
    int operationType;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class ReturnNode : public ASTNode {
public:
    explicit ReturnNode(ASTNode* child);
    int getNodeType() override;
private:
    void printNode(std::ostream& os) const override;
    string walk() override;
};


/**
 * Sequence of statements, left to right
 */
class SeqNode : public ASTNode {
public:
    SeqNode(char seq, ASTNode * first, ASTNode * second);
    SeqNode(char seq, list<ASTNode*> statementList);
    int getNodeType() override;
    char getSeqType() override;
private:
    char seqType;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class UnaryNode : public TypeNode {
public:
    UnaryNode(int x, ASTNode* child);
    int getNodeType() override;
private:
    int nodeType;
    void printNode(std:: ostream& os) const override;
};

/**
 *
 */
class WhileNode : public ASTNode{
public:
    WhileNode(ASTNode* expr, ASTNode* stmt, bool dooo);
    int getNodeType() override;
private:
    bool doo;
    void printNode(std:: ostream& os) const override;
    string walk() override;
};

//Leaf Nodes

/**
 *
 */
class IdentifierNode : public TypeNode {
public:
    explicit IdentifierNode(string * name);
    ~IdentifierNode();
    string getName() override;
    void setSymbolNode(SymbolTableNode2* symtblnd2) override;
    int getDimensions() override;
    int getNodeType() override;
private:
    SymbolTableNode2 * symbolTableNode2;
    string identifier;
    list<int> sizeList;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class IntNode : public TypeNode {
public:
    explicit IntNode(int val);
    int getVal() override;
    int getNodeType() override;
private:
    int nodeVal;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class CharNode : public TypeNode {
public:
    explicit CharNode(char val);
    int getNodeType() override;
private:
    char nodeVal;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class FloatNode : public TypeNode {
public:
    explicit FloatNode(float val);
    int getNodeType() override;
private:
    float nodeVal;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 *
 */
class StringNode : public TypeNode {
public:
    explicit StringNode(string * val);
    int getNodeType() override;
private:
    string nodeVal;
    void printNode(std::ostream& os) const override;
    string walk() override;
};

/**
 * Represents an empty node. Used for empty/not used statements
 */
class NoneNode : public ASTNode {
public:
    NoneNode();
    int getNodeType() override;
private:
    void printNode(std::ostream& os) const override;
    string walk() override;
};

#endif //PROJECT_ASTNODES_H
