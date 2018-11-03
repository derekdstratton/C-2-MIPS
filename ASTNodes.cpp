#include "ASTNodes.h"

string tokenToString2(int token) {
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

list<ASTNode *> ASTNode::getChildren() {
    return childrenNodes;
}

void ASTNode::copyTree(ASTNode *&root, tree<ASTNode *> &ast) {
    //Make sure the ast is clear
    ast.clear();
    //first insert the top
    auto firstNode = ast.insert(ast.begin(), root);
    //now add the children
    copyTreeHelper(root, ast, firstNode);

}

set<int> ASTNode::getTypes() {
    cout << "IF YOU'RE SEEING THIS DIE" << endl;
    set<int> fail;
    return fail;
}

string ASTNode::getName() {
    cout << "IF YOURE SEEING THIS RIP" << endl;
    return nullptr;
}

void ASTNode::setSymbolNode(SymbolTableNode2 symtblnd2) {
    cout << "IF YOURE SEEING THIS RAVIOLI" << endl;
}

std::ostream &operator<<(std::ostream &os, const ASTNode &node) {
    node.printNode(os);
    return os;
}

int computeTypeOrder(set<int> &typeSet) {
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

int compareForCast(set<int> &left, set<int> &right) {

    int leftSize = computeTypeOrder(left);
    int rightSize = computeTypeOrder(right);
    return leftSize - rightSize;

}

void ASTNode::printNode(std::ostream &os) const {
    os << "NOT_PROGRAMMED";
}

void ASTNode::copyTreeHelper(ASTNode *&src_node, tree<ASTNode *> &ast, typename tree<ASTNode *>::iterator iRoot) {
    //Node has children, insert them
    if (src_node->getChildren().size() != 0) {
        for (auto &child : src_node->getChildren()) {
            //os << *child;
            auto newRoot = ast.append_child(iRoot, child);
            copyTreeHelper(child, ast, newRoot);
        }
    }
}

ASTNode::ASTNode() {
}

TypeNode::TypeNode() {
    //default- MUST set type in derived constructor
}

TypeNode::TypeNode(set<int> &type) {
    types = type;

}

set<int> TypeNode::getTypes() {
    return types;
}

void TypeNode::printNode(std::ostream &os) const {
    os << "TYPE_";
    for (int i : types) {
        os << tokenToString2(i);
    }
}

WhileNode::WhileNode(ASTNode *expr, ASTNode *stmt, bool dooo) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    childrenNodes = tempList;
    doo = dooo;
}

void WhileNode::printNode(std::ostream &os) const {
    if(doo){
        os << "DO_WHILE";
    }
    else{
        os << "WHILE";
    }
}

IfNode::IfNode(ASTNode *expr, ASTNode *stmt) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    childrenNodes = tempList;
    flag = 0;
}

IfNode::IfNode(ASTNode *expr, ASTNode *stmt, ASTNode *stmt2) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    tempList.push_back(stmt2);
    childrenNodes = tempList;
    flag = 1;
}

void IfNode::printNode(std::ostream &os) const {
    if(flag){
        os << "IF_NODE";
    }
    else{
        os << "IF_ELSE_NODE";
    }
}

UnaryNode::UnaryNode(int x, ASTNode *child) {
    list <ASTNode*> tempList;
    tempList.push_back(child);
    nodeType = x;
}

void UnaryNode::printNode(std::ostream &os) const {
    os << "UNARY_" << tokenToString2(nodeType);
}

BitwiseNode::BitwiseNode(int x, ASTNode *left, ASTNode *right) {
    nodeType = x;
    list<ASTNode*> tmplist;

    ASTNode * newLeft;
    ASTNode * newRight;

    set<int> leftSet = left->getTypes();
    set<int> rightSet = right->getTypes();
    int ret = compareForCast(leftSet, rightSet);
    if (ret < 0) {
        //Cast the node on the left to the type of the right node
        ASTNode * newtype = new TypeNode(rightSet);
        newLeft = new CastNode(newtype, left);
        newRight = right;
        tmplist.push_back(newLeft);
        tmplist.push_back(newRight);
        types = rightSet;
    } else if (ret > 0) {
        //Cast the node on the right to the type of the left node
        ASTNode * newtype = new TypeNode(leftSet);
        newRight = new CastNode(newtype, right);
        newLeft = left;
        tmplist.push_back(newLeft);
        tmplist.push_back(newRight);
        types = leftSet;
    } else {
        tmplist.push_back(left);
        tmplist.push_back(right);
        types = leftSet;
    }

    childrenNodes = tmplist;
}

LogicalNode::LogicalNode(int x, ASTNode *left, ASTNode *right) {
    list <ASTNode*> tempList;
    tempList.push_back(left);
    tempList.push_back(right);
    childrenNodes = tempList;
    nodeType = x;
}

void LogicalNode::printNode(std::ostream &os) const {
    os << "LOGICAL_" << nodeType;
}

AssignNode::AssignNode(ASTNode *lvalue, ASTNode *rvalue) {
    list <ASTNode*> tmplist;

    set<int> leftSet = lvalue->getTypes();
    types = leftSet;

    tmplist.push_back(lvalue);
    tmplist.push_back(rvalue);
    childrenNodes = tmplist;
}

void AssignNode::printNode(std::ostream &os) const {
    os << "ASSIGN";
}

NoneNode::NoneNode() {
}

void NoneNode::printNode(std::ostream &os) const {
    os << "NONE";
}

DeclNode::DeclNode(ASTNode *first, ASTNode *second) {
    list<ASTNode*> tmpList;
    tmpList.push_back(first);
    tmpList.push_back(second);
    childrenNodes = tmpList;
}

void DeclNode::printNode(std::ostream &os) const {
    os << "DECLARATION";
}

SeqNode::SeqNode(ASTNode *first, ASTNode *second) {
    list<ASTNode*> tmpList;
    tmpList.push_back(first);
    tmpList.push_back(second);
    childrenNodes = tmpList;
}

void SeqNode::printNode(std::ostream &os) const {
    os << "STATEMENTS";
}

IdentifierNode::IdentifierNode(string *name) {
    identifier = *name;
}

string IdentifierNode::getName() {
    return identifier;
}

void IdentifierNode::setSymbolNode(SymbolTableNode2 symtblnd2) {
    symbolTableNode2 = symtblnd2;
    types = symbolTableNode2.types;
}

void IdentifierNode::printNode(std::ostream &os) const {
    os << "VARIABLE_" << identifier;
    for (auto item : types) {
        os << "_" << tokenToString2(item);
    }
}

void IntNode::printNode(std::ostream &os) const {
    os << "INT_" << nodeVal;
}

IntNode::IntNode(int val) {
    nodeVal = val;
    types.insert(INT);
}

CharNode::CharNode(char val) {
    types.insert(CHAR);
    nodeVal = val;
}

void CharNode::printNode(std::ostream &os) const {
    os << "CHAR_" << nodeVal;
}

FloatNode::FloatNode(float val) {
    types.insert(FLOAT);
    nodeVal = val;
}

void FloatNode::printNode(std::ostream &os) const {
    os << "FLOAT_" << nodeVal;
}

StringNode::StringNode(string *val) {
    nodeVal = *val;
}

void StringNode::printNode(std::ostream &os) const {
    os << "STRING_" << nodeVal;
}

CastNode::CastNode(ASTNode *type, ASTNode *nodeToCast) {
    list<ASTNode *> tmplist;
    tmplist.push_back(type);
    tmplist.push_back(nodeToCast);
    childrenNodes = tmplist;
    types = type->getTypes();
}

void CastNode::printNode(std::ostream &os) const {
    os << "CAST";
}

RelationalNode::RelationalNode(int type, ASTNode *left, ASTNode *right) {
    operationType = type;
    list<ASTNode*> tmplist;
    tmplist.push_back(left);
    tmplist.push_back(right);
    childrenNodes = tmplist;
}

void RelationalNode::printNode(std::ostream &os) const {
    os << "RELATIONAL_" << tokenToString2(operationType);
}

BinaryMathNode::BinaryMathNode(int type, ASTNode *left, ASTNode *right) {
    operationType = type;
    list<ASTNode*> tmplist;

    ASTNode * newLeft;
    ASTNode * newRight;

    set<int> leftSet = left->getTypes();
    set<int> rightSet = right->getTypes();
    int ret = compareForCast(leftSet, rightSet);
    if (ret < 0) {
        //Cast the node on the left to the type of the right node
        ASTNode * newtype = new TypeNode(rightSet);
        newLeft = new CastNode(newtype, left);
        newRight = right;
        tmplist.push_back(newLeft);
        tmplist.push_back(newRight);
        types = rightSet;
    } else if (ret > 0) {
        //Cast the node on the right to the type of the left node
        ASTNode * newtype = new TypeNode(leftSet);
        newRight = new CastNode(newtype, right);
        newLeft = left;
        tmplist.push_back(newLeft);
        tmplist.push_back(newRight);
        types = leftSet;
    } else {
        tmplist.push_back(left);
        tmplist.push_back(right);
        types = leftSet;
    }

    childrenNodes = tmplist;
}

void BinaryMathNode::printNode(std::ostream &os) const {
    os << "OPERATION_" << tokenToString2(operationType);
    for (auto item : types) {
        os << "_" << tokenToString2(item);
    }
}

ReturnNode::ReturnNode(ASTNode *child) {
    if (child == NULL) {
        list<ASTNode*> emptyList;
        childrenNodes = emptyList;
    } else {
        list<ASTNode*> tmp;
        tmp.push_back(child);
        childrenNodes = tmp;
    }

}

void ReturnNode::printNode(std::ostream &os) const {
    os << "RETURN";
}

ArrayNode::ArrayNode(ASTNode *left, ASTNode *right) {
    list<ASTNode*> tmplist;
    tmplist.push_back(left);
    tmplist.push_back(right);
    childrenNodes = tmplist;

}

void ArrayNode::printNode(std::ostream &os) const {
    os << "ARRAY";
}
