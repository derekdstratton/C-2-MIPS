#include "ASTNodes.h"
extern int yylineno;
extern deque <char> columnQueue;
extern int yyleng;

extern void outputError(string errmsg1, string errmsg2, bool errtype);

/**
 * @brief converts a defined token into a string
 * @param token is the token to be converted
 * @return returns a string based on which token was passed
 */
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

/**
 * @brief helper function to access ASTNode children
 * @return returns all children nodes from an ASTNode in the form of a list of AST pointers.
 */
list<ASTNode *> ASTNode::getChildren() {
    return childrenNodes;
}

/**
 * @brief copies AST generated by parser into a tree form tree.hh
 * @param root is the root of the parser AST tree
 * @param ast is the tree.hh tree
 */
void ASTNode::copyTree(ASTNode *&root, tree<ASTNode *> &ast) {
    //Make sure the ast is clear
    ast.clear();
    //first insert the top
    auto firstNode = ast.insert(ast.begin(), root);
    //now add the children
    copyTreeHelper(root, ast, firstNode);

}

/**
 * @brief function to get set types from ASTNode. Should not be used for base class
 * @return returns an empty set that is sad
 */
set<int> ASTNode::getTypes() {
    cout << "IF YOU'RE SEEING THIS DIE" << endl;
    set<int> fail;
    return fail;
}

int ASTNode::getDimensions() {
    //cout << "IF YOU'RE SEEING THIS MEEEWOA" << endl;
    //things like int const, float const, should all be 0
    return 0;
}

/**
 * @brief function to get name from ASTNode. Should not be used for base class
 * @return returns a null pointer
 */
string ASTNode::getName() {
    cout << "IF YOURE SEEING THIS RIP" << endl;
    return nullptr;
}

/**
 * @brief function to get sizes from ASTNode. Should not be used for base class
 * @return returns an empty ASTNode pointer list
 */
list<ASTNode*> ASTNode::getSizes() {
    list<ASTNode*> empty;
    return empty;
}

/**
 * @brief function to set SymbolTableNode in an ASTNode. Should not be used for base class
 * @param symtblnd2 is the symbol table node to be inserted
 */
void ASTNode::setSymbolNode(SymbolTableNode2* symtblnd2) {
    cout << "IF YOURE SEEING THIS RAVIOLI" << endl;
}

/**
 * @brief extraction operator overload to print ASTNode to a stream
 * @param os is the stream to be used
 * @param node is the ASTNode to be printed
 * @return returns the stream
 */
std::ostream &operator<<(std::ostream &os, const ASTNode &node) {
    node.printNode(os);
    return os;
}

/**
 * @brief returns a number based on the first data type found in the set
 * @param typeSet is the set to be searched
 * @return returns a number. The number is larger for longer data types
 */
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

/**
 * @brief function to compare two sets for cast
 * @param left is one of the sets to be compared
 * @param right is the other set to be compared
 * @return returns the value of computing type order of left - right.
 *         if returned value is >0, then right side needs to be cast.
 *         if returned value is <0, then left side needs to be cast.
 */
int compareForCast(set<int> &left, set<int> &right) {

    int leftSize = computeTypeOrder(left);
    int rightSize = computeTypeOrder(right);
    return leftSize - rightSize;

}

/**
 * @brief function to print base ASTNode.
 * @param os stream to be printed to
 */
void ASTNode::printNode(std::ostream &os) const {
    os << "NOT_PROGRAMMED";
}

/**
 * @brief helper function to copy AST into a tree.hh tree
 * @param src_node is the root node of the AST generated by parser
 * @param ast is the tree.hh tree to be copied to
 * @param iRoot is the iterator to iterate through the children
 */
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

/**
 * @brief default constructor for ASTNode
 */
ASTNode::ASTNode() {
}

/**
 * @brief default constructor for TypeNode
 */
TypeNode::TypeNode() {
    //default- MUST set type in derived constructor
}

/**
 * @brief TypeNode constructor with a set of types
 * @param type is the set of types
 */
TypeNode::TypeNode(set<int> &type) {
    types = type;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

set<int> TypeNode::getTypes() {
    return types;
}

/**
 * @brief print function for TypeNode that checks type with tokenToString2
 * @param os is the stream to be printed to
 */
void TypeNode::printNode(std::ostream &os) const {
    os << "TYPE_";
    for (int i : types) {
        os << tokenToString2(i);
    }
}

/**
 * @brief WhileNode constructor. Makes a temporary list of the
 *        children ASTNodes and sets childrenNodes equal to it.
 * @param expr is the while loop expression to be checked
 * @param stmt is the body of the while loop
 * @param dooo is a bool denoting whether this is a while or do-while loop
 */
WhileNode::WhileNode(ASTNode *expr, ASTNode *stmt, bool dooo) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    childrenNodes = tempList;
    doo = dooo;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for WhileNode, checks if it is a while or a do-while loop.
 * @param os is the stream to be printed to
 */
void WhileNode::printNode(std::ostream &os) const {
    if(doo){
        os << "DO_WHILE";
    }
    else{
        os << "WHILE";
    }
}

/**
 * @brief IfNode constructor for if statement.
 *        Creates a temporary list of child nodes and sets childrenNodes equal to it.
 * @param expr is the expression to be checked
 * @param stmt is the body of the if statement
 */
IfNode::IfNode(ASTNode *expr, ASTNode *stmt) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    childrenNodes = tempList;
    flag = 1;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief IfNode constructor for if-else statement
 *        Creates a temporary list of child nodes and sets childrenNodes equal to it.
 * @param expr is the expression to be checked
 * @param stmt is the body of the if statement
 * @param stmt2 is the body of the else statement
 */
IfNode::IfNode(ASTNode *expr, ASTNode *stmt, ASTNode *stmt2) {
    list<ASTNode*> tempList;
    tempList.push_back(expr);
    tempList.push_back(stmt);
    tempList.push_back(stmt2);
    childrenNodes = tempList;
    flag = 0;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for IfNode. Checks if it is an if statement or an if-else statement.
 * @param os is the stream to be printed to
 */
void IfNode::printNode(std::ostream &os) const {
    if(flag){
        os << "IF_NODE";
    }
    else{
        os << "IF_ELSE_NODE";
    }
}

/**
 * @brief UnaryNode constructor. Creates a temporary list of children.
 * @param x is the unary operator that nodeType is set to.
 * @param child is the child of the UnaryNode
 */
UnaryNode::UnaryNode(int x, ASTNode *child) {
    list <ASTNode*> tempList;
    tempList.push_back(child);
    nodeType = x;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for unary node
 * @param os is the stream to be printed to
 */
void UnaryNode::printNode(std::ostream &os) const {
    os << "UNARY_" << tokenToString2(nodeType);
}

/**
 * @brief Bitwise Node constructor
 * @details uses compareForCast to check if either child needs to be cast.
 *          If needed, creates a CastNode accordingly.
 *          makes a temporary list of the children and sets childrenNodes equal to it.
 * @param x is the bitwise operation
 * @param left is the left child of the operator
 * @param right is the right child of the operator
 */
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

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief LogicalNode constructor. Creates a temporary list of child nodes
 * @param x is the type of logical operator that nodeType is set to.
 * @param left is the left child of the operator
 * @param right is the right child of the operator
 */
LogicalNode::LogicalNode(int x, ASTNode *left, ASTNode *right) {
    list <ASTNode*> tempList;
    tempList.push_back(left);
    tempList.push_back(right);
    childrenNodes = tempList;
    nodeType = x;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for logicalNode
 * @param os is the stream to be printed to
 */
void LogicalNode::printNode(std::ostream &os) const {
    os << "LOGICAL_" << nodeType;
}

/**
 * @brief AssignNode constructor. Makes a types set based on the lval and a temporary list of child nodes.
 * @param lvalue is the lval of the assignment expression
 * @param rvalue is the rval of the assignment expression
 */
AssignNode::AssignNode(ASTNode *lvalue, ASTNode *rvalue) {
    list <ASTNode*> tmplist;

    int leftArrDims = lvalue->getDimensions();
    int rightArrDims = rvalue->getDimensions();

    //Check for type mismatch (arrays)
    if (leftArrDims != rightArrDims) {
        outputError("Semantic Error", "Mismatch of types in Array assignment", false);
    }

    set<int> leftSet = lvalue->getTypes();
    types = leftSet;

    tmplist.push_back(lvalue);
    tmplist.push_back(rvalue);
    childrenNodes = tmplist;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for AssignNodes
 * @param os is the stream to be printed to
 */
void AssignNode::printNode(std::ostream &os) const {
    os << "ASSIGN";
}

/**
 * @brief NoneNode constructor
 */
NoneNode::NoneNode() {
}

/**
 * @brief NoneNode prints none
 * @param os is the stream to be printed to
 */
void NoneNode::printNode(std::ostream &os) const {
    os << "NONE";
}

/**
 * @brief DeclNode constructor. Creates a temp list of children
 * @param first is the first child node
 * @param second is the second child node
 */
DeclNode::DeclNode(ASTNode *first, ASTNode *second) {
    list<ASTNode*> tmpList;
    tmpList.push_back(first);
    tmpList.push_back(second);
    childrenNodes = tmpList;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print DeclNode
 * @param os is the stream to be printed to
 */
void DeclNode::printNode(std::ostream &os) const {
    os << "DECLARATION";
}

/**
 * @brief SeqNode constructor. Creates a temp list of children
 * @param seq is the type of SeqNode
 * @param first is the first child
 * @param second is the second chile
 */
SeqNode::SeqNode(char seq, ASTNode *first, ASTNode *second) {
    list<ASTNode*> tmpList;
    tmpList.push_back(first);
    tmpList.push_back(second);
    childrenNodes = tmpList;

    seqType = seq;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief SeqNode print function. prints a string based on what kind of seqnode it is
 * @param os is the stream to be printed to
 */
void SeqNode::printNode(std::ostream &os) const {
    switch(seqType) {
        case 's':
            os << "STATEMENTS";
            break;
        case 'd':
            os << "DECLARATIONS";
            break;
        case 'c':
            os << "COMPOUND";
            break;
        case 'a':
            os << "ARGUMENTS";
            break;
        case 'g':
            os << "GLOBAL";
            break;
        case 'f':
            os << "FUNCTION"; //todo this should be deleted once there's a proper function node
            break;
        case 't':
            os << "STRUCT_LIST";
            break;
        case 'q':
            os << "INIT_DECL_LIST";
            break;
        case 'e':
            os << "ENUM_LIST";
            break;
        case 'i':
            os << "IDENTIFIER_LIST";
            break;
        default:
            os << "UNDEFINED_SEQUENCE";
            break;
    }
}

/**
 * @brief SeqNode constructor
 * @param seq is the type of seqNode
 * @param statementList is the list of ASTNode pointers
 */
SeqNode::SeqNode(char seq, list<ASTNode *> statementList) {
    childrenNodes = statementList;

    seqType = seq;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief IDNode constructor
 * @param name is the name of the identifier
 */
IdentifierNode::IdentifierNode(string *name) {
    identifier = *name;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

int IdentifierNode::getDimensions() {
    return sizeList.size();
}

/**
 * @brief IDNode function to get the identifier name
 * @return returns a string that is the identifier name
 */
string IdentifierNode::getName() {
    return identifier;
}

/**
 * @brief sets symbol table node from an identifier node. copies types and size set
 * @param symtblnd2 is the symboltablenode to be set
 */
void IdentifierNode::setSymbolNode(SymbolTableNode2* symtblnd2) {
    symbolTableNode2 = symtblnd2;
    types = symbolTableNode2->types;
    sizeList = symbolTableNode2->sizeList;
    //cout << sizeList.size();
}

/**
 * @brief Identifier node print function
 * @param os is the stream to be printed to
 */
void IdentifierNode::printNode(std::ostream &os) const {
    os << "VARIABLE_" << identifier;
    for (auto item : types) {
        os << "_" << tokenToString2(item);
    }
    int dimensions = sizeList.size();
    if (dimensions > 0) {
        os << "_ARR_";
        int i = 1;
        for (auto dim_size : symbolTableNode2->sizeList) {
            os << "DIM" << i << "_" << dim_size;
            i++;
        }
    }
}

IdentifierNode::~IdentifierNode() {
    delete symbolTableNode2;
}

/**
 * @brief print function for IntNode
 * @param os is the stream to be printed to
 */
void IntNode::printNode(std::ostream &os) const {
    os << "INT_" << nodeVal;
}

/**
 * @brief IntNode constructor. inserts type INT into set of types.
 * @param val is the value of the integer
 */
IntNode::IntNode(int val) {
    nodeVal = val;
    types.insert(INT);

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief CharNode constructor. inserts type CHAR into set of types.
 * @param val is the value of the char
 */
CharNode::CharNode(char val) {
    types.insert(CHAR);
    nodeVal = val;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for charnode that prints the value of the char
 * @param os is the stream to be printed to
 */
void CharNode::printNode(std::ostream &os) const {
    os << "CHAR_" << nodeVal;
}

/**
 * @brief FloatNode constructor. inserts type FLOAT into set of types.
 * @param val is the value of the float.
 */
FloatNode::FloatNode(float val) {
    types.insert(FLOAT);
    nodeVal = val;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief printer function for floatNode
 * @param os is the stream to be printed to
 */
void FloatNode::printNode(std::ostream &os) const {
    os << "FLOAT_" << nodeVal;
}

/**
 * @brief StringNode constructor
 * @param val is the string to be copied into nodeVal
 */
StringNode::StringNode(string *val) {
    nodeVal = *val;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for StringNode
 * @param os is the stream to be printed to
 */
void StringNode::printNode(std::ostream &os) const {
    os << "STRING_" << nodeVal;
}

/**
 * @brief CastNode constructor. Creates a temporary list of child nodes
 * @param type is the type that the right child should be cast to
 * @param nodeToCast is the node that should be cast to a different type
 */
CastNode::CastNode(ASTNode *type, ASTNode *nodeToCast) {
    list<ASTNode *> tmplist;
    tmplist.push_back(type);
    tmplist.push_back(nodeToCast);
    childrenNodes = tmplist;
    types = type->getTypes();

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for castNode
 * @param os is the stream to be printed to
 */
void CastNode::printNode(std::ostream &os) const {
    os << "CAST";
}

/**
 * @brief RelationalNode constructor. creates a temporary list of child nodes
 * @param type is the type of relational operator
 * @param left is the left child
 * @param right is the right child
 */
RelationalNode::RelationalNode(int type, ASTNode *left, ASTNode *right) {
    operationType = type;
    list<ASTNode*> tmplist;
    tmplist.push_back(left);
    tmplist.push_back(right);
    childrenNodes = tmplist;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for relationalNode
 * @param os is the stream to be printed to
 */
void RelationalNode::printNode(std::ostream &os) const {
    os << "RELATIONAL_" << tokenToString2(operationType);
}

/**
 * @brief BinaryMathNode constructor. Creates a temporary list of child nodes
 *        Checks if a node needs to be cast. If it does, creates a cast node accordingly.
 * @param type is the type of binary math operator
 * @param left is the left child
 * @param right is the right child
 */
BinaryMathNode::BinaryMathNode(int type, ASTNode *left, ASTNode *right) {
    operationType = type;
    list<ASTNode*> tmplist;

    ASTNode * newLeft;
    ASTNode * newRight;

    set<int> leftSet = left->getTypes();
    int leftArrDims = left->getDimensions();
    set<int> rightSet = right->getTypes();
    int rightArrDims = right->getDimensions();

    //Check for type mismatch (arrays)
    if (leftArrDims != rightArrDims) {
        outputError("Semantic Error", "Mismatch of types in Array operation", false);
    }

    //Implicit casting
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

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief binaryMathNode print function
 * @param os is the stream to be printed to
 */
void BinaryMathNode::printNode(std::ostream &os) const {
    os << "OPERATION_" << tokenToString2(operationType);
    for (auto item : types) {
        os << "_" << tokenToString2(item);
    }
}

/**
 * @brief ReturnNode constructor. Checks if return is null and creates a corresponding temporary child node list
 * @param child is the child ASTNode pointer
 */
ReturnNode::ReturnNode(ASTNode *child) {
    if (child == NULL) {
        list<ASTNode*> emptyList;
        childrenNodes = emptyList;
    } else {
        list<ASTNode*> tmp;
        tmp.push_back(child);
        childrenNodes = tmp;
    }

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
}

/**
 * @brief print function for returnNode
 * @param os is the stream to be printed to
 */
void ReturnNode::printNode(std::ostream &os) const {
    os << "RETURN";
}

/**
 * @brief ArrayNode constructor creates a templist with the identifier and the dimensions
 * @param var is the identifier along with the type
 * @param sizes is the dimensions of the array
 */
ArrayNode::ArrayNode(ASTNode *var, list<ASTNode *> sizes) {
    list<ASTNode*> tmplist;
    tmplist = sizes;
    tmplist.push_front(var);
    sizeList = sizes;
    childrenNodes = tmplist;

    lineNum = yylineno;
    colNum = columnQueue.size() - yyleng + 1;
    types = var->getTypes();
}

int ArrayNode::getDimensions() {
    int arrSize = getChildren().front()->getDimensions();
    int derefs = sizeList.size();
    return arrSize - derefs;
}

/**
 * @brief function to get dimensions of an arrayNode
 * @return list of ASTNode pointers that are the dimensions
 */
list<ASTNode*> ArrayNode::getSizes() {
    return sizeList;
}

/**
 * @brief print function for arrayNode
 * @param os is the stream to be printed to
 */
void ArrayNode::printNode(std::ostream &os) const {
    os << "ARRAY"; //todo maybe provide more info about the array?
}

/**
 * @brief FuncNode constructor. Uses a switch statement to construct appropriate member fields.
 *        If function prototype, sets name and param types.
 *        If function definition, sets name, return type, name and type of parameters, and children nodes (what is inside curly braces)
 *        Additionally makes a TypeNode as a child denoting return type.
 *        If function call, sets given arguments as children nodes.
 * @param name is the function name
 * @param type
 * @param params
 */
 //todo finish function calls
FuncNode::FuncNode(string name, list<set<int>> types, list<ASTNode*> children, list<pair<string, set<int>>> arguments, int type)
{
    funcName = name;
    funcType = type;
    switch(type)
    {
        case 0: {
            paramTypes = types;
            break;
        }
        case 1: {
            paramTypes = types;
            args = arguments;
            childrenNodes = children;
            auto tempIt = types.begin();
            childrenNodes.push_front(new TypeNode(*tempIt));
            break;
        }
        case 2: {
            childrenNodes = children;
            break;
        }
        default:
            break;
    }
}

/**
 * @brief function to print funcnodes. Uses a switch statement to print different types of funcnodes.
 *        If function prototype, prints name and param types.
 *        If function definition, prints name and param names and types.
 *        If function call, prints name and args if they are given.
 * @param os is the stream to be printed to
 */
void FuncNode:: printNode(std::ostream &os) const{
     switch(funcType)
     {
         case 0: {
             os << "FUNCTION_PROTOTYPE_" << funcName;
             for(auto it = paramTypes.begin(); it != paramTypes.end(); ++it)
             {
                 os << "_";
                 for(auto ite = it->begin(); ite != it->end(); ++ite)
                     os << *ite;
             }
             break;
         }
         case 1: {
             os << "FUNCTION_DEFINITION_" << funcName;
             for(auto it = args.begin(); it != args.end(); ++it)
             {
                 os << "_";
                 os << it->first << "_";
                 for(auto ite = it->second.begin(); ite != it->second.end(); ++ite)
                    os << *ite;
             }
             break;
         }
         case 2: {
             os << "FUNCTION_CALL_" << funcName;
             break;
         }
         default:
             break;
     }
}

/**
 * @brief function that returns the name of a funcnode
 *
 */
string FuncNode:: getName(){
    return funcName;
}

/**
 * @brief ForNode constructor. Stores a ASTNode* list of the expressions and an bool array
 *        with values corresponding to which expressions are written
 * @param ptrList is the list of expressions
 * @param arr is the bool array denoting which expressions are written
 * @param stmt is the statement or the body of the loop
 */
ForNode::ForNode(list<ASTNode *> ptrList, bool *arr, ASTNode * stmt) {
    childrenNodes = ptrList;
    childrenNodes.push_back(stmt);
    for(int i = 0; i < 3; ++i)
        stmtWritten[i] = arr[i];
}

void ForNode::printNode(std::ostream &os) const{
    os << "FOR";
}