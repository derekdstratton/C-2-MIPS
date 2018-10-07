//
// Created by Derek Stratton on 9/23/2018.
//

#include <iostream>

#include "SymbolTable.h"
#include "Node.h"

using namespace std;

int main() {
    SymbolTable s; //Empty symbol table
    cout << s;
    pair<string, Node> item = make_pair("Hello", Node(4));
    pair<string, Node> item2 = make_pair("Hey", Node(7));
    s.pushLevel();
    cout << s;

    s.insert(item);
    cout << s;
    //s.printTable();
    s.pushLevel();
    s.insert(item2);
    cout << s;

    //todo write to file

    s.pushLevel();
    s.popLevel();

    cout << "Key for Hello: " << get<0>(s.search("Hello"))->second << get<1>(s.search("Hello")) << endl;
    cout << "Key for Hey: " << get<0>(s.search("Hey"))->second << get<1>(s.search("Hey")) << endl;

    cout << "This doesn't exist, says not: " << get<1>(s.search("Hoolu")) << endl;
    cout << "done";

    return 0;
}