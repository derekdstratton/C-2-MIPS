%{

/* Headers */

#include <string>
#include <string.h>
#include <iostream>
#include <utility>
#include <sstream>
#include <fstream>
#include <stdlib.h>
#include <deque>
#include <cfloat>

#include "SymbolTable.h"
#include "ASTNodes.h"
#include "parser.hpp"
#include "ASTNodes.h"

#define YYSTYPE ASTNode

/* Global Variables */

list <ASTNode*> empty;
extern string TOKENPATH;
extern string PRODPATH;
extern string SYMBOLPATH;
extern string ASTPATH;
extern bool debug[5];
extern char* fileName;
extern int lineNum;
deque <char> columnQueue;

stringstream sourceStream;
extern string newOutputFile;
string currentLine;
static bool insertModeFlag = false; //Flag set to true if a statement declares a variable

/* Function Declarations */
void outputError(string errmsg1, string errmsg2, bool errtype);
void outputErrorWarningLine();
int outputErrorWarningPosition(string errmsg);
void outputErrorWarning(bool errtype, string errmsg, int columnNum);
void to_token_file(int token, string tokName);

using namespace std;
%}

%option noyywrap
%option yylineno

/*White space*/
newLine [\n]
tab [\t]
space [' ']

/*Numbers*/
digit	[0-9]
integer	{digit}+
plain_real {integer}"."{integer}
expreal {integer}"."{integer}[Ee][+-]?{integer}
real {plain_real}|{expreal}

identifier [a-zA-Z_][a-zA-Z_{digit}]*
string_literal \"[^\"]*\"

escape_sequence (\\)((\\)|(\")|(\')|(a)|(b)|(f)|(n)|(r)|(t)|(v)|(\?)|([0-9]?[0-9]?[0-9]?)|(x[0-9]?[0-9]?))

character_constant \'([^']|{escape_sequence})\'

comment \/\*(.|{newLine})*\*\/

%%

{comment} {/*do nothing*/;}

{newLine} {
    //Increments line counter and fixes column count
    yylloc.first_line++;
    while(!columnQueue.empty())
        columnQueue.pop_front();
    }
{tab} {
    //Fix column count
    columnQueue.push_back('\t');
    }
{space} {
    //Fix column count
    columnQueue.push_back(' ');
    }

"!!S" {
    //Dump symbol table
    cout << *getTable();
    }

"!!M" {
    //Output symbol table mode
    string s = getTable()->getMode() ? "Insert" : "Lookup";
    cout << "Mode: " << s << endl;
    }

"!!P" {
    //Toggle production output
    debug[3] = !debug[3];
    }

typedef {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(TYPEDEF, "TYPEDEF");
    return ( TYPEDEF );}
extern {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(EXTERN, "EXTERN");
    return ( EXTERN );}
static {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(STATIC, "STATIC");
    return ( STATIC );}
auto {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(AUTO, "AUTO");
    return ( AUTO );}
register {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(REGISTER, "REGISTER");
    return ( REGISTER );}
char {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(CHAR, "CHAR");
    return ( CHAR );}
short {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(SHORT, "SHORT");
    return ( SHORT );}
int {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(INT, "INT");
    return ( INT );}
long {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(LONG, "LONG");
    return ( LONG );}
signed {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(SIGNED, "SIGNED");
    return ( SIGNED );}
unsigned {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(UNSIGNED, "UNSIGNED");
    return ( UNSIGNED );}
float {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(FLOAT, "FLOAT");
    return ( FLOAT );}
double {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(DOUBLE, "DOUBLE");
    return ( DOUBLE );}
const {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(CONST, "CONST");
    return ( CONST );}
volatile {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(VOLATILE, "VOLATILE");
    return ( VOLATILE );}
void {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(VOID, "VOID");
    return ( VOID );}
struct {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(STRUCT, "STRUCT");
    return ( STRUCT );}
union {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(UNION, "UNION");
    return ( UNION );}
enum {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(ENUM, "ENUM");
    return ( ENUM );}

case {
    to_token_file(CASE, "CASE");
    return ( CASE );}
default {
    to_token_file(DEFAULT, "DEFAULT");
    return ( DEFAULT );}
if {
    to_token_file(IF, "IF");
    return ( IF );}
else {
    to_token_file(ELSE, "ELSE");
    return ( ELSE );}
switch {
    to_token_file(SWITCH, "SWITCH");
    return ( SWITCH );}
while {
    to_token_file(WHILE, "WHILE");
    return ( WHILE );}
do {
    to_token_file(DO, "DO");
    return ( DO );}
for {
    to_token_file(FOR, "FOR");
    return ( FOR );}
goto {
    to_token_file(GOTO, "GOTO");
    return ( GOTO );}
continue {
    to_token_file(CONTINUE, "CONTINUE");
    return ( CONTINUE );}
break {
    to_token_file(BREAK, "BREAK");
    return ( BREAK );}
return {
    to_token_file(RETURN, "RETURN");
    return ( RETURN );}


";" {
    if (!insertModeFlag) {
        //move to lookup mode
        getTable()->setMode(false);
    }
    insertModeFlag = false;
    to_token_file(SEMI, "SEMI");
    return (SEMI);}
"{" {
    getTable()->pushLevel();
    if(debug[0] && debug[2])
    {
        ofstream SymDump;
        SymDump.open(SYMBOLPATH, ios::app);
        SymDump << "DUMPING SYMBOL TABLE AT LINE " << yylineno << endl;
        SymDump << *getTable() << "\n\n";
        SymDump.close();
    }
    getTable()->setMode(true);
    insertModeFlag = false;
    to_token_file(OPENCUR, "OPENCUR");
    return (OPENCUR);}
"}" {
    //Dump symbol table at scope exit
    if(debug[0] && debug[2])
    {
        ofstream SymDump;
        SymDump.open(SYMBOLPATH, ios::app);
        SymDump << "DUMPING SYMBOL TABLE AT LINE " << yylineno << endl;
        SymDump << *getTable() << "\n\n";
        SymDump.close();
    }
    getTable()->popLevel();
    to_token_file(CLOSCUR, "CLOSECUR");
    return (CLOSCUR);}
"," {
    to_token_file(COMMA, "COMMA");
    return (COMMA);}
"=" {
    to_token_file(ASSIGN, "ASSIGN");
    return (ASSIGN);}
":" {
    to_token_file(COLON, "COLON");
    return (COLON);}
"[" {
    to_token_file(OPENSQ, "OPENSQ");
    return (OPENSQ);}
"]" {
    to_token_file(CLOSSQ, "CLOSSQ");
    return (CLOSSQ);}
"*" {
    to_token_file(STAR, "STAR");
    return (STAR);}
"(" {
    to_token_file(OPENPAR, "OPENPAR");
    return (OPENPAR);}
")" {
    to_token_file(CLOSEPAR, "CLOSPAR");
    return (CLOSEPAR);}
"?" {
    to_token_file(TERNARY, "TERNARY");
    return (TERNARY);}
"|" {
    to_token_file(BAR, "BAR");
    return (BAR);}
"^" {
    to_token_file(XOR, "XOR");
    return (XOR);}
"&" {
    to_token_file(AND, "AND");
    return (AND);}
"<" {
    to_token_file(LESSTH, "LESSTH");
    return (LESSTH);}
">" {
    to_token_file(GREATH, "GREATH");
    return (GREATH);}
"+" {
    to_token_file(PLUS, "PLUS");
    return (PLUS);}
"-" {
    to_token_file(MINUS, "MINUS");
    return (MINUS);}
"/" {
    to_token_file(SLASH, "SLASH");
    return (SLASH);}
"%" {
    to_token_file(MODULO, "MODULO");
    return (MODULO);}
"~" {
    to_token_file(TILDE, "TILDE");
    return (TILDE);}
"!" {
    to_token_file(BANG, "BANG");
    return (BANG);}
"." {
    to_token_file(PERIOD, "PERIOD");
    return (PERIOD);}


"..." {
    to_token_file(ELIPSIS, "ELIPSIS");
    return ( ELIPSIS );}
"sizeof"    {
    to_token_file(SIZEOF, "SIZEOF");
    return ( SIZEOF );}
"->"    {
    to_token_file(PTR_OP, "PTR_OP");
    return ( PTR_OP );}
"++"    {
    to_token_file(INC_OP, "INC_OP");
    return ( INC_OP );}
"--"    {
    to_token_file(DEC_OP, "DEC_OP");
    return ( DEC_OP );}
"<<"    {
    to_token_file(LEFT_OP, "LEFT_OP");
    return ( LEFT_OP );}
">>"    {
    to_token_file(RIGHT_OP, "RIGHT_OP");
    return ( RIGHT_OP );}
"<="    {
    to_token_file(LE_OP, "LE_OP");
    return ( LE_OP );}
">="    {
    to_token_file(GE_OP, "GE_OP");
    return ( GE_OP );}
"=="    {
    to_token_file(EQ_OP, "EQ_OP");
    return ( EQ_OP );}
"!="    {
    to_token_file(NE_OP, "NE_OP");
    return ( NE_OP );}
"&&"    {
    to_token_file(AND_OP, "AND_OP");
    return ( AND_OP );}
"||"    {
    to_token_file(OR_OP, "OR_OP");
    return ( OR_OP );}
"*="    {
    to_token_file(MUL_ASSIGN, "MUL_ASSIGN");
    return ( MUL_ASSIGN );}
"/="    {
    to_token_file(DIV_ASSIGN, "DIV_ASSIGN");
    return ( DIV_ASSIGN );}
"%="    {
    to_token_file(MOD_ASSIGN, "MOD_ASSIGN");
    return ( MOD_ASSIGN );}
"+="    {
    to_token_file(ADD_ASSIGN, "ADD_ASSIGN");
    return ( ADD_ASSIGN );}
"-="    {
    to_token_file(SUB_ASSIGN, "SUB_ASSIGN");
    return ( SUB_ASSIGN );}
"<<="   {
    to_token_file(LEFT_ASSIGN, "LEFT_ASSIGN");
    return ( LEFT_ASSIGN );}
">>="   {
    to_token_file(RIGHT_ASSIGN, "RIGHT_ASSIGN");
    return ( RIGHT_ASSIGN );}
"&="    {
    to_token_file(AND_ASSIGN, "AND_ASSIGN");
    return ( AND_ASSIGN );}
"^="    {
    to_token_file(XOR_ASSIGN, "XOR_ASSIGN");
    return ( XOR_ASSIGN );}
"|="    {
    to_token_file(NE_OP, "NE_OP");
    return ( NE_OP );}

{character_constant} {
    to_token_file(CHARACTER_CONSTANT, "CHARACTER_CONSTANT");
    //passing escape characters
    if (yytext[1] == '\\') {
        switch(yytext[2]) {
            case 'n':
                yylval.cval = '\n';
                break;
            case 'a':
                yylval.cval = '\a';
                break;
            case 'b':
                yylval.cval = '\b';
                break;
            case 'f':
                yylval.cval = '\f';
                break;
            case 'r':
                yylval.cval = '\r';
                break;
            case 't':
                yylval.cval = '\t';
                break;
            case 'v':
                yylval.cval = '\v';
                break;
            default:
                //Future- processing of octal/hex escapes
                yylval.cval = yytext[2];
                break;
        }
    }
    else {
        yylval.cval = yytext[1];
    }
    return (CHARACTER_CONSTANT); }
{string_literal} {
    //run through the string to search for escape characters
    //This way, yylval will contain the proper values
    to_token_file(STRING_LITERAL, "STRING_LITERAL");
    char * strstart = yytext+1;
    int initial_len = strlen(strstart);
    strstart[initial_len-1] = '\0';
    char * lead = strstart;
    char * lag = strstart;
    while (*lead != '\0') {
        //Dealing with escape characters
        if (*lead == '\\') {
            lead++;
            switch(*lead) {
                case 'n':
                    *lag = '\n';
                    break;
                case 'a':
                    *lag = '\a';
                    break;
                case 'b':
                    *lag = '\b';
                    break;
                case 'f':
                    *lag = '\f';
                    break;
                case 'r':
                    *lag = '\r';
                    break;
                case 't':
                    *lag = '\t';
                    break;
                case 'v':
                    *lag = '\v';
                    break;
                default:
                    //Future- processing of octal/hex escapes
                    *lag = *lead;
                    break;
            }
        } else {
            *lag = *lead;
        }
        lead++;
        lag++;
    }
    *lag = '\0';
    yylval.sval = new string(strstart);
    return (STRING_LITERAL); }
{real} {
    float num = atof(yytext);
    to_token_file(FLOATING_CONSTANT, "FLOATING_CONSTANT");
    if (num > FLT_MAX) {
        for(int i = 0; i < yyleng; i++)
            columnQueue.pop_back();
        outputError("Too long", "Floating Constant too long.", true);
    }
    yylval.fval = atof(yytext);
    return (FLOATING_CONSTANT); }
{integer} {
    to_token_file(INTEGER_CONSTANT, "INTEGER_CONSTANT");
    //test if the integer is too big, aka bigger than a long
    long num = atoi(yytext);
    string orig = yytext;
    string updated = to_string(num);
    if (orig != updated) {
        for(int i = 0; i < yyleng; i++)
            columnQueue.pop_back();
        outputError("Too long", "Integer Constant too long.", true);
    }
    yylval.ival = atoi(yytext);
    return (INTEGER_CONSTANT); }
{identifier} {
    to_token_file(IDENTIFIER, "IDENTIFIER");
    if (yyleng > 31) {
        for(int i = 0; i < yyleng; i++)
            columnQueue.pop_back();
        outputError("Too long", "Identifier name too long.", true);
    }
    yylval.sval = new string(yytext);
    return ( IDENTIFIER );
}

. {
    for(int i = 0; i < yyleng; i++)
        columnQueue.pop_back();
    to_token_file(ERROR, "ERROR1");
    outputError("Invalid", "Invalid character", false);
    exit(0);
  }


%%

/**
 * Outputs an Error or Warning Message
 *
 * @param errmsg1 the error message right next to the ^
 * @param errmsg2 the error message on the following line
 * @param errtype true if its a warning, false if its an error
 */
void outputError(string errmsg1, string errmsg2, bool errtype) {

    ifstream errInput;
    errInput.open(fileName);
    for(int i = 0; i < yylineno - 1; i++)
        getline(errInput, currentLine);

    deque <char> errQueue;
    while(errInput.peek() != '\n')
        errQueue.push_back(errInput.get());
    while(!errQueue.empty()) {
        cerr << errQueue.front();
        errQueue.pop_front();
    }
    cerr << endl;

    int columnNum = columnQueue.size() + 1;
    while(!columnQueue.empty()) {
        if(columnQueue.front() == '\t')
            cerr << columnQueue.front();
        else
            cerr << ' ';

        columnQueue.pop_front();
    }
    cerr << "^ " << errmsg1 << "\n";

    cerr << (errtype ? "Warning" : "Error") << " on line " << yylineno << " (column " << columnNum << "): " << errmsg2 << endl;
    if(!errtype)
        exit(0);
}

/**
 * Outputs the token to a file, including the token value and the string representation
 * @param token the token number to be output
 */
void to_token_file(int token, string tokName) {
    if(tokName == "ERROR")
    {
        ofstream errStream;
        errStream.open(TOKENPATH, ios::app);
        errStream << "  ERROR" << endl;
        errStream.close();
    }
    else if(tokName == "ERROR1")
    {
        ofstream errStream;
        errStream.open(TOKENPATH, ios::app);
        errStream << "  ERROR" << endl;
        errStream.close();
        for (int i = 0; i < yyleng; i++)
            columnQueue.push_back(' ');
    }
    else {
        ofstream pStream;

        if (debug[4])
            pStream.open(newOutputFile, ios::app);
        else
            pStream.open("list_file", ios::app);

        pStream << endl << yytext << endl << endl;
        for (int i = 0; i < yyleng; i++)
            columnQueue.push_back(' ');
        if (debug[1] && debug[0]) {
            ofstream tokenfile;
            tokenfile.open(TOKENPATH, ios::app);
            tokenfile << yytext << " " << tokName << " " << token << "\n";
            tokenfile.close();
        }
    }
}