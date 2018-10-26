#include <iostream>
#include <fstream>

#include "SymbolTable.h"
#include "SymbolTableNode.h"

using namespace std;

/**
 * Test #1
 * Tests that a one-level Symbol Table works properly.
 */
void oneLevelTable() {
    cout << "Tests that a one-level Symbol Table works properly." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.insert(item3);
    cout << s;
}

/**
 * Test #2
 * Tests that a multiple-level Symbol Table works properly.
 */
void multiLevelTable() {
    cout << "Tests that a multiple-level Symbol Table works properly." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
}

/**
 * Test #3
 * Tests that the top level of the Symbol Table can be successfully popped.
 */
void popTopLevel() {
    cout << "Tests that the top level of the Symbol Table can be successfully popped." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
    //Should be true, successfully pop top level.
    cout << s.popLevel() << endl;
    cout << s;
}

/**
 * Test #4
 * Tests that the Symbol Table will not pop off it's only level.
 */
void failToPopLastLevel() {
    cout << "Tests that the Symbol Table will not pop off it's only level.";
    SymbolTable s;
    cout << s;
    //Should be false, fail to pop only level.
    cout << s.popLevel() << endl;
}

/**
 * Test #5
 * Tests that the Symbol Table returns appropriate info for an insert conflict.
 */
void insertConflict() {
    cout << "Tests that the Symbol Table returns appropriate info for an insert conflict." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1",SymbolTableNode());
    s.insert(item);
    tuple<bool, bool> ret = s.insert(item);
    cout << s;
    bool successInsert, notShadowing;
    tie(successInsert, notShadowing) = ret;
    //Should be false, did not successfully insert.
    cout << successInsert << endl;
}

/**
 * Test #6
 * Tests that the Symbol Table returns appropriate info for a shadowing variable.
 */
void insertShadowing() {
    cout << "Tests that the Symbol Table returns appropriate info for a shadowing variable." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    s.insert(item);
    s.pushLevel();
    tuple<bool, bool> ret =  s.insert(item);
    cout << s;
    bool successInsert, notShadowing;
    tie(successInsert, notShadowing) = ret;
    //Should be false, notShadowing is not true.
    cout << notShadowing << endl;
}

/**
 * Test #7
 * Tests that the Symbol Table can find an element on the top scope and return that info.
 */
void findOnTopScope() {
    cout << "Tests that the Symbol Table can find an element on the top scope and return that info." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
    tuple<map<string, SymbolTableNode>::iterator, string> ret = s.search("Item 3", true);
    map<string, SymbolTableNode>::iterator it;
    string status;
    tie(it, status) = ret;
    //Should print "top", for it being found on the top scope.
    cout << status << endl;
}

/**
 * Test #8
 * Tests that the Symbol Table can find an element on the top scope and return that info.
 */
void findOnLowerScope() {
    cout << "Tests that the Symbol Table can find an element on the top scope and return that info." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
    tuple<map<string, SymbolTableNode>::iterator, string> ret = s.search("Item 2");
    map<string, SymbolTableNode>::iterator it;
    string status;
    tie(it, status) = ret;
    //Should print "other", for it being found on another scope.
    cout << status << endl;
}

/**
 * Test #9
 * Tests that the Symbol Table will return appropriate info that search didn't find an item.
 */
void failToFind() {
    cout << "Tests that the Symbol Table will return appropriate info that search didn't find an item." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    cout << s;
    tuple<map<string, SymbolTableNode>::iterator, string> ret = s.search("Item 5");
    map<string, SymbolTableNode>::iterator it;
    string status;
    tie(it, status) = ret;
    //Should print "not", for not being found.
    cout << status << endl;
}

/**
 * Test #10
 * Tests that the Symbol Table dumps info to a file. Currently called symbolTable.out.
 */
void dumpToFile() {
    cout << "Tests that the Symbol Table dumps info to a file. Currently called symbolTable.out." << endl;
    SymbolTable s;
    pair<string, SymbolTableNode> item = make_pair("Item 1", SymbolTableNode());
    pair<string, SymbolTableNode> item2 = make_pair("Item 2", SymbolTableNode());
    pair<string, SymbolTableNode> item3 = make_pair("Item 3", SymbolTableNode());
    pair<string, SymbolTableNode> item4 = make_pair("Item 4", SymbolTableNode());
    s.insert(item);
    s.insert(item2);
    s.pushLevel();
    s.insert(item3);
    s.insert(item4);
    ofstream outputFile;
    outputFile.open("symbolTable.out");
    outputFile << s;
    cout << s;
}

/**
 * Test #11
 * Tests that the Symbol Table can be set to insert or lookup mode.
 */
void setInsertLookupMode() {
    cout << "Tests that the Symbol Table can be set to insert or lookup mode." << endl;
    SymbolTable s;
    s.setMode(false);
    // Switching to false switches to Insert Mode
    cout << s.getMode() << endl;
    s.setMode(true);
    // Switching to true switches to Insert Mode
    cout << s.getMode() << endl;
}

int main() {
    int num;
    do {
        cout << "Enter a test number (1-11), or 0 to exit." << endl;
        cin >> num;
        switch (num) {
            case 0:
                num = 0;
                break;
            case 1:
                oneLevelTable();
                break;
            case 2:
                multiLevelTable();
                break;
            case 3:
                popTopLevel();
                break;
            case 4:
                failToPopLastLevel();
                break;
            case 5:
                insertConflict();
                break;
            case 6:
                insertShadowing();
                break;
            case 7:
                findOnTopScope();
                break;
            case 8:
                findOnLowerScope();
                break;
            case 9:
                failToFind();
                break;
            case 10:
                dumpToFile();
                break;
            case 11:
                setInsertLookupMode();
                break;
            default:
                cout << "Please enter a valid number." << endl;
                num = -1;
                break;
        }
    } while (num != 0);

    return 0;
}