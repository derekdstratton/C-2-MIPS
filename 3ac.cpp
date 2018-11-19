#include <iostream>
#include <fstream>

#include "ASTNodes.h"
#include "include/tree.hh"
#include "astnodetype.h"

using namespace std;

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

void generate3ac(const tree<ASTNode*>& ast) {
    std::ofstream code;
    code.open("3ac_data.txt", ofstream::out | ofstream::trunc);

    int nodeType;
    ASTNode node;
    tree<ASTNode*>::pre_order_iterator it = ast.begin();

    int localFrame = 0; //stores all the local variables

    while (it != ast.end()) {
        node = **it;
        nodeType = node.getNodeType();

        switch(nodeType) {
            default:
                cout << "Other Node" << endl;
        }
        it++;
    }

    code.close();
}