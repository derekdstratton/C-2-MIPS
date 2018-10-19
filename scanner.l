%{

//TODO deal with comments /* */
//TODO: output source code and do column numbers

/* Headers */

#include <string>
#include <string.h>
#include <iostream>
#include <utility>
#include <sstream>
#include <fstream>
#include <stdlib.h>
#include <fstream>

#include "SymbolTable.h"
#include "Node.h"
#include "parser.hpp"
extern bool debug[4];
extern FILE * yyin;
extern char* fileName;
//TODO: output source code and do column numbers
SymbolTable * sym;
bool isFunction; //true if function
string type_specifier = "none";
string type_qualifier = "none";
string storage_class_specifier = "none";
string signed_or_unsigned = "none";
stringstream sourceStream;
string currentLine;
int first_column = 0;
static bool insertModeFlag = false;

extern FILE * yyin;

/* Function Declarations */
//todo probably combine these three into one function
void outputError(string errmsg1, string errmsg2, bool errtype);
void outputErrorWarningLine();
void outputErrorWarningPosition(string errmsg);
void outputErrorWarning(bool errtype, string errmsg);
void processToken();
void to_token_file(int token);

using namespace std;
    //note: i'm shoving all my comments up here for lack of better space
    //enumeration constant? i don't think that's even used;

void to_token_file(int token);

%}

%option noyywrap
%option yylineno

/*White space*/
newLine [\n]
delim	[ \t\n]
ws	{delim}+

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

%%

{newLine} {
    first_column = 0;
    currentLine.clear();
    yylloc.first_line++;
    }
{ws} {
    processToken();
    }

"!!S" {
    cout << *getTable();
    }

"!!M" {
    string s = getTable()->getMode() ? "Insert" : "Lookup";
    cout << "Mode: " << s << endl;
    }

typedef {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(TYPEDEF);
    return ( TYPEDEF );}
extern {
    if (getTable()->getMode()) {
        insertModeFlag = true;
        storage_class_specifier = "extern";
    }
    to_token_file(EXTERN);
    return ( EXTERN );}
static {
    if (getTable()->getMode()) {
        insertModeFlag = true;
        storage_class_specifier = "static";
    }
    to_token_file(STATIC);
    return ( STATIC );}
auto {
    if (getTable()->getMode()) {
        storage_class_specifier = "auto";
        insertModeFlag = true;
    }
    to_token_file(AUTO);
    return ( AUTO );}
register {
    if (getTable()->getMode()) {
        storage_class_specifier = "register";
        insertModeFlag = true;
    }
    to_token_file(REGISTER);
    return ( REGISTER );}
char {
    if (getTable()->getMode()) {
        type_specifier = "char";
        insertModeFlag = true;
    }
    to_token_file(CHAR);
    return ( CHAR );}
short {
    if (getTable()->getMode()) {
        type_specifier = "short";
        insertModeFlag = true;
    }
    to_token_file(SHORT);
    return ( SHORT );}
int {
    if (getTable()->getMode()) {
        if (type_specifier == "long" || type_specifier == "short") {
            //don't store int, keep it as "long" or "short"
        } else {
            type_specifier = "int";
        }
        insertModeFlag = true;
    }
    to_token_file(INT);
    return ( INT );}
long {
    if (getTable()->getMode()) {
        type_specifier = "long";
        insertModeFlag = true;
    }
    to_token_file(LONG);
    return ( LONG );}
signed {
    if (getTable()->getMode()) {
        signed_or_unsigned = "signed";
        insertModeFlag = true;
    }
    to_token_file(SIGNED);
    return ( SIGNED );}
unsigned {
    if (getTable()->getMode()) {
        signed_or_unsigned = "unsigned";
        insertModeFlag = true;
    }
    to_token_file(UNSIGNED);
    return ( UNSIGNED );}
float {
    if (getTable()->getMode()) {
        type_specifier = "float";
        insertModeFlag = true;
    }
    to_token_file(FLOAT);
    return ( FLOAT );}
double {
    if (getTable()->getMode()) {
        type_specifier = "double";
        insertModeFlag = true;
    }
    to_token_file(DOUBLE);
    return ( DOUBLE );}
const {
    if (getTable()->getMode()) {
        type_qualifier = "const";
        insertModeFlag = true;
    }
    to_token_file(CONST);
    return ( CONST );}
volatile {
    if (getTable()->getMode()) {
        type_qualifier = "none";
        insertModeFlag = true;
    }
    to_token_file(VOLATILE);
    return ( VOLATILE );}
void {
    if (getTable()->getMode()) {
        type_specifier = "void";
        insertModeFlag = true;
    }
    to_token_file(VOID);
    return ( VOID );}
struct {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(STRUCT);
    return ( STRUCT );}
union {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(UNION);
    return ( UNION );}
enum {
    if (getTable()->getMode()) {
        insertModeFlag = true;
    }
    to_token_file(ENUM);
    return ( ENUM );}

case {
    to_token_file(CASE);
    return ( CASE );}
default {
    to_token_file(DEFAULT);
    return ( DEFAULT );}
if {
    to_token_file(IF);
    return ( IF );}
else {
    to_token_file(ELSE);
    return ( ELSE );}
switch {
    to_token_file(SWITCH);
    return ( SWITCH );}
while {
    to_token_file(WHILE);
    return ( WHILE );}
do {
    to_token_file(DO);
    return ( DO );}
for {
    to_token_file(FOR);
    return ( FOR );}
goto {
    to_token_file(GOTO);
    return ( GOTO );}
continue {
    to_token_file(CONTINUE);
    return ( CONTINUE );}
break {
    to_token_file(BREAK);
    return ( BREAK );}
return {
    to_token_file(RETURN);
    return ( RETURN );}


";" {
    if (!insertModeFlag) {
        //move to lookup mode
        getTable()->setMode(false);
    } else {
        //still in insert mode, reset all this
        string type_specifier = "none";
        string type_qualifier = "none";
        string storage_class_specifier = "none";
        string signed_or_unsigned = "none";
    }
    insertModeFlag = false;
    to_token_file(SEMI);
    return (SEMI);}
"{" {
    if(debug[0] && debug[2])
    {
        cout << "Dumping symbol table at line " << yylineno << endl;
        cout << *getTable();
        if(debug[3])
        {
            ofstream SymDump;
            SymDump.open("SymDump.out", ios::app);
            SymDump << *getTable() << "\n\n";
            SymDump.close();
        }
    }
    getTable()->setMode(true);
    //flip to insert mode, make sure all this is reset
    string type_specifier = "none";
    string type_qualifier = "none";
    string storage_class_specifier = "none";
    string signed_or_unsigned = "none";
    insertModeFlag = false;
    to_token_file(OPENCUR);
    return (OPENCUR);}
"}" {
    if(debug[0] && debug[2])
    {
        cout << "Dumping symbol table at line " << yylineno << endl;
        cout << *getTable();
        if(debug[3])
        {
            ofstream SymDump;
            SymDump.open("SymDump.out", ios::app);
            SymDump << *getTable() << "\n\n";
            SymDump.close();
        }
    }
    to_token_file(CLOSCUR);
    return (CLOSCUR);}
"," {
    to_token_file(COMMA);
    return (COMMA);}
"=" {
    to_token_file(ASSIGN);
    return (ASSIGN);}
":" {
    to_token_file(COLON);
    return (COLON);}
"[" {
    to_token_file(OPENSQ);
    return (OPENSQ);}
"]" {
    to_token_file(CLOSSQ);
    return (CLOSSQ);}
"*" {
    to_token_file(STAR);
    return (STAR);}
"(" {
    to_token_file(OPENPAR);
    return (OPENPAR);}
")" {
    to_token_file(CLOSEPAR);
    return (CLOSEPAR);}
"?" {
    to_token_file(TERNARY);
    return (TERNARY);}
"|" {
    to_token_file(BAR);
    return (BAR);}
"^" {
    to_token_file(XOR);
    return (XOR);}
"&" {
    to_token_file(AND);
    return (AND);}
"<" {
    to_token_file(LESSTH);
    return (LESSTH);}
">" {
    to_token_file(GREATH);
    return (GREATH);}
"+" {
    to_token_file(PLUS);
    return (PLUS);}
"-" {
    to_token_file(MINUS);
    return (MINUS);}
"/" {
    to_token_file(SLASH);
    return (SLASH);}
"%" {
    to_token_file(MODULO);
    return (MODULO);}
"~" {
    to_token_file(TILDE);
    return (TILDE);}
"!" {
    to_token_file(BANG);
    return (BANG);}
"." {
    to_token_file(PERIOD);
    return (PERIOD);}


"..." {
    to_token_file(ELIPSIS);
    return ( ELIPSIS );}

"sizeof"    {
    to_token_file(SIZEOF);
    return ( SIZEOF );}
"->"    {
    to_token_file(PTR_OP);
    return ( PTR_OP );}
"++"    {
    to_token_file(INC_OP);
    return ( INC_OP );}
"--"    {
    to_token_file(DEC_OP);
    return ( DEC_OP );}
"<<"    {
    to_token_file(LEFT_OP);
    return ( LEFT_OP );}
">>"    {
    to_token_file(RIGHT_OP);
    return ( RIGHT_OP );}
"<="    {
    to_token_file(LE_OP);
    return ( LE_OP );}
">="    {
    to_token_file(GE_OP);
    return ( GE_OP );}
"=="    {
    to_token_file(EQ_OP);
    return ( EQ_OP );}
"!="    {
    to_token_file(NE_OP);
    return ( NE_OP );}
"&&"    {
    to_token_file(AND_OP);
    return ( AND_OP );}
"||"    {
    to_token_file(OR_OP);
    return ( OR_OP );}
"*="    {
    to_token_file(MUL_ASSIGN);
    return ( MUL_ASSIGN );}
"/="    {
    to_token_file(DIV_ASSIGN);
    return ( DIV_ASSIGN );}
"%="    {
    to_token_file(MOD_ASSIGN);
    return ( MOD_ASSIGN );}
"+="    {
    to_token_file(ADD_ASSIGN);
    return ( ADD_ASSIGN );}
"-="    {
    to_token_file(SUB_ASSIGN);
    return ( SUB_ASSIGN );}
"<<="   {
    to_token_file(LEFT_ASSIGN);
    return ( LEFT_ASSIGN );}
">>="   {
    to_token_file(RIGHT_ASSIGN);
    return ( RIGHT_ASSIGN );}
"&="    {
    to_token_file(AND_ASSIGN);
    return ( AND_ASSIGN );}
"^="    {
    to_token_file(XOR_ASSIGN);
    return ( XOR_ASSIGN );}
"|="    {
    to_token_file(NE_OP);
    return ( NE_OP );}

{character_constant} {
    to_token_file(CHARACTER_CONSTANT);
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
                //todo deal with octal, hex, weird stuff
            default:
                yylval.cval = yytext[2];
                break;
        }
    }
    else {
        yylval.cval = yytext[1];
    }
    return (CHARACTER_CONSTANT); }
{string_literal} {
    to_token_file(STRING_LITERAL);
    char * strstart = yytext+1;
    int initial_len = strlen(strstart);
    strstart[initial_len-1] = '\0';
    char * lead = strstart;
    char * lag = strstart;
    while (*lead != '\0') {
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
                //todo deal with octal, hex, weird stuff
                default:
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
    yylval.sval = strstart;
    return (STRING_LITERAL); }
{real} {
    to_token_file(FLOATING_CONSTANT);
    yylval.fval = atof(yytext);
    return (FLOATING_CONSTANT); }
{integer} {
    to_token_file(INTEGER_CONSTANT);
    //test if the integer is too big, aka bigger than a long
    char * max_int = "2147483647";
    char * min_int = "2147483648";
    //todo check size for a long, c string compare
    yylval.ival = atol(yytext);
    return (INTEGER_CONSTANT); }
{identifier} {
    to_token_file(IDENTIFIER);
    if (yyleng > 31) {
        outputError("too long buddy", "Identifier name too long.", true);
    }
    string s = yytext;
    Node x = Node(4, type_specifier, type_qualifier, storage_class_specifier, signed_or_unsigned);
    if (getTable()->getMode()) {
        //currently in insert mode
        if (!insertModeFlag) {
            //this is a change from insert to lookup, UNLESS you're a typedef
            //todo check to see if you're a typedef'd type
            getTable()->setMode(false); //now you're in lookup mode
            //lookup mode operations
            tuple<map<string, Node>::iterator, string> result = getTable()->search(s);
            map<string, Node>::iterator it;
            string status;
            tie(it, status) = result;
            if (status == "not") {
                outputError("Not found", "Identifier not defined.", false);
            }
        } else {
            //this is a normal insert
            pair<string, Node> entry = make_pair(s,x);
            tuple<bool, bool> result = getTable()->insert(entry);
            bool insertSuccess, notShadowing;
            tie(insertSuccess, notShadowing) = result;
            if (!insertSuccess) {
                outputError("Already exists", "Variable already exists on this scope.", false);
            } else if (!notShadowing) {
                outputError("Already exists", "Shadowing an identifier from an outer scope.", true);
            }
        }
    } else {
        cout << "going else" << endl;
        //currently in lookup mode
        //lookup mode operations
        tuple<map<string, Node>::iterator, string> result = getTable()->search(s);
        map<string, Node>::iterator it;
        string status;
        tie(it, status) = result;
        if (status == "not") {
            outputError("Not found", "Identifier not defined.", false);
        }
        //todo what are we supposed to do with the iterator, yylval?
    }
    return ( IDENTIFIER );}

. { processToken();
    /*while(string(yytext) != "\n")
    {
        cout << "yytext is " << string(yytext) << endl;
        currentLine += yytext;
        yylex();
    }*/

    outputErrorWarningLine();
    outputErrorWarningPosition("Unexpected Character");
    return (ERROR);}


%%

void outputError(string errmsg1, string errmsg2, bool errtype) {
    outputErrorWarningLine();
    outputErrorWarningPosition(errmsg1);
    outputErrorWarning(errtype, errmsg2);
}

void outputErrorWarningLine(){
    ifstream errInput;
    errInput.open(fileName);
    for(int i = 0; i < yylineno - 1; i++)
    {
        getline(errInput, currentLine);
    }
    getline(errInput, currentLine);
    cerr << currentLine << endl;
    //todo put this along with every error. except make a separate file pointer so it prints the whole line
}

void outputErrorWarningPosition(string errmsg) {
    int tmp = first_column;
    while(tmp-- > 1)
        cerr << ' ';
    //todo handle tab characters
    cerr << "^ " << errmsg << "\n";
}

//errtype true if its a warning, false if its an error
void outputErrorWarning(bool errtype, string errmsg) {
    string s = errtype ? "Warning" : "Error";
    cerr << s << " on line " << yylineno << ": " << errmsg << endl;
}

void processToken() //updates column number and outputs source code to file for each token
{
    first_column += yyleng;
    currentLine += yytext;
}

void to_token_file(int token) {
    first_column += yyleng;
    currentLine += yytext;
    ofstream tokenfile;
    tokenfile.open("tokens.out", ios::app);
    tokenfile << yytext << " " << token << "\n";
    tokenfile.close();
}