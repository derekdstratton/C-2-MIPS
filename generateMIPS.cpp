#include <iostream>
#include <vector>
#include <string>

using namespace std;

void generateMIPS(vector<vector<string>> tac) {
    for (auto line : tac) {
        if (line[0] == "RETURN") {
            cout << "woohoo" << endl;
        }
    }
}