#include <iostream>

#include "SymbolTable.h"

using namespace std;
int main() {
    SymbolTable s;
    int num;
    do {
        cout << "Current Symbol Table: " << endl;
        cout << s;
        cout << "What would you like to do now (Type 0 to view options, type -1 to exit)?" << endl;
        cin >> num;
        switch (num) {
            case -1:{
                num = -1;
                break;}
            case 0: {
                cout << "Option 1: Insert into Symbol Table." << endl;
                cout << "Option 2: Search Symbol Table." << endl;
                cout << "Option 3: Push Level onto Symbol Table." << endl;
                cout << "Option 4: Pop Level off Symbol Table." << endl;
                cout << "Option 5: Set mode of Symbol Table (insert/lookup)." << endl;
                cout << "Option 6: Return current mode of Symbol Table." << endl;
                break;}
            case 1: {
                cout << "Type an identifier to insert (A default node will be generated):" << endl;
                string a;
                cin >> a;
                tuple<bool, bool> ret = s.insert(make_pair(a, SymbolTableNode2()));
                bool insertSuccess, notShadowing;
                tie(insertSuccess, notShadowing) = ret;
                if (!insertSuccess) {
                    cout << "Element already exists at top scope. Failed to insert." << endl;
                }
                else if (!notShadowing) {
                    cout << "Element successfully inserted, but is shadowing a lower level variable." << endl;
                }
                else if (notShadowing) {
                    cout << "Successfully inserted! " << endl;
                }
                break; }
            case 2: {
                cout << "Type an identifier to search for:" << endl;
                string ab;
                cin >> ab;
                tuple<SymbolTableNode2*, string> retr = s.search(ab);
                SymbolTableNode2* it;
                string status;
                tie(it, status) = retr;
                if (status == "top") {
                    cout << "Found on the top level." << endl;
                } else if (status == "other") {
                    cout << "Found on a lower level than the top." << endl;
                } else if (status == "not") {
                    cout << "Not found." << endl;
                }
                break; }
            case 3: {
                s.pushLevel();
                cout << "Pushed a new level." << endl;
                break; }
            case 4: {
                bool ret = s.popLevel();
                if (!ret) {
                    cout << "Failed to pop level, you're on the last level!" << endl;
                } else {
                    cout << "Popped the top level." << endl;
                }
                break; }
            case 5: {
                cout << "Enter 1 to set the mode to insert, 0 to set the mode to lookup." << endl;
                int p;
                cin >> p;
                s.setMode(p);
                cout << "Mode successfully set." << endl;
                break; }
            case 6: {
                string k = s.getMode() ? "Insert" : "Lookup";
                cout << "The Current Mode is: " << k << endl;
                break; }
            default:
                cout << "Please enter a valid number." << endl;
                break;
        }
        cout << "------" << endl;
    } while (num != -1);
    return 0;
}