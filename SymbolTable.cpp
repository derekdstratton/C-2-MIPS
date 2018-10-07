#include <iostream>
#include <fstream>
#include <tuple>
#include "SymbolTable.h"

using namespace std;

/**
 * Default Constructor
 */
SymbolTable::SymbolTable() = default;

/** Insert an item into symbol table
 *
 * @param item The item being inserted into the Symbol Table
 * @return True if the item inserted is shadowing another item, false otherwise
 */
bool SymbolTable::insert(const pair<string, Node>& item) {
    auto ret = table.front().insert(item);
    return ret.second == false;
    //todo to test if shadowing, you have to go thru all the scopes to the global
    //todo if it already exists in the top scope, that should be an error
}

/** Search for an item in the symbol table
 *
 * @param key A string of the identifier being searched for
 *
 * @param topLevelOnly An optional argument that will only search the top level if true. Default false.
 *
 * @return A tuple with two parts:
 *      First: a map pointer to the found node, or NULL if not found
 *      Second: a string indicating the status of if it is found, as such:
 *          "top"- found at the top level
 *          "other"- found at a level other than the top
 *          "not"- not found at all
 */
tuple<map<string, Node>::iterator, string> SymbolTable::search(const string &key, bool topLevelOnly) {
    //todo make sure to do error/bounds checking
    map<string, Node>::iterator node_iterator;
    string status;
    bool found = false;

    //top level search
    auto topMap = table.front();
    node_iterator = topMap.find(key);
    if (node_iterator != topMap.end()) {
        //found
        status="top";
        found = true;
    }
    else {
        //not found
        status="not";
    }

    //full search
    if (!topLevelOnly && !found) {
        auto stack_ptr = table.begin()++; //points to the second level

        while (stack_ptr != table.end() && !found){
            node_iterator = stack_ptr->find(key);
            if (node_iterator != stack_ptr->end()) {
                found = true;
            }
            stack_ptr++;
        }
        if (found) {
            //found
            status="other";
        } else {
            //not found
            status="not";
        }
    }

    return make_tuple(node_iterator, status);
}

/**
 * Pushes a new level on the stack
 */
void SymbolTable::pushLevel() {
    map<string, Node> newMap;
    table.push_front(newMap);
}

/**
 * Pops the top level from the stack
 */
void SymbolTable::popLevel() {
    table.pop_front();
}

/**
 *
 * @param os
 * @param symbolTable
 * @return
 */
ostream& operator<<(ostream& os, const SymbolTable& symbolTable) {
    os << "Symbol Table: (Stack size: " << symbolTable.table.size() << ")" << endl;
    os << "Maps (From top to bottom):" << endl;
    int i = 0;
    for (auto& map : symbolTable.table) {
        os << "\t" << "Map at level " << i << " (size: " << map.size() << ")" << endl;
        for (auto& mappair : map) {
            os << "\t\t" << "Key: " << mappair.first << ", Value: " << mappair.second << endl;
        }
        i++;
    }
    cout << endl;
    return os;
}