/**
 *
 */
#include <iostream>
#include <fstream>

#include "SymbolTable.h"
#include "Node.h"

using namespace std;

/**
 *
 */
void oneLevelTable() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    s.insert(item);
    s.insert(item2);
    s.insert(item3);
    cout << s;
}

/**
 *
 */
void multiLevelTable() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
    s.popLevel();
    cout << s;
}

/**
 *
 */
void popTopLevel() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    s.popLevel();
    cout << s;
}

/**
 *
 */
void failToPopLastLevel() {
    SymbolTable s;
    s.popLevel();
}

/**
 *
 */
void insertConflict() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    s.insert(item);
    s.insert(item); //This causes an error
}

/**
 *
 */
void insertShadowing() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    s.insert(item);
    s.pushLevel();
    s.insert(item); //This causes a shadowing warning
}

/**
 *
 */
void findOnTopScope() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    s.search("Item 3");
}

/**
 *
 */
void findOnLowerScope() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    s.search("Item 2");
}

/**
 *
 */
void failToFind() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    s.search("Item 5");
}

/**
 *
 */
void dumpToFile() {
    SymbolTable s;
    pair<string, Node> item = make_pair("Item 1", Node(4));
    pair<string, Node> item2 = make_pair("Item 2", Node(7));
    pair<string, Node> item3 = make_pair("Item 3", Node(12));
    pair<string, Node> item4 = make_pair("Item 4", Node(200));
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    ofstream outputFile;
    outputFile.open("symbolTable.out");
    outputFile << s;
}

/**
 *
 */
void toggleInsertLookupMode() {
    //todo
}

int main() {
    oneLevelTable();
    multiLevelTable();
    popTopLevel();
    failToPopLastLevel();
    insertConflict();
    insertShadowing();
    findOnTopScope();
    findOnLowerScope();
    failToFind();
    dumpToFile();
    toggleInsertLookupMode();

    return 0;
}