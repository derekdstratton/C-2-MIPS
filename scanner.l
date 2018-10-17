%{
#include <string>

#include <string.h>
#include <iostream>
#include <utility>
#include <sstream>
#include <fstream>
//#include "parse.tab.h"
#include "SymbolTable.h"
#include <stdlib.h>

#include <fstream>

#include "Node.h"
SymbolTable * sym;
bool isFunction; //true if function
string type_specifier = "none";
string type_qualifier = "none";
string storage_class_specifier = "none";
string signed_or_unsigned = "none";
//#include "parse.tab.h"

#include "parser.hpp"

//TODO: output source code and do column numbers
stringstream sourceStream;
string currentLine;
int first_column = 0;
/*Function declarations*/
using namespace std;
    //note: i'm shoving all my comments up here for lack of better space
    //enumeration constant? i don't think that's even used;

void processToken() //updates column number and outputs source code to file for each token
{
    cout << "column right now is " << first_column << endl;
    cout << "Adding " << yytext << " to currentline" << endl;
    cout << "Adding " << yyleng << " spaces to first_column" << endl;
    first_column += yyleng;
    currentLine += yytext;
}

static bool insertModeFlag = false;
void to_token_file(int token) {
    first_column += yyleng;
    currentLine += yytext;
    ofstream tokenfile;
    //cout << "this happened" << endl;
    tokenfile.open("tokens.out", ios::app);
    tokenfile << yytext << "\n";
    tokenfile.close();
}

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

{newLine} {cout << "clearing first_column and currentLine" << endl; first_column = 0; currentLine.clear();}
{ws} {processToken();}


"!!S" { cout << *getTable();}

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
        type_specifier = "int";
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
    getTable()->setMode(true);
    to_token_file(OPENCUR);
    return (OPENCUR);}
"}" {
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
    //cout << yytext[1] << endl;
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

    cout << yylval.cval;
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
        //cout << "Lead: " << *lead << ", Lag: " << *lag << endl;
        lead++;
        lag++;
    }
    *lag = '\0';
    // len = strlen(strstart);
    //cout << len << endl;
    yylval.sval = strstart;
    //cout << yylval.sval << endl;
    return (STRING_LITERAL); }
{real} {
    to_token_file(FLOATING_CONSTANT);
    yylval.fval = atof(yytext);
    //cout << yylval.fval;
    return (FLOATING_CONSTANT); }
{integer} {
    to_token_file(INTEGER_CONSTANT);
    yylval.ival = atoi(yytext);
    return (INTEGER_CONSTANT); }
{identifier} {
    to_token_file(IDENTIFIER);
    if (yyleng > 31) { //todo check this based on the known type
        //throw warning
        cout << "too long buddy" << endl;
    }
    string s = yytext;
    Node x = Node(4, type_specifier, type_qualifier, storage_class_specifier, signed_or_unsigned);
    if (getTable()->getMode()) {
        //currently in insert mode
        if (!insertModeFlag) {
            //this is a change from insert to lookup, UNLESS you're a typedef
            //todo check to see if you're a typedef'd type
            getTable()->setMode(false); //now you're in lookup mode
        } else {
            //this is a normal insert
            pair<string, Node> entry = make_pair(s,x);
            getTable()->insert(entry);
        }
    } else {
        //currently in lookup mode
        getTable()->search(s);
    }
    return ( IDENTIFIER );}

. { processToken();
    while(string(yytext) != "\n")
    {
        cout << "yytext is " << string(yytext) << endl;
        currentLine += yytext;
        yylex();
    }
    cout << "unrecognized token at line number " << yylineno << endl;
    cout << "first_column is " << first_column << endl;
    cout << currentLine << endl;
    while(first_column-- > 1)
        cout << ' ';
    cout << "^ Unexpected character\n";
    return (-1);}

%%
