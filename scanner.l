%{
#include <string>
#include <iostream>
#include "parse.tab.h"
/*Function declarations*/

%}
%option c++
%option noyywrap

/*White space*/
delim	[ \t\n]
ws	{delim}+

/*Numbers*/
digit	[0-9]
integer	{digit}+

%%

{ws}

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
"{" { return (OPENCUR);}
"}" { return (CLOSCUR);}
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

%%
using namespace std;

int main(){
    FlexLexer* lexer = new yyFlexLexer;
    int token = lexer->yylex();
    cout << token;
    return 0;
}
