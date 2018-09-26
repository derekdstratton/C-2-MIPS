//
// Created by Derek Stratton on 9/24/2018.
// Barfed on by Natalie Arnold on 9/25/2018.
//
#include <iostream>
#include "SymbolTable.h"

using namespace std;

//Default Constructor
SymbolTable::SymbolTable() {

}

//Symbol Table insert
//Purpose:  Inserts new pair onto the top BST on the stack.
//          If a pair with the same key already exists,
//          the symbol already exists in the current scope.
void SymbolTable::insert(const pair<string, int> item) {
    table.back().insert(item);
}

//Symbol Table search
//Purpose:  Searches the entire symbol table for a key from
//          top of the stack down. Should we be returning
//          a pointer to the location or the structure
//          containing the data?
int SymbolTable::search(const string key) {
    //todo
    return 0;
}

//Symbol Table writeToFile
//Purpose:  To be used for debugging. Should we consider having two
//          functions? One that writes only the current map on top
//          of the stack to a file and one that writes the entire table?
void SymbolTable::writeToFile() {
    //todo
}

//Symbol Table pushLevel
//Purpose:  When a new procedure is entered, a new map is pushed onto
//          the stack to store local variable data.
void SymbolTable::pushLevel() {
    map<string, int> newMap;
    table.push_back(newMap);
}

//Symbol Table popLevel
//Purpose:  When the procedure finishes, the top  map on the stack gets
//          popped.
void SymbolTable::popLevel() {
    table.pop_back();
}

void SymbolTable::printTable() {
    cout << "Symbol Table:" << endl << "Stack size: " << table.size() << endl;
    cout << "Maps: " << endl;
    int i = 0;
    for (auto& map : table) {
        cout << "Map at level " << i << " size: " << map.size() << endl;
        i++;
    }
    cout << endl;
}