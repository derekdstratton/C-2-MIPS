#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include <string>
#include <iostream>

using namespace std;
#include "include/tree.hh"
#include "SymbolTable.h"

#include "yytokentype.h"
#include "astnodetype.h"

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

    virtual int getNodeType();
    virtual set<int> getTypes();
    virtual string getName();
    virtual void setSymbolNode(SymbolTableNode2* symtblnd2);
    virtual int getDimensions();
    virtual list<ASTNode*> getSizes();
    virtual int getVal() {
        cout << "OH NO GOVERNOR MY BLOODY TEA NIGEL" << endl;
        return -1;
    }
    virtual char getSeqType() {
        cout << "WHATCHU MEAN???";
        return '\0';
    }
    virtual int getOpType() {
        cout << "SHOULD NOT BE HERE";
        return -1;
    }
    virtual string walk() {
        cout << "WAWAEWAWA" << endl;
        for (auto x : getChildren()) {
            x->walk();
        }
        return "NA";
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

    static int registerCnt;
    static int labelCnt;
};


/**
 * In the future this might contain other things like pointers or [], see abstract_declarator
 * I'd say this would be optional children. Like it could be a leaf, or it could have kids like [2+3]
 */
class TypeNode : public ASTNode {
public:
    TypeNode();
    TypeNode(set<int>& type);

    int getNodeType() {
        return TYPENODE;
    }
    set<int> getTypes();
    void checkType();
protected:
    set<int> types; //todo figure out how this should know types like array and pointer in the int set. encode it.
    void printNode(std::ostream& os) const;
};

class WhileNode : public ASTNode{
public:
    WhileNode(ASTNode* expr, ASTNode* stmt, bool dooo);
    int getNodeType() {
        return WHILENODE;
    }
private:
    bool doo;
    void printNode(std:: ostream& os) const;
    string walk() {
        string initLabel = "l" + to_string(labelCnt++);
        cout << initLabel << ": " << endl;

        string s1 = "BREQ";
        string s2;
        string s3 = "0";
        string s4;

        if (!doo) {
            //while condition
            s2 = getChildren().front()->walk();
            s4  = "l" + to_string(labelCnt++);
            cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
            //then do
            getChildren().back()->walk();
        } else {
            //do
            getChildren().back()->walk();
            //then while
            s2 = getChildren().front()->walk();
            s4  = "l" + to_string(labelCnt++);
            cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
        }

        cout << "BR" << " " << initLabel << endl;
        cout << s4 << ":" << endl;

        return "";
    }
};

class IfNode : public ASTNode {
public:
    IfNode(ASTNode* expr, ASTNode* stmt);
    IfNode(ASTNode* expr, ASTNode* stmt, ASTNode* stmt2);
    int getNodeType() {
        return IFNODE;
    }
private:
    bool flag;
    void printNode(std:: ostream& os) const;
    string walk() {
        string s1 = "BREQ";
        string s2 = getChildren().front()->walk();
        string s3 = "0";
        string s4 = "l" + to_string(labelCnt++);
        cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
        getChildren().back()->walk();
        cout << s4 << ":" << endl;
        return "";
    }
};

class UnaryNode : public TypeNode {
public:
    UnaryNode(int x, ASTNode* child);
    int getNodeType() {
        return UNARYNODE;
    }
private:
    int nodeType;
    void printNode(std:: ostream& os) const;
};

//does not include tilde
class BitwiseNode : public ASTNode {
public:
    BitwiseNode(int x, ASTNode* left, ASTNode* right);
    int getNodeType() {
        return BITWISENODE;
    }
private:
    int nodeType;
    void printNode(std:: ostream& os) const{
        os << "BITWISE_" << tokenToString2(nodeType);
    }
};

class LogicalNode : public ASTNode {
public:
    LogicalNode(int x, ASTNode* left, ASTNode* right);
    int getNodeType() {
        return LOGICALNODE;
    }
private:
    int nodeType;
    void printNode(std:: ostream& os) const;
    string walk() {
        string s1 = tokenToString2(nodeType);
        string s2 = getChildren().front()->walk();
        string s3 = getChildren().back()->walk();
        string s4 = "t" + to_string(registerCnt++);
        cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
        return s4;
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
    AssignNode(ASTNode * lvalue, ASTNode * rvalue);
    int getNodeType() {
        return ASSIGNNODE;
    }
private:
    int nodeVal;
    void printNode(std::ostream& os) const;
    string walk() {
        string s1 = "ASSIGN";
        string s2 = getChildren().back()->walk();
        string s3 = getChildren().front()->walk();
        cout << s1 << " " << s2 << " " << s3 << endl;
        return s3;
    }
};

/**
 * Represents an empty node. Used for empty/not used statements
 */
class NoneNode : public ASTNode {
public:
    NoneNode();
    int getNodeType() {
        return NONENODE;
    }
private:
    void printNode(std::ostream& os) const;
};

/**
 * Declaration. First is a node of decl specifiers, second is the thing being declared
 */
class DeclNode : public ASTNode {
public:
    DeclNode(ASTNode * first, ASTNode * second);;
    int getNodeType() {
        return DECLNODE;
    }
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
    int getNodeType() {
        return SEQNODE;
    }
    char getSeqType() {
        return seqType;
    }
private:
    char seqType;
    void printNode(std::ostream& os) const;
    string walk() {
        switch(seqType) {
            case 'g': {
                cout << "CALL" << " " << "main" << endl;
                break;
            }
            default: {
                cout << "OTHER SEQ NODE" << endl;
                break;
            }
        }
        for (auto x : getChildren()) {
            x->walk();
        }
        return "";
    }
};

class IdentifierNode : public TypeNode {
public:
    IdentifierNode(string * name);
    ~IdentifierNode();
    string getName();
    void setSymbolNode(SymbolTableNode2* symtblnd2);
    int getDimensions();
    int getNodeType() {
        return IDENTIFIERNODE;
    }
private:
    SymbolTableNode2 * symbolTableNode2;
    string identifier;
    list<int> sizeList;
    void printNode(std::ostream& os) const;
    string walk() {
        return identifier;
    }
};

class IntNode : public TypeNode {
public:
    IntNode(int val);
    int getVal() {
        return nodeVal;
    }
    int getNodeType() {
        return INTNODE;
    }
private:
    int nodeVal;
    void printNode(std::ostream& os) const;
    string walk() {
        return to_string(nodeVal);
    }
};

class CharNode : public TypeNode {
public:
    CharNode(char val);
    int getNodeType() {
        return CHARNODE;
    }
private:
    char nodeVal;
    void printNode(std::ostream& os) const;
};

class FloatNode : public TypeNode {
public:
    FloatNode(float val);
    int getNodeType() {
        return FLOATNODE;
    }
private:
    float nodeVal;
    void printNode(std::ostream& os) const;
};

class StringNode : public TypeNode {
public:
    StringNode(string * val);
    int getNodeType() {
        return STRINGNODE;
    }
private:
    string nodeVal;
    void printNode(std::ostream& os) const;
};


class CastNode : public TypeNode {
public:
    CastNode(ASTNode * type, ASTNode *nodeToCast);
    int getNodeType() {
        return CASTNODE;
    }
private:
    void printNode(std::ostream& os) const;
};

/**
 * Nodes for relations
 */
class RelationalNode : public ASTNode {
public:
    RelationalNode(int type, ASTNode * left, ASTNode * right);
    int getNodeType() {
        return RELATIONALNODE;
    }
    int getOpType() {
        return operationType;
    }
private:
    int operationType;
    void printNode(std::ostream& os) const;
    string walk() {
        string s1 = tokenToString2(operationType);
        auto it = getChildren().begin();
        string s2 = (*it)->walk();
        it++;
        string s3 = (*it)->walk();
        string s4 = "t" + to_string(registerCnt++);
        cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
        return s4;
    }
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
    BinaryMathNode(int type, ASTNode * left, ASTNode * right);
    int getNodeType() {
        return BINARYMATHNODE;
    }
    int getOpType();
private:
    int operationType;
    void printNode(std::ostream& os) const;
    string walk() {
        string s1 = tokenToString2(operationType);
        auto it = getChildren().begin();
        string s2 = (*it)->walk();
        it++;
        string s3 = (*it)->walk();
        string s4 = "t" + to_string(registerCnt++);
        cout << s1 << " " << s2 << " " << s3 << " " << s4 << endl;
        return s4;
    }
};

//todo could/should this be generalized to other control flow breaks?
//this is more a question to be answered when getting into functions
class ReturnNode : public ASTNode {
public:
    ReturnNode(ASTNode* child);
    int getNodeType() {
        return RETURNNODE;
    }
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
    int getDimensions();
    int getNodeType() {
        return ARRAYNODE;
    }
private:
    list<ASTNode *> sizeList;
    void printNode(std::ostream& os) const;
};


/**
 * @brief node for functions. Stores function name, parameter types if it is a prototype/definition
 */
class FuncNode : public TypeNode {
public:
    FuncNode(string name, list<set<int>> types, list<ASTNode*> children, list<pair<string, set<int>>> arguments, int type);
    string getName();
    int getNodeType() {
        return FUNCNODE;
    }
private:
    string funcName;
    list<set<int>> paramTypes; //for prototypes
    list<pair<string, set<int>>> args; //for definitions
    void printNode(std::ostream& os) const;
    int funcType; //0 for prototype, 1 for definition, 2 for call
    string walk() {
        //cout << "FUNCTION (TODO)" << endl;
        switch (funcType) {
            case 0:
                cout << "PROTOTYPE- DO NOTHING" << endl;
                break;
            case 1:
                cout << "PROCENTRY " << funcName << endl;
                break; //todo output how many parameters and how many local variables
                    //num local variables known after doing a walk, based on offset symbol table
            case 2:
                cout << "CALL " << funcName << endl;
                break;
            default:
                break;
        }
        for (auto a : getChildren()) {
            a->walk();
        }
        if (funcType == 1) {
            cout << "ENDPROC" << endl;
        }
        //todo switch(funcType)
        return "";
    }
};

class ForNode : public ASTNode {
public:
    ForNode(list<ASTNode*> ptrList, bool arr[3], ASTNode * stmt);
    int getNodeType() {
        return FORNODE;
    }
private:
    bool stmtWritten[3];
    void printNode(std::ostream& os) const;
};

#endif //PROJECT_ASTNODES_H
