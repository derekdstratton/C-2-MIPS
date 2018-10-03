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

/** Writes the contents of the Symbol Table to a file
 *
 * @param filepath The path the file is written to
 */
void SymbolTable::writeToFile(const string &filepath) {
    ofstream file;
    file.open(filepath);

    file << "Symbol Table:" << endl << "Stack size: " << table.size() << endl;
    file << "Maps: (Level 0 top of stack)" << endl;
    int i = 0;
    for (auto& map : table) {
        file << "Map at level " << i << " (size: " << map.size() << ")" << endl;
        for (auto& mappair : map) {
            file << "Key: " << mappair.first << ", Value: " << mappair.second << endl;
        }
        i++;
    }
    file << endl;
    file.close();
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
 * Prints the Symbol Table to stdout
 */
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