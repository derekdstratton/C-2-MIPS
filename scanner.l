%{
#include <string.h>

//Function declarations


%}

//White space
//does this need to be restructured so that
// we can have \n by itself to increment line #?
delim	[ \t\n]
ws	{delim}+

//Numbers
digit	[0-9]
integer	{digit}+
floot   [-+]?{digit}*\.{digit}+

//Letters
letter  [a-zA-Z_]

identifier  {letter}({letter | digit}*)

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

\case { return ( CASE );}
\default { return ( DEFAULT );}
\if { return ( IF );}
\else { return ( ELSE );}
\switch { return ( SWITCH );}
\while { return ( WHILE );}
\do { return ( DO );}
\for { return ( FOR );}
\goto { return ( GOTO );}
\continue { return ( CONTINUE );}
\break { return ( BREAK );}
\return { return ( RETURN );}

//these were with other keywords in the yacc file
//but I dont know what they are
"..." { return ( ELIPSIS );}
\ { return ( RANGE );}


IDENTIFIER
INTEGER_CONSTANT
FLOATING_CONSTANT
CHARACTER_CONSTANT
ENUMERATION_CONSTANT
STRING_LITERAL
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
TYPEDEF_NAME



%%

int writeInt(){
  yylval.ival = atoi(yytext);
}
