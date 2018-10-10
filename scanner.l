%{
#include <string>
#include <iostream>
#include <utility>
#include "SymbolTable.h"
#include <stdlib.h>

#include <fstream>

#include "Node.h"
    SymbolTable symbolTable;
//#include "parse.tab.h"

#include "parser.hpp"
/*Function declarations*/
using namespace std;
    //note: i'm shoving all my comments up here for lack of better space
    //enumeration constant? i don't think that's even used.

    void to_token_file(int token);
%}

%option noyywrap

/*White space*/
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

escape_sequence (\\)((\\)|(\")|(\')|(a)|(b)|(f)|(n)|(r)|(t)|(v)|(\?)|([0-9][0-9][0-9])|(x[0-9][0-9]))

character_constant \'([^']|{escape_sequence})\'

%%

{ws}

"!!S" { cout << symbolTable;}

typedef {
    to_token_file(TYPEDEF);
    return ( TYPEDEF );}
extern {
    to_token_file(EXTERN);
    return ( EXTERN );}
static {
    to_token_file(STATIC);
    return ( STATIC );}
auto {
    to_token_file(AUTO);
    return ( AUTO );}
register {
    to_token_file(REGISTER);
    return ( REGISTER );}
char {
    to_token_file(CHAR);
    return ( CHAR );}
short {
    to_token_file(SHORT);
    return ( SHORT );}
int {
    to_token_file(INT);
    return ( INT );}
long {
    to_token_file(LONG);
    return ( LONG );}
signed {
    to_token_file(SIGNED);
    return ( SIGNED );}
unsigned {
    to_token_file(UNSIGNED);
    return ( UNSIGNED );}
float {
    to_token_file(FLOAT);
    return ( FLOAT );}
double {
    to_token_file(DOUBLE);
    return ( DOUBLE );}
const {
    to_token_file(CONST);
    return ( CONST );}
volatile {
    to_token_file(VOLATILE);
    return ( VOLATILE );}
void {
    to_token_file(VOID);
    return ( VOID );}
struct {
    to_token_file(STRUCT);
    return ( STRUCT );}
union {
    to_token_file(UNION);
    return ( UNION );}
enum {
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
    to_token_file(SEMI);
    return (SEMI);}
"{" {
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
    //passing escape characters
    cout << yytext[1] << endl;
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
    to_token_file(CHARACTER_CONSTANT);
    return (CHARACTER_CONSTANT); }
{string_literal} {
    char * strstart = yytext+1;
    int len = strlen(strstart);
    strstart[len-1] = '\0';
    cout << len << endl;
    yylval.sval = strstart;
    cout << yylval.sval << endl;
    to_token_file(STRING_LITERAL);
    return (STRING_LITERAL); }
{real} {
    yylval.fval = atof(yytext);
    cout << yylval.fval;
    to_token_file(FLOATING_CONSTANT);
    return (FLOATING_CONSTANT); }
{integer} {
    yylval.ival = atoi(yytext);
    to_token_file(INTEGER_CONSTANT);
    return (INTEGER_CONSTANT); }
{identifier} {
    if (yyleng > 31) {
        //throw warning
        cout << "too long buddy" << endl;
    }
    string s = yytext;
    Node x = Node(4);
    pair<string, Node> entry = make_pair(s,x);
    symbolTable.insert(entry);
    to_token_file(IDENTIFIER);
    cout << symbolTable << endl;
    return ( IDENTIFIER );}

. { cout << "unrecognized!" << endl;
    return (-1);}

%%

void to_token_file(int token) {
    ofstream tokenfile;
    tokenfile.open("tokens.out", ios::app);
    tokenfile << token << "\n";
    tokenfile.close();
}
/*
int main(){
    FlexLexer* lexer = new yyFlexLexer;
    symbolTable.pushLevel(); //make sure to start with this first level or crash!
    int token = lexer->yylex();
    cout << token;
    return 0;
}*/
