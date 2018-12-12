#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

bool isOffset(const string& s) {
    return s.find('(') != string::npos;
}

int registerCnt = 100;

void generateMIPS(vector<vector<string>> tac) {
    ofstream mips;
    mips.open("final.s");

    for (auto line : tac) {
        if (line[0] == "COMMENT") {
            mips << "# " << line[1] << endl;
        }

        if (line[0] == "LABEL") {
            mips << line[1] << ":" << endl;
        }

        if (line[0] == "ASSIGN") {
            if (isOffset(line[1])) {
                //Needs loaded
                string s = "$t" + to_string(registerCnt++);
                mips << "\t" << "lw " << s << ", " << line[1] << endl;
                line[1] = s;
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t" + to_string(registerCnt++);
            } else {
                ret = line[3];
            }
            mips << "\t" << "move " << ret << ", " << line[1] << endl;
            if (isOffset(line[3])) {
                //Store
                mips << "\t" << "sw " << ret << ", " << line[3] << endl;
            }
        }

        if (line[0] == "ASSIGNI") {
            if (isOffset(line[1])) {
                //Needs loaded
                mips << "\t" << "lw " << "$t6, " << line[1] << endl;
                line[1] = "$t" + to_string(registerCnt++);
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t" + to_string(registerCnt++);
            } else {
                ret = line[3];
            }
            mips << "\t" << "li " << ret << ", " << line[1] << endl;
            if (isOffset(line[3])) {
                //Store
                mips << "\t" << "sw " << ret << ", " << line[3] << endl;
            }
        }

        if (line[0] == "PLUS") {
            if (isOffset(line[1])) {
                //Needs loaded
                string s = "$t" + to_string(registerCnt++);
                mips << "\t" << "lw " << s << ", " << line[1] << endl;
                line[1] = s;
            }
            if (isOffset(line[2])) {
                //Load
                string s = "$t" + to_string(registerCnt++);
                mips << "\t" << "lw " << s << ", " << line[2] << endl;
                line[2] = s;
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t" + to_string(registerCnt++);
            } else {
                ret = line[3];
            }
            mips << "\t" << "add " << ret << ", " << line[1] << ", " << line[2] << endl;
            if (isOffset(line[3])) {
                //Store
                mips << "\t" << "sw " << ret << ", " << line[3] << endl;
            }
        }
    }

    mips.close();
}

