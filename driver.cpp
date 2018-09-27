//
// Created by Derek Stratton on 9/23/2018.
//

#include <iostream>

#include "SymbolTable.h"

using namespace std;

int main() {
    try {
        SymbolTable s; //Empty symbol table
        s.printTable();
        pair<string, int> item = make_pair("Hello", 4);
        pair<string, int> item2 = make_pair("Hey", 7);
        s.pushLevel();
        s.printTable();

        s.insert(item);
        s.printTable();
        s.pushLevel();
        s.insert(item2);
        s.printTable();

        s.pushLevel();
        s.popLevel();

        cout << "Key for Hello: " << s.search("Hello") << endl;
        cout << "Key for Hey: " << s.search("Hey") << endl;

        s.search("Hi"); //this key doesn't exist, and will throw an error.
        cout << "done";
    } catch (const char * msg) {
        cout << "ERROR: " << msg << endl;
        return -1;
    }

    return 0;
}