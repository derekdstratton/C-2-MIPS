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
}

/** Insert an item into symbol table
 * todo determine what to do about shadowing. return info that the parser can output errors/warnings
 * change return value to a tuple
 *
 * @param item The item being inserted into the Symbol Table
 * @return True if the item is successfully inserted (even if shadowing), false if not
 * tuple<bool,
 */
bool SymbolTable::insert(const pair<string, Node>& item) {

    tuple<map<string, Node>::iterator, string> tup = this->search(item.first);
    string retval = get<1>(tup);
    if (retval == "top") {
        cout << "error already defined" << endl;
        return false;
    } else if (retval == "other") {
        cout << "warning for shadowing" << endl;
    }

    table.front().insert(item);
    return true;
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
 */
void SymbolTable::popLevel() {
    if (table.size() == 1) {
        cout << "popping the final level is bad, not gonna do it" << endl;
        return;
    }
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
    return os;
}