#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include <string>
#include <iostream>

using namespace std;
#include "include/tree.hh"
#include "SymbolTable.h"

#ifndef YYTOKENTYPE
# define YYTOKENTYPE
enum yytokentype
{
    IDENTIFIER = 258,
    INTEGER_CONSTANT = 259,
    FLOATING_CONSTANT = 260,
    CHARACTER_CONSTANT = 261,
    ENUMERATION_CONSTANT = 262,
    STRING_LITERAL = 263,
    SIZEOF = 264,
    PTR_OP = 265,
    INC_OP = 266,
    DEC_OP = 267,
    LEFT_OP = 268,
    RIGHT_OP = 269,
    LE_OP = 270,
    GE_OP = 271,
    EQ_OP = 272,
    NE_OP = 273,
    AND_OP = 274,
    OR_OP = 275,
    MUL_ASSIGN = 276,
    DIV_ASSIGN = 277,
    MOD_ASSIGN = 278,
    ADD_ASSIGN = 279,
    SUB_ASSIGN = 280,
    LEFT_ASSIGN = 281,
    RIGHT_ASSIGN = 282,
    AND_ASSIGN = 283,
    XOR_ASSIGN = 284,
    OR_ASSIGN = 285,
    TYPEDEF_NAME = 286,
    TYPEDEF = 287,
    EXTERN = 288,
    STATIC = 289,
    AUTO = 290,
    REGISTER = 291,
    CHAR = 292,
    SHORT = 293,
    INT = 294,
    LONG = 295,
    SIGNED = 296,
    UNSIGNED = 297,
    FLOAT = 298,
    DOUBLE = 299,
    CONST = 300,
    VOLATILE = 301,
    VOID = 302,
    STRUCT = 303,
    UNION = 304,
    ENUM = 305,
    ELIPSIS = 306,
    RANGE = 307,
    CASE = 308,
    DEFAULT = 309,
    IF = 310,
    ELSE = 311,
    SWITCH = 312,
    WHILE = 313,
    DO = 314,
    FOR = 315,
    GOTO = 316,
    CONTINUE = 317,
    BREAK = 318,
    RETURN = 319,
    ERROR = 320,
    SEMI = 321,
    OPENCUR = 322,
    CLOSCUR = 323,
    COMMA = 324,
    ASSIGN = 325,
    COLON = 326,
    OPENSQ = 327,
    CLOSSQ = 328,
    STAR = 329,
    OPENPAR = 330,
    CLOSEPAR = 331,
    TERNARY = 332,
    BAR = 333,
    XOR = 334,
    AND = 335,
    LESSTH = 336,
    GREATH = 337,
    PLUS = 338,
    MINUS = 339,
    SLASH = 340,
    MODULO = 341,
    TILDE = 342,
    BANG = 343,
    PERIOD = 344,
    NEWLINE = 345
};
#endif

/**
 * Yes it only works with inline. Don't ask me why
 *
 * @param token
 * @return
 */
inline string tokenToString2(int token) {
    string str;
    switch (token) {
        case AND:
            str = "AND";
            break;
        case STAR:
            str = "STAR";
            break;
        case PLUS:
            str = "PLUS";
            break;
        case MINUS:
            str = "MINUS";
            break;
        case TILDE:
            str = "TILDE";
            break;
        case BANG:
            str = "BANG";
            break;
        case BAR:
            str = "BAR";
            break;
        case XOR:
            str = "XOR";
            break;
        case LESSTH:
            str = "LESSTH";
            break;
        case GREATH:
            str = "GREATH";
            break;
        case LE_OP:
            str = "LE_OP";
            break;
        case GE_OP:
            str = "GE_OP";
            break;
        case EQ_OP:
            str = "EQ_OP";
            break;
        case NE_OP:
            str = "NE_OP";
            break;
        case SLASH:
            str = "DIV";
            break;
        case MODULO:
            str = "MODULO";
            break;
        case INT:
            str = "INT";
            break;
        case FLOAT:
            str = "FLOAT";
            break;
        case DOUBLE:
            str = "DOUBLE";
            break;
        case SHORT:
            str = "SHORT";
            break;
        case LONG:
            str = "LONG";
            break;
        case SIGNED:
            str = "SIGNED";
            break;
        case UNSIGNED:
            str = "UNSIGNED";
            break;
        case CHAR:
            str = "CHAR";
            break;
        default:
            str = "TOKENSTRINGNOTDEFINED";
            break;
    }
    return str;
}

class ASTNode {
public:
    ASTNode() {
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

    virtual void * get() {
        cout << "IF YOU'RE SEEING THIS DIE" << endl;
        return NULL;
    }


    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node) {
        node.printNode(os);
        return os;
    }
protected:
    set<int> types;
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    virtual void printNode(std::ostream& os) const {
        os << "NOT_PROGRAMMED";
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
                //os << *child;
                auto newRoot = ast.append_child(iRoot, child);
                copyTreeHelper(child, ast, newRoot);
            }
        }
    }
};


/**
 * In the future this might contain other things like pointers or [], see abstract_declarator
 * I'd say this would be optional children. Like it could be a leaf, or it could have kids like [2+3]
 */
class TypeNode : public ASTNode {
public:
    TypeNode() {
        //default- MUST set type in derived constructor
    }
    TypeNode(set<int>& type) {
        types = type;

    };

    void * get() {
        return &types;
    }
protected:
    set<int> types;
    void printNode(std::ostream& os) const {
        os << "TYPE_";
        for (int i : types) {
            os << tokenToString2(i);
        }
    }
};

class WhileNode : public ASTNode{
public:
    WhileNode(ASTNode* expr, ASTNode* stmt, bool dooo){
        list<ASTNode*> tempList;
        tempList.push_back(expr);
        tempList.push_back(stmt);
        childrenNodes = tempList;
        doo = dooo;
    }
private:
    bool doo;
    void printNode(std:: ostream& os) const{
        if(doo){
            os << "DO_WHILE";
        }
        else{
            os << "WHILE";
        }
    }
};

class IfNode : public ASTNode {
public:
    IfNode(ASTNode* expr, ASTNode* stmt){
        list<ASTNode*> tempList;
        tempList.push_back(expr);
        tempList.push_back(stmt);
        childrenNodes = tempList;
        flag = 0;
    }
    IfNode(ASTNode* expr, ASTNode* stmt, ASTNode* stmt2){
        list<ASTNode*> tempList;
        tempList.push_back(expr);
        tempList.push_back(stmt);
        tempList.push_back(stmt2);
        childrenNodes = tempList;
        flag = 1;
    }
private:
    bool flag;
    void printNode(std:: ostream& os) const{
        if(flag){
            os << "IF_NODE";
        }
        else{
            os << "IF_ELSE_NODE";
        }
    }
};

class UnaryNode : public TypeNode {
public:
    UnaryNode(int x, ASTNode* child) {
        list <ASTNode*> tempList;
        tempList.push_back(child);
        nodeType = x;
    }
private:
    int nodeType;
    void printNode(std:: ostream& os) const{
        os << "UNARY_" << tokenToString2(nodeType);
    }
};

//does not include tilde
class BitwiseNode : public ASTNode {
public:
    BitwiseNode(int x, ASTNode* left, ASTNode* right) {
        list <ASTNode *> tempList;
        tempList.push_back(left);
        tempList.push_back(right);
        childrenNodes = tempList;
        nodeType = x;
    }
private:
    int nodeType;
    void printNode(std:: ostream& os) const{
        os << "BITWISE_" << tokenToString2(nodeType);
    }
};

class LogicalNode : public ASTNode {
public:
    LogicalNode(int x, ASTNode* left, ASTNode* right){
        list <ASTNode*> tempList;
        tempList.push_back(left);
        tempList.push_back(right);
        childrenNodes = tempList;
        nodeType = x;
    };
private:
    int nodeType;
    void printNode(std:: ostream& os) const{
        os << "LOGICAL_" << nodeType;
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

class IdentifierNode : public TypeNode {
public:
    IdentifierNode(SymbolTableNode * symtblnode) {
        symbolTableNode = *symtblnode;
        identifier = symbolTableNode.getName();
        //type = SymbolTableNode.get
        //childrenNodes = children; should not have any children

    };
private:
    SymbolTableNode symbolTableNode;
    string identifier;
    void printNode(std::ostream& os) const {
        os << "VARIABLE_" << identifier;
    }
};

class IntNode : public TypeNode {
public:
    IntNode(int val) {
        nodeVal = val;
        types.insert(INT);
    };
private:
    int nodeVal;
    void printNode(std::ostream& os) const {
        os << "INT_" << nodeVal;
    }
};

class CharNode : public TypeNode {
public:
    CharNode(char val) {
        types.insert(CHAR);
        nodeVal = val;
    };
private:
    char nodeVal;
    void printNode(std::ostream& os) const {
        os << "CHAR_" << nodeVal;
    }
};

class FloatNode : public TypeNode {
public:
    FloatNode(float val) {
        types.insert(FLOAT);
        nodeVal = val;
    };
private:
    float nodeVal;
    void printNode(std::ostream& os) const {
        os << "FLOAT_" << nodeVal;
    }
};

class StringNode : public TypeNode {
public:
    StringNode(char * val) {
        nodeVal = val;
    };
private:
    string nodeVal;
    void printNode(std::ostream& os) const {
        os << "STRING_" << nodeVal;
    }
};


class CastNode : public TypeNode {
public:
    CastNode(ASTNode * type, ASTNode *nodeToCast) {
        list<ASTNode *> tmplist;
        tmplist.push_back(type);
        tmplist.push_back(nodeToCast);
        childrenNodes = tmplist;
    };
private:
    void printNode(std::ostream& os) const {
        os << "CAST";
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
        os << "RELATIONAL_" << tokenToString2(operationType);
    }
};

inline int computeTypeOrder(set<int>& typeSet) {
    //https://www.geeksforgeeks.org/type-conversion-c/
    if (typeSet.count(CHAR) == 1) {
        return 1;
    }
    if (typeSet.count(SHORT) == 1) {
        return 2;
    }
    if (typeSet.count(INT) == 1 && typeSet.count(UNSIGNED) == 1) {
        return 3;
    }
    if (typeSet.count(INT) == 1) {
        return 4;
    }
    if (typeSet.count(LONG) == 1) {
        return 5;
    }
    if (typeSet.count(FLOAT) == 1) {
        return 6;
    }
    if (typeSet.count(DOUBLE) == 1) {
        return 7;
    }
    cout << "SHOULDNT BE HERE, TYPE NOT FOUND MAYDAY MAYDAY";
    return -1;
}

/**
 * If returns a value > 0, then the right side needs casted to be bigger
 * If returns a value < 0, then the left side needs casted to be bigger
 * If returns 0, no casting is needed
 * @param left
 * @param right
 * @return
 */
inline int compareForCast(set<int>& left, set<int>& right) {

    int leftSize = computeTypeOrder(left);
    int rightSize = computeTypeOrder(right);
    return leftSize - rightSize;

}

/*
 * Simple math operators: +, -, *, /, %
 * left and right MUST both be TypeNode types or it will be bad
 */
class BinaryMathNode : public TypeNode {
public:
    BinaryMathNode(int type, ASTNode * left, ASTNode * right) {
        ASTNode * newLeft = left;
        ASTNode * newRight = right;

        set<int> leftSet = *(set<int>*) (left->get());
        set<int> rightSet = *(set<int>*) (right->get());
        int ret = compareForCast(leftSet, rightSet);
        if (ret < 0) {
            //Cast the node on the left to the type of the right node
            ASTNode * newtype = new TypeNode(rightSet);
            newLeft = new CastNode(newtype, left);
            newRight = right;
        } else if (ret > 0) {
            //Cast the node on the right to the type of the left node
            ASTNode * newtype = new TypeNode(leftSet);
            newRight = new CastNode(newtype, right);
            newLeft = left;
        }

        operationType = type;
        list<ASTNode*> tmplist;
        tmplist.push_back(newLeft);
        tmplist.push_back(newRight);
        childrenNodes = tmplist;
    };
private:
    int operationType;
    void printNode(std::ostream& os) const {
        os << "OPERATION_" << tokenToString2(operationType);
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


/**
 * Left is the declarator, right is either none (nothing) or the size (based on an expression)
 */
class ArrayNode : public ASTNode {
public:
    ArrayNode(ASTNode* left, ASTNode * right) {
        list<ASTNode*> tmplist;
        tmplist.push_back(left);
        tmplist.push_back(right);
        childrenNodes = tmplist;

    };

private:
    void printNode(std::ostream& os) const {
        os << "ARRAY";
    }
};

#endif //PROJECT_ASTNODES_H
