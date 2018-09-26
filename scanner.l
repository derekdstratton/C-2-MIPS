%{
#include <string.h>

//Function declarations


%}

//White space
delim	[ \t\n]
ws	{delim}+

//Numbers
digit	[0-9]
integer	{digit}+

%%

{ws}

//Reserved words and the tokens returned
\typedef { return ( TYPEDEF );}
\extern { return ( EXTERN );}
\static { return ( STATIC );}
\auto { return ( AUTO );}
\register { return ( REGISTER );}
\char { return ( CHAR );}
\short { return ( SHORT );}
\int { return ( INT );}
\long { return ( LONG );}
\signed { return ( SIGNED );}
\unsigned { return ( UNSIGNED );}
\float { return ( FLOAT );}
\double { return ( DOUBLE );}
\const { return ( CONST );}
\volatile { return ( VOLATILE );}
\void { return ( VOID );}
\struct { return ( STRUCT );}
\union { return ( UNION );}
\enum { return ( ENUM );}

\ { return ( CASE );}
\ { return ( DEFAULT );}
\ { return ( IF );}
\ { return ( ELSE );}
\ { return ( SWITCH );}
\ { return ( WHILE );}
\ { return ( DO );}
\ { return ( FOR );}
\ { return ( GOTO );}
\ { return ( CONTINUE );}
\ { return ( BREAK );}
\ { return ( RETURN );}

//these were with other keywords in the yacc file
//but I dont know what they are
\ { return ( ELIPSIS );}
\ { return ( RANGE );}


IDENTIFIER
INTEGER_CONSTANT
FLOATING_CONSTANT
CHARACTER_CONSTANT
ENUMERATION_CONSTANT
STRING_LITERAL
SIZEOF
PTR_OP
INC_OP
DEC_OP
LEFT_OP
RIGHT_OP
LE_OP
GE_OP
EQ_OP
NE_OP
AND_OP
OR_OP
MUL_ASSIGN
DIV_ASSIGN
MOD_ASSIGN
ADD_ASSIGN
SUB_ASSIGN
LEFT_ASSIGN
RIGHT_ASSIGN
AND_ASSIGN
XOR_ASSIGN
OR_ASSIGN
TYPEDEF_NAME



%%

int writeInt(){
  yylval.ival = atoi(yytext);
}
