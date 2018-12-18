#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

int registerCnt = 0;

/**
 * Determines if something is an address, true if it is.
 * Example:
 * 4($fp) -> true
 * $t0 -> false
 * 6 -> false
 *
 * @param s The string being checked
 * @return True if address, false otherwise
 */
bool isAddress(const string& s) {
    return s.find('(') != string::npos;
}

bool isImmediate(const string& s) {
    return s.find('$') == string::npos;
}

/**
 * Takes an argument of an instruction and loads it if it's an address (needs loading).
 * If so, the address is loaded, and a register is returned.
 *
 * @param s
 * @param mips
 * @return
 */
string loadAddress(const string& s, ostream& mips) {
    if (isAddress(s)) {
        string s2 = "$s" + to_string(registerCnt++ % 8);
        mips << "\t" << "lw " << s2 << ", " << s << endl;
        return s2;
    }
    else if (isImmediate(s)) {
        string s2 = "$s" + to_string(registerCnt++ % 8);
        mips << "\t" << "li " << s2 << ", " << s << endl;
        return s2;
    }
    else {
        return s;
    }
}

/**
 * Takes a part of an instruction where a result should go and determines if its an address.
 * If it is, it gives it a register and names that register to be stored in storeInAddress.
 *
 * @param s
 * @param mips
 * @return
 */
string needsStored(const string& s) {
    if (isAddress(s)) {
        return "$s" + to_string(registerCnt++ % 8);
    } else {
        return s;
    }
}

/**
 *
 * @param addr It COULD be an address, but it may not be
 * @param reg
 * @param mips
 * @return
 */
void storeInAddress(const string& addr, const string& reg, ostream& mips) {
    if (isAddress(addr)) {
        //Store
        mips << "\t" << "sw " << reg << ", " << addr << endl;
    }
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

        if (line[0] == "ALLOCATE") {
            mips << "\taddiu $sp, $sp, -" << line[1] << endl;
            mips << "\tmove $fp, $sp" << endl;
        }

        if (line[0] == "DEALLOCATE") {
            mips << "\taddiu $sp, $sp, " << line[1] << endl;
            mips << "\tmove $fp, $sp" << endl;
        }

        if (line[0] == "CALL") {
            mips << "\tjal " << line[1] << endl;
        }

        if (line[0] == "RETURN") {
            mips << "\tjr $ra" << endl;
        }

        if (line[0] == "PUSHRETURN") {
            line[1] = loadAddress(line[1], mips);
            mips << "\tsw " << line[1] << ", " << line[2] << endl;
        }

        if (line[0] == "HALT") {
            mips << "\tli $v0, 10" << endl;
            mips << "\tsyscall" << endl;
        }

        if (line[0] == "ASSIGN") {
            line[1] = loadAddress(line[1], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "move " << ret << ", " << line[1] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "PLUS") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "add " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "MINUS") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "sub " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "STAR") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "mul " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "SLASH") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "div " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "MODULO") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "rem " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "LESSTH") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "slt " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "GREATH") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "sgt " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "GE_OP") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "sge " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "LE_OP") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "sle " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "EQ_OP") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "seq " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "NE_OP") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            string ret = needsStored(line[3]);
            mips << "\t" << "sne " << ret << ", " << line[1] << ", " << line[2] << endl;
            storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "BREQ") {
            line[1] = loadAddress(line[1], mips);
            line[2] = loadAddress(line[2], mips);
            //string ret = needsStored(line[3]);
            mips << "\t" << "beq " << line[1] << ", " << line[2] << ", " << line[3] << endl;
            //storeInAddress(line[3], ret, mips);
        }

        if (line[0] == "BR") {
            mips << "\t" << "b " << line[3] << endl;
        }

        if (line[0] == "ADDR" ) {
            mips << "\t" << "la " << line[3] << ", " << line[1] << endl;
        }
    }

    mips.close();
}

