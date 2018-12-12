#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

string load(const string &s, ostream& mips) {
    size_t location = s.find('(');
    if (location != string::npos) {
        mips << "\t" << "la " << "$t9, " << s << endl;
        //mips << "\t" << "load " << s.substr(location+1, 3) << endl;
        return "$t9";
    }
    else {
        return s;
    }
}

string store(const string &s, ostream& mips) {
    size_t location = s.find('(');
    if (location != string::npos) {
        mips << "\t" << "move " << s << ", $t8" << endl;
        //mips << "\t" << "load " << s.substr(location+1, 3) << endl;
        return "$t8";
    }
    else {
        return s;
    }
}

bool isOffset(const string& s) {
    return s.find('(') != string::npos;
}

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
                mips << "\t" << "lw " << "$t9, " << line[1] << endl;
                line[1] = "$t9";
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t7";
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
                line[1] = "$t6";
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t7";
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
                mips << "\t" << "lw " << "$t9, " << line[1] << endl;
                line[1] = "$t9";
            }
            if (isOffset(line[2])) {
                //Load
                mips << "\t" << "lw " << "$t8, " << line[2] << endl;
                line[2] = "$t8";
            }
            string ret;
            if (isOffset(line[3])) {
                ret = "$t7";
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

