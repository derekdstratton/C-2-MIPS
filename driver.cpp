//
// Created by Derek Stratton on 9/23/2018.
//

#include <iostream>

#include "SymbolTable.h"

using namespace std;

int main() {
    SymbolTable s; //Empty symbol table
    s.printTable();
    pair<string, int> item = make_pair("Hello", 4);
    //s.insert(item);
    s.pushLevel();
    s.printTable();

    s.insert(item);
    s.printTable();
    cout << "done";

    return 0;
}