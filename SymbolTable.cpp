//
// Created by Derek Stratton on 9/24/2018.
// Barfed on by Natalie Arnold on 9/25/2018.
//
#include <iostream>
#include "SymbolTable.h"

using namespace std;

//Default Constructor
SymbolTable::SymbolTable() = default;

//Symbol Table insert
//Purpose:  Inserts new pair onto the top BST on the stack.
//          If a pair with the same key already exists,
//          the symbol already exists in the current scope.
void SymbolTable::insert(const pair<string, int>& item) {
    auto ret = table.front().insert(item);
    if (ret.second == false) {
        //this will be false if an existing key exists
        //todo should it replace? notify the caller? idk
        throw ("DUPLICATE KEY S O S");
    }
}

//Symbol Table search
//Purpose:  Searches the entire symbol table for a key from
//          top of the stack down. Should we be returning
//          a pointer to the location or the structure
//          containing the data?
int SymbolTable::search(const string &key) {
    auto stack_ptr = table.begin();
    bool found = false;
    auto value_iterator = stack_ptr->find(key);
    while (stack_ptr != table.end() && !found){
        value_iterator = stack_ptr->find(key);
        if (value_iterator != stack_ptr->end()) {
            found = true;
        }
        stack_ptr++;
    }
    if (!found) {
        throw ("SEARCH FAIL MAYDAY MAAAAAAYDAY");
    }

    return value_iterator->second;
}

//Symbol Table writeToFile
//Purpose:  To be used for debugging. Should we consider having two
//          functions? One that writes only the current map on top
//          of the stack to a file and one that writes the entire table?
void SymbolTable::writeToFile(const string &filepath) {
    //todo think of a format for the file
    /*
     * Level (top)
     * Key: {content1, content2, content3}
     * Key2: {content1, content2, content3}
     * Level
     */
}

//Symbol Table pushLevel
//Purpose:  When a new procedure is entered, a new map is pushed onto
//          the stack to store local variable data.
void SymbolTable::pushLevel() {
    map<string, int> newMap;
    table.push_front(newMap);
}

//Symbol Table popLevel
//Purpose:  When the procedure finishes, the top  map on the stack gets
//          popped.
void SymbolTable::popLevel() {
    table.pop_front();
}

void SymbolTable::printTable() {
    cout << "Symbol Table:" << endl << "Stack size: " << table.size() << endl;
    cout << "Maps: (Level 0 top of stack)" << endl;
    int i = 0;
    for (auto& map : table) {
        cout << "Map at level " << i << " (size: " << map.size() << ")" << endl;
        for (auto& mappair : map) {
            cout << "Key: " << mappair.first << ", Value: " << mappair.second << endl;
        }
        i++;
    }
    cout << endl;
}