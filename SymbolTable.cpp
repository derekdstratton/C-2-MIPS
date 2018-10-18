/**
 *
 */
#include <iostream>
#include <fstream>
#include <tuple>
#include "SymbolTable.h"

using namespace std;

/**
 * Default Constructor. Pushes a level initially.
 */
SymbolTable::SymbolTable() {
    this->pushLevel();
    insertMode = true; //start for inserting in global scope
}

/** Insert an item into symbol table
 *
 * change return value to a tuple
 *
 * @param item The item being inserted into the Symbol Table
 * @return First bool: true if successfully inserted, false otherwise.
 *      Second bool: True if no error/warning, False if shadowing
 */
tuple<bool, bool> SymbolTable::insert(const pair<string, Node>& item) {

    tuple<map<string, Node>::iterator, string> tup = this->search(item.first);
    string retval = get<1>(tup);
    if (retval == "top") {
        //cout << "error already defined" << endl;
        return make_tuple(false, false);
    } else if (retval == "other") {
        //cout << "warning for shadowing" << endl;
        return make_tuple(true, false);
    }

    table.front().insert(item);
    return make_tuple(true, true);
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
 * @return Returns true if the level is successfully popped, false otherwise.
 */
bool SymbolTable::popLevel() {
    if (table.size() == 1) {
        //cout << "popping the final level is bad, not gonna do it" << endl;
        return false;
    }
    table.pop_front();
    return true;
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
    return os;
}

/**
 *
 * @param newMode
 */
void SymbolTable::setMode(const bool& newMode) {
    insertMode = newMode;
}

/**
 *
 * @return
 */
bool SymbolTable::getMode() {
    return insertMode;
}
