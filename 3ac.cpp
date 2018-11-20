#include <iostream>
#include <fstream>

#include "ASTNodes.h"
#include "include/tree.hh"
#include "astnodetype.h"

using namespace std;

list<vector<string>> code;
list<vector<string>>::iterator codeIt;
list<vector<string>> instrStack;

int registerCnt = 0;
int labelCnt = 0;

ASTNode * importantNode;

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
void insertOperandNode(const string &s) {
    if (!instrStack.empty()) {
        instrStack.back().push_back(s);
        if (instrStack.back().size() == 4) {
            //Generate 3 Address Code
            auto item = instrStack.back();
            //code.push_back(item); use iterator instead
            if (codeIt != code.end()) {
                codeIt++;
            }
            code.insert(codeIt, item);
            //Pop it off the instruction stack if we're full
            instrStack.pop_back();

            if (!instrStack.empty()) {
                //chain it into the last one
                auto otherItem = instrStack.back();
                //get the destination
                otherItem.push_back(item[1]);
                //todo this is a temporary solution but along the ideas of what you want
                //if the size is 4, only then do you push back? that's my thought
                cout << otherItem[1];
                //code.push_back(otherItem); use iterator instead
                if (codeIt != code.end()) {
                    codeIt++;
                }
                code.insert(codeIt, otherItem);
                instrStack.pop_back();
            }
        }
    }
}

void makeCode(tree<ASTNode*>::pre_order_iterator it, tree<ASTNode*>::pre_order_iterator end) {
    while (it != end) {
        int nodeType = (*it)->getNodeType();

        //cout << *it;
        if (*it == importantNode) {
            cout << "WOOO THIS MIGHT WORK FOR MMAKING LABELS";
        }

        switch(nodeType) {
            case ASSIGNNODE: {
                vector<string> a;
                a.push_back("ASSIGN");
                a.push_back("---");
                instrStack.push_back(a);
                cout << "ASSIGN" << endl;
                break;
            }
            case BINARYMATHNODE: {
                vector<string> a;
                string s = tokenToString2((*it)->getOpType());
                a.push_back(s);
                a.push_back("t" + to_string(registerCnt++)); //temporary register
                instrStack.push_back(a);
                cout << s << endl;
                break;
            }
            case IDENTIFIERNODE: {
                string s = (*it)->getName();
                cout << s << endl;
                insertOperandNode(s);
                break;
            }
            case INTNODE: {
                string s = to_string((*it)->getVal());
                cout << s << endl;
                //todo generate into a function
                insertOperandNode(s);
                break;
            }
            case RELATIONALNODE: {
                vector<string> a;
                string s = tokenToString2((*it)->getOpType());
                a.push_back(s);
                a.push_back("t" + to_string(registerCnt++)); //temporary register
                instrStack.push_back(a);
                cout << s << endl;
                break;
            }
            case IFNODE: {
                vector<string> a;
                a.push_back("BREQ");
                string label = "lab" + to_string(labelCnt++);
                a.push_back(label);
                a.push_back("0");
                instrStack.push_back(a);

                auto statementsIt = it;
                statementsIt.skip_children();
                statementsIt++;
                importantNode = *statementsIt;
                cout << "Important Node" << importantNode;
                statementsIt--;
                cout << "This node 1: " << *statementsIt;
                cout << "This node 2: " << *it;
/*
                //put the label in and then take a step back
                vector<string> b {label, "---", "---", "---"};
                if (codeIt != code.end()) {
                    codeIt++;
                }
                code.insert(codeIt, b);
                codeIt--;*/
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
    tree<ASTNode*>::pre_order_iterator it = ast.begin();

    codeIt = code.begin();

    makeCode(it, ast.end());

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