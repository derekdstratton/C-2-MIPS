#include <iostream>
#include <fstream>

#include "ASTNodes.h"
#include "include/tree.hh"
#include "astnodetype.h"

using namespace std;

list<string> operands;

list<vector<string>> code;

int registerCnt = 0;
int labelCnt = 0;

int localFrame = 0; //stores all the local variables

/** decodes the size in bytes */
int decodeSize(set<int> &typeSet) {
    if (typeSet.count(CHAR) == 1) {
        return 1;
    }
    if (typeSet.count(SHORT) == 1) {
        return 2;
    }
    if (typeSet.count(INT) == 1 && typeSet.count(UNSIGNED) == 1) {
        return 4;
    }
    if (typeSet.count(INT) == 1) {
        return 4;
    }
    if (typeSet.count(LONG) == 1) {
        return 8;
    }
    if (typeSet.count(FLOAT) == 1) {
        return 4;
    }
    if (typeSet.count(DOUBLE) == 1) {
        return 8;
    }
    cout << "SHOULDNT BE HERE, TYPE NOT FOUND MAYDAY MAYDAY";
    return -1;
}

void makeCode(tree<ASTNode*>::post_order_iterator it, tree<ASTNode*>::post_order_iterator end) {
    while (it != end) {
        int nodeType = (*it)->getNodeType();
        int numChildren = (*it)->getChildren().size();

        switch(nodeType) {
            //Instruction and Operand Nodes
            case ASSIGNNODE: {
                cout << "ASSIGN DEBUGGING" << endl;
                for (auto x : operands) {
                    cout << x << " ";
                }
                cout << endl;
                vector<string> a (4);
                a[0] = "ASSIGN";
                auto op = operands.begin();
                for (int i = numChildren - 1; i >= 0; i--) {
                    a[i+1] = (*op);
                    auto prev = op;
                    op++;
                    operands.erase(prev);
                }
                operands.push_front(a[1]);
                code.push_back(a);
                cout << "ASSIGN" << endl;
                break;
            }
            case BINARYMATHNODE: {
                cout << "PLUS DEBUGGING" << endl;
                for (auto x : operands) {
                    cout << x << " ";
                }
                cout << endl;
                vector<string> a (4);
                string s = tokenToString2((*it)->getOpType());
                a[0] = (s);
                auto op = operands.begin();
                for (int i = numChildren - 1; i >= 0; i--) {
                    a[i+2] = (*op);
                    auto prev = op;
                    op++;
                    operands.erase(prev);
                }
                a[1] = ("t" + to_string(registerCnt++)); //temporary register
                cout << s << endl;
                code.push_back(a);
                operands.push_front(a[1]);
                break;
            }
            case RELATIONALNODE: {
                cout << "PLUS DEBUGGING" << endl;
                for (auto x : operands) {
                    cout << x << " ";
                }
                cout << endl;
                vector<string> a (4);
                string s = tokenToString2((*it)->getOpType());
                a[0] = (s);
                auto op = operands.begin();
                for (int i = numChildren - 1; i >= 0; i--) {
                    a[i+2] = (*op);
                    auto prev = op;
                    op++;
                    operands.erase(prev);
                }
                a[1] = ("t" + to_string(registerCnt++)); //temporary register
                cout << s << endl;
                code.push_back(a);
                operands.push_front(a[1]);
                break;
            }
            //Operand Only Nodes
            case IDENTIFIERNODE: {
                string s = (*it)->getName();
                operands.push_front(s);
                cout << s << endl;
                break;
            }
            case INTNODE: {
                string s = to_string((*it)->getVal());
                operands.push_front(s);
                cout << s << endl;
                break;
            }
            //Special Nodes
            case IFNODE: {
                cout << "IF" << endl;
                break;
            }
            case SEQNODE:
                cout << "SeqNode" << *it;
                break;
            default: {
                cout << "Other Node" << endl;
                break;
            }
        }
        it++;
    }
}

void generate3ac(const tree<ASTNode*>& ast) {
    ASTNode node;
    tree<ASTNode*>::post_order_iterator it = ast.begin_post();

    makeCode(it, ast.end_post());

    for (auto x : operands) {
        cout << x << " ";
    }
    cout << endl;

    cout << "===========================" << endl;

    for (const auto &x : code) {
        for (const auto &y : x) {
            cout << y << " ";
        }
        cout << "Size: " << x.size();
        cout << endl;
    }

    std::ofstream code2;
    code2.open("3ac_data.txt", ofstream::out | ofstream::trunc);
    code2.close();
}