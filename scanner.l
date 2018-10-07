%{
#include <string>
#include <iostream>
#include <utility>
#include "SymbolTable.h"
#include <stdlib.h>

#include "Node.h"
    SymbolTable symbolTable;
#include "parse.tab.h"
/*Function declarations*/
using namespace std;
    //note: i'm shoving all my comments up here for lack of better space
    //enumeration constant? i don't think that's even used.

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

typedef { return ( TYPEDEF );}
extern { return ( EXTERN );}
static { return ( STATIC );}
auto { return ( AUTO );}
register { return ( REGISTER );}
char { return ( CHAR );}
short { return ( SHORT );}
int { return ( INT );}
long { return ( LONG );}
signed { return ( SIGNED );}
unsigned { return ( UNSIGNED );}
float { return ( FLOAT );}
double { return ( DOUBLE );}
const { return ( CONST );}
volatile { return ( VOLATILE );}
void { return ( VOID );}
struct { return ( STRUCT );}
union { return ( UNION );}
enum { return ( ENUM );}

case { return ( CASE );}
default { return ( DEFAULT );}
if { return ( IF );}
else { return ( ELSE );}
switch { return ( SWITCH );}
while { return ( WHILE );}
do { return ( DO );}
for { return ( FOR );}
goto { return ( GOTO );}
continue { return ( CONTINUE );}
break { return ( BREAK );}
return { return ( RETURN );}


";" { return (SEMI);}
"{" {
    return (OPENCUR);}
"}" {
    return (CLOSCUR);}
"," { return (COMMA);}
"=" { return (ASSIGN);}
":" { return (COLON);}
"[" { return (OPENSQ);}
"]" { return (CLOSSQ);}
"*" { return (STAR);}
"(" { return (OPENPAR);}
")" { return (CLOSEPAR);}
"?" { return (TERNARY);}
"|" { return (BAR);}
"^" { return (XOR);}
"&" { return (AND);}
"<" { return (LESSTH);}
">" { return (GREATH);}
"+" { return (PLUS);}
"-" { return (MINUS);}
"/" { return (SLASH);}
"%" { return (MODULO);}
"~" { return (TILDE);}
"!" { return (BANG);}
"." { return (PERIOD);}


"..." { return ( ELIPSIS );}

"sizeof"    { return ( SIZEOF );}
"->"    { return ( PTR_OP );}
"++"    { return ( INC_OP );}
"--"    { return ( DEC_OP );}
"<<"    { return ( LEFT_OP );}
">>"    { return ( RIGHT_OP );}
"<="    { return ( LE_OP );}
">="    { return ( GE_OP );}
"=="    { return ( EQ_OP );}
"!="    { return ( NE_OP );}
"&&"    { return ( AND_OP );}
"||"    { return ( OR_OP );}
"*="    { return ( MUL_ASSIGN );}
"/="    { return ( DIV_ASSIGN );}
"%="    { return ( MOD_ASSIGN );}
"+="    { return ( ADD_ASSIGN );}
"-="    { return ( SUB_ASSIGN );}
"<<="   { return ( LEFT_ASSIGN );}
">>="   { return ( RIGHT_ASSIGN );}
"&="    { return ( AND_ASSIGN );}
"^="    { return ( XOR_ASSIGN );}
"|="    { return ( NE_OP );}

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
    return (CHARACTER_CONSTANT); }
{string_literal} {
    char * strstart = yytext+1;
    int len = strlen(strstart);
    strstart[len-1] = '\0';
    cout << len << endl;
    yylval.sval = strstart;
    cout << yylval.sval << endl;
    return (STRING_LITERAL); }
{real} {
    yylval.fval = atof(yytext);
    cout << yylval.fval;
    return (FLOATING_CONSTANT); }
{integer} {
    yylval.ival = atoi(yytext);
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
    cout << symbolTable << endl;
    return ( IDENTIFIER );}

. { cout << "unrecognized!" << endl;
    return (-1);}

%%
/*
int main(){
    FlexLexer* lexer = new yyFlexLexer;
    symbolTable.pushLevel(); //make sure to start with this first level or crash!
    int token = lexer->yylex();
    cout << token;
    return 0;
}*/
