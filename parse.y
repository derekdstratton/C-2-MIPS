%{

/* Headers */

#include <iostream>
#include <fstream>
#include <cctype>
#include <string>
#include <sstream>
#include <cstdio>
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <string>
#include <deque>

#include "SymbolTable.h"
SymbolTable * table_ptr;

/* Global Variables */

using namespace std;

/* Global Variables */
SymbolTable * table_ptr;

extern deque <char> columnQueue;
string newOutputFile;
extern FILE * yyin;
bool debug[5]; // -d, -l, -s, productions flag, -o
// -d enable debugging
// -l produces a list of tokens and their values to a file
// -s dumps symbol table at key points to a file
// -p prints all productions to a file
// -o name a file to output interspersed reductions to
char* fileName;
void yyerror (char const *s);
void handleProd (string prod);
bool printProd = false;
extern int yyleng;
stringstream prodStream;

/* Function declarations */

int yylex();
%}

%union {
    long ival;
    float fval;
    char cval;
    char * sval;
    //
    void * vval;
}

%code provides {
    // A function that returns a pointer to the table, for communicating with the Scanner
    SymbolTable * getTable();
}

%code {
    /**
     * Returns a pointer to the Symbol Table, accessible for all files including parser.hpp
     */
    SymbolTable * getTable() {
        return table_ptr;
    }
}

%token IDENTIFIER
%token<ival> INTEGER_CONSTANT
%token<fval> FLOATING_CONSTANT
%token<cval> CHARACTER_CONSTANT
%token ENUMERATION_CONSTANT
%token STRING_LITERAL
%token SIZEOF
%token PTR_OP
%token INC_OP DEC_OP
%token LEFT_OP RIGHT_OP
%token LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token TYPEDEF_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELIPSIS RANGE

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token ERROR

%locations
%error-verbose

%token SEMI OPENCUR CLOSCUR COMMA ASSIGN COLON OPENSQ CLOSSQ STAR OPENPAR CLOSEPAR TERNARY
%token BAR XOR AND LESSTH GREATH PLUS MINUS SLASH MODULO TILDE BANG PERIOD NEWLINE

%start translation_unit
%%

translation_unit
	/*: TYPEDEF {handleProd("translation_unit -> TYPEDEF"\n);}*/
	: external_declaration {handleProd("translation_unit -> external_declaration\n");}
	| translation_unit external_declaration {handleProd("translation_unit -> translation_unit external_declaration\n");}
	;

external_declaration
	: function_definition {handleProd("external_declaration -> function_definition\n");}
	| declaration {handleProd("external_declaration -> declaration\n");}
	;

function_definition
	: declarator compound_statement {handleProd("function_definition -> declarator compound_statement\n");}
	| declarator declaration_list compound_statement {handleProd("function_definition -> declarator declaration_list compound_statement\n");}
	| declaration_specifiers declarator compound_statement {handleProd("function_definition -> declaration_specifiers declarator compound_statement\n");}
	| declaration_specifiers declarator declaration_list compound_statement {handleProd("function_definition -> declaration_specifiers declarator declaration_list compound_statement\n");}
	;

declaration
	: declaration_specifiers SEMI {handleProd("declaration -> declaration_specifiers SEMI\n");}
	| declaration_specifiers init_declarator_list SEMI {handleProd("declaration -> declaration_specifiers init_declarator_list SEMI\n");}
	;

declaration_list
	: declaration {handleProd("declaration_list -> declaration\n");}
	| declaration_list declaration {handleProd("declaration_list -> declaration_list declaration\n");}
	;

declaration_specifiers
	: storage_class_specifier {handleProd("declaration_specifiers -> storage_class_specifier\n");}
	| storage_class_specifier declaration_specifiers {handleProd("declaration_specifiers -> storage_class_specifier declaration_specifiers\n");}
	| type_specifier {handleProd("declaration_specifiers -> type_specifier\n");}
	| type_specifier declaration_specifiers {handleProd("declaration_specifiers -> type_specifier declaration_specifiers\n");}
	| type_qualifier {handleProd("declaration_specifiers -> type_qualifier\n");}
	| type_qualifier declaration_specifiers {handleProd("declaration_specifiers -> type_qualifier declaration_specifiers\n");}
	;

storage_class_specifier
	: AUTO {handleProd("storage_class_specifier -> AUTO\n");}
	| REGISTER {handleProd("storage_class_specifier -> REGISTER\n");}
	| STATIC {handleProd("storage_class_specifier -> STATIC\n");}
	| EXTERN {handleProd("storage_class_specifier -> EXTERN\n");}
	| TYPEDEF {handleProd("storage_class_specifier -> TYPEDEF\n");}
	;

type_specifier
	: VOID {handleProd("type_specifier -> VOID\n");}
	| CHAR {handleProd("type_specifier -> CHAR\n");}
	| SHORT {handleProd("type_specifier -> SHORT\n");}
	| INT {handleProd("type_specifier -> INT\n");}
	| LONG {handleProd("type_specifier -> LONG\n");}
	| FLOAT {handleProd("type_specifier -> FLOAT\n");}
	| DOUBLE {handleProd("type_specifier -> DOUBLE\n");}
	| SIGNED {handleProd("type_specifier -> SIGNED\n");}
	| UNSIGNED {handleProd("type_specifier -> UNSIGNED\n");}
	| struct_or_union_specifier {handleProd("type_specifier -> struct_or_union_specifier\n");}
	| enum_specifier {handleProd("type_specifier -> enum_specifier\n");}
	| TYPEDEF_NAME {handleProd("type_specifier -> TYPEDEF_NAME\n");}
	;

type_qualifier
	: CONST {handleProd("type_qualifier -> CONST\n");}
	| VOLATILE {handleProd("type_qualifier -> VOLATILE\n");}
	;

struct_or_union_specifier
	: struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR {handleProd("struct_or_union_specifier -> struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR\n");}
	| struct_or_union OPENCUR struct_declaration_list CLOSCUR {handleProd("struct_or_union_specifier -> struct_or_union OPENCUR struct_declaration_list CLOSCUR\n");}
	| struct_or_union identifier {handleProd("struct_or_union_specifier -> struct_or_union identifier\n");}
	;

struct_or_union
	: STRUCT {handleProd("struct_or_union -> STRUCT\n");}
	| UNION {handleProd("struct_or_union -> UNION\n");}
	;

struct_declaration_list
	: struct_declaration {handleProd("struct_declaration_list -> struct_declaration\n");}
	| struct_declaration_list struct_declaration {handleProd("struct_declaration_list -> struct_declaration_list struct_declaration\n");}
	;

init_declarator_list
	: init_declarator {handleProd("init_declarator_list -> init_declarator\n");}
	| init_declarator_list COMMA init_declarator {handleProd("init_declarator_list -> init_declarator_list COMMA init_declarator\n");}
	;

init_declarator
	: declarator {handleProd("init_declarator -> declarator\n");}
	| declarator ASSIGN initializer {handleProd("init_declarator -> declarator ASSIGN initializer\n");}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMI {handleProd("struct_declaration -> specifier_qualifier_list struct_declarator_list SEMI\n");}
	;

specifier_qualifier_list
	: type_specifier {handleProd("specifier_qualifier_list -> type_specifier\n");}
	| type_specifier specifier_qualifier_list {handleProd("specifier_qualifier_list -> type_specifier specifier_qualifier_list\n");}
	| type_qualifier {handleProd("specifier_qualifier_list -> type_qualifier\n");}
	| type_qualifier specifier_qualifier_list {handleProd("specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n");}
	;

struct_declarator_list
	: struct_declarator {handleProd("struct_declarator_list -> struct_declarator\n");}
	| struct_declarator_list COMMA struct_declarator {handleProd("struct_declarator_list -> struct_declarator_list COMMA struct_declarator\n");}
	;

struct_declarator
	: declarator {handleProd("struct_declarator -> declarator\n");}
	| COLON constant_expression {handleProd("struct_declarator -> COLON constant_expression\n");}
	| declarator COLON constant_expression {handleProd("struct_declarator -> declarator COLON constant_expression\n");}
	;

enum_specifier
	: ENUM OPENCUR enumerator_list CLOSCUR {handleProd("enum_specifier -> ENUM OPENCUR enumerator_list CLOSCUR\n");}
	| ENUM identifier OPENCUR enumerator_list CLOSCUR {handleProd("enum_specifier -> ENUM identifier OPENCUR enumerator_list CLOSCUR\n");}
	| ENUM identifier {handleProd("enum_specifier -> ENUM identifier\n");}
	;

enumerator_list
	: enumerator {handleProd("enumerator_list -> enumerator\n");}
	| enumerator_list COMMA enumerator {handleProd("enumerator_list -> enumerator_list COMMA enumerator\n");}
	;

enumerator
	: identifier {handleProd("enumerator -> identifier\n");}
	| identifier ASSIGN constant_expression {handleProd("enumerator -> identifier ASSIGN constant_expression\n");}
	;

declarator
	: direct_declarator {handleProd("declarator -> direct_declarator\n");}
	| pointer direct_declarator {handleProd("declarator -> pointer direct_declarator\n");}
	;

direct_declarator
	: identifier {handleProd("direct_declarator -> identifier\n");}
	| OPENPAR declarator CLOSEPAR {handleProd("direct_declarator -> OPENPAR declarator CLOSEPAR\n");}
	| direct_declarator OPENSQ CLOSSQ {handleProd("direct_declarator -> direct_declarator OPENSQ CLOSSQ\n");}
	| direct_declarator OPENSQ constant_expression CLOSSQ {handleProd("direct_declarator -> direct_declarator OPENSQ constant_expression CLOSSQ\n");}
	| direct_declarator OPENPAR CLOSEPAR {handleProd("direct_declarator -> direct_declarator OPENPAR CLOSEPAR\n");}
	| direct_declarator OPENPAR parameter_type_list CLOSEPAR {handleProd("direct_declarator -> direct_declarator OPENPAR parameter_type_list CLOSEPAR\n");}
	| direct_declarator OPENPAR identifier_list CLOSEPAR {handleProd("direct_declarator -> direct_declarator OPENPAR identifier_list CLOSEPAR\n");}
	;

pointer
	: STAR {handleProd("pointer -> STAR\n");}
	| STAR type_qualifier_list {handleProd("pointer -> STAR type_qualifier_list\n");}
	| STAR pointer {handleProd("pointer -> STAR pointer\n");}
	| STAR type_qualifier_list pointer {handleProd("pointer -> STAR type_qualifier_list pointer\n");}
	;

type_qualifier_list
	: type_qualifier {handleProd("type_qualifier_list -> type_qualifier\n");}
	;

parameter_type_list
	: parameter_list {handleProd("parameter_type_list -> parameter_list\n");}
	| parameter_list COMMA ELIPSIS {handleProd("parameter_type_list -> parameter_list COMMA ELIPSIS\n");}
	;

parameter_list
	: parameter_declaration {handleProd("parameter_list -> parameter_declaration\n");}
	| parameter_list COMMA parameter_declaration {handleProd("parameter_list -> parameter_list COMMA parameter_declaration\n");}
	;

parameter_declaration
	: declaration_specifiers declarator {handleProd("parameter_declaration -> declaration_specifiers declarator\n");}
	| declaration_specifiers {handleProd("parameter_declaration -> declaration_specifiers\n");}
	| declaration_specifiers abstract_declarator {handleProd("parameter_declaration -> declaration_specifiers abstract_declarator\n");}
	;

identifier_list
	: identifier {handleProd("identifier_list -> identifier\n");}
	| identifier_list COMMA identifier {handleProd("identifier_list -> identifier_list COMMA identifier\n");}
	;

initializer
	: assignment_expression {handleProd("initializer -> assignment_expression\n");}
	| OPENCUR initializer_list CLOSCUR {handleProd("initializer -> OPENCUR initializer_list CLOSCUR\n");}
	| OPENCUR initializer_list COMMA CLOSCUR {handleProd("initializer -> OPENCUR initializer_list COMMA CLOSCUR\n");}
	;

initializer_list
	: initializer {handleProd("initializer_list -> initializer\n");}
	| initializer_list COMMA initializer {handleProd("initializer_list -> initializer_list COMMA initializer\n");}
	;

type_name
	: specifier_qualifier_list {handleProd("type_name -> specifier_qualifier_list\n");}
	| specifier_qualifier_list abstract_declarator {handleProd("type_name -> specifier_qualifier_list abstract_declarator\n");}
	;

abstract_declarator
	: pointer {handleProd("abstract_declarator -> pointer\n");}
	| direct_abstract_declarator {handleProd("abstract_declarator -> direct_abstract_declarator\n");}
	| pointer direct_abstract_declarator {handleProd("abstract_declarator -> pointer direct_abstract_declarator\n");}
	;

direct_abstract_declarator
	: OPENPAR abstract_declarator CLOSEPAR {handleProd("direct_abstract_declarator -> OPENPAR abstract_declarator CLOSEPAR\n");}
	| OPENSQ CLOSSQ {handleProd("direct_abstract_declarator -> OPENSQ CLOSSQ\n");}
	| OPENSQ constant_expression CLOSSQ {handleProd("direct_abstract_declarator -> OPENSQ constant_expression CLOSSQ\n");}
	| direct_abstract_declarator OPENSQ CLOSSQ {handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENSQ CLOSSQ\n");}
	| direct_abstract_declarator OPENSQ constant_expression CLOSSQ {handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENSQ constant_expression CLOSSQ\n");}
	| OPENPAR CLOSEPAR {handleProd("direct_abstract_declarator -> OPENPAR CLOSEPAR\n");}
	| OPENPAR parameter_type_list CLOSEPAR {handleProd("direct_abstract_declarator -> OPENPAR parameter_type_list CLOSEPAR\n");}
	| direct_abstract_declarator OPENPAR CLOSEPAR {handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENPAR CLOSEPAR\n");}
	| direct_abstract_declarator OPENPAR parameter_type_list CLOSEPAR {handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENPAR parameter_type_list\n");}
	;

statement
	: labeled_statement {handleProd("statement -> labeled_statement\n");}
	| compound_statement {handleProd("statement -> compound_statement\n");}
	| expression_statement {handleProd("statement -> expression_statement\n");}
	| selection_statement {handleProd("statement -> selection_statement\n");}
	| iteration_statement {handleProd("statement -> iteration_statement\n");}
	| jump_statement {handleProd("statement -> jump_statement\n");}
	;

labeled_statement
	: identifier COLON statement {handleProd("labeled_statement -> identifier COLON statement\n");}
	| CASE constant_expression COLON statement {handleProd("labeled_statement -> CASE constant_expression COLON statement\n");}
	| DEFAULT COLON statement {handleProd("labeled_statement -> DEFAULT COLON statement\n");}
	;

expression_statement
	: SEMI {handleProd("expression_statement -> SEMI\n");}
	| expression SEMI {handleProd("expression_statement -> expression SEMI\n");}
	;

compound_statement
	: OPENCUR CLOSCUR {handleProd("compound_statement -> OPENCUR CLOSCUR\n");}
	| OPENCUR statement_list CLOSCUR {handleProd("compound_statement -> OPENCUR statement_list CLOSCUR\n");}
	| OPENCUR declaration_list CLOSCUR {handleProd("compound_statement -> OPENCUR declaration_list CLOSCUR\n");}
	| OPENCUR declaration_list statement_list CLOSCUR {handleProd("compound_statement -> OPENCUR declaration_list statement_list CLOSCUR\n");}
	;

statement_list
	: statement {handleProd("statement_list -> statement\n");}
	| statement_list statement {handleProd("statement_list -> statement_list statement\n");}
	;

selection_statement
	: IF OPENPAR expression CLOSEPAR statement {handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement\n");}
	| IF OPENPAR expression CLOSEPAR statement ELSE statement {handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement ELSE statement\n");}
	| SWITCH OPENPAR expression CLOSEPAR statement {handleProd("selection_statement -> SWITCH OPENPAR expression CLOSEPAR statement\n");}
	;

iteration_statement
	: WHILE OPENPAR expression CLOSEPAR statement {handleProd("iteration_statement -> WHILE OPENPAR expression CLOSEPAR statement\n");}
	| DO statement WHILE OPENPAR expression CLOSEPAR SEMI {handleProd("iteration_statement -> DO statement WHILE OPENPAR expression CLOSEPAR SEMI\n");}
	| FOR OPENPAR SEMI SEMI CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI SEMI expression CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement {handleProd("iteration_statement -> FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement\n");}
	;

jump_statement
	: GOTO identifier SEMI {handleProd("jump_statement -> GOTO identifier SEMI\n");}
	| CONTINUE  {handleProd("jump_statement -> CONTINUE \n");}
	| BREAK  {handleProd("jump_statement -> BREAK\n");}
	| RETURN SEMI {handleProd("jump_statement -> RETURN SEMI\n");}
	| RETURN expression SEMI {handleProd("jump_statement -> RETURN expression SEMI\n");}
	;

expression
	: assignment_expression {handleProd("expression -> assignment_expression\n");}
	| expression COMMA assignment_expression {handleProd("expression -> expression COMMA assignment_expression\n");}
	;

assignment_expression
	: conditional_expression {handleProd("assignment_expression -> conditional_expression\n");}
	| unary_expression assignment_operator assignment_expression {handleProd("assignment_expression -> unary_expression assignment_operator assignment_expression\n");}
	;

assignment_operator
	: ASSIGN {handleProd("assignment_operator -> ASSIGN\n");}
	| MUL_ASSIGN {handleProd("assignment_operator -> MUL_ASSIGN\n");}
	| DIV_ASSIGN {handleProd("assignment_operator -> DIV_ASSIGN\n");}
	| MOD_ASSIGN {handleProd("assignment_operator -> MOD_ASSIGN\n");}
	| ADD_ASSIGN {handleProd("assignment_operator -> ADD_ASSIGN\n");}
	| SUB_ASSIGN {handleProd("assignment_operator -> SUB_ASSIGN\n");}
	| LEFT_ASSIGN {handleProd("assignment_operator -> LEFT_ASSIGN\n");}
	| RIGHT_ASSIGN {handleProd("assignment_operator -> RIGHT_ASSIGN\n");}
	| AND_ASSIGN {handleProd("assignment_operator -> AND_ASSIGN\n");}
	| XOR_ASSIGN {handleProd("assignment_operator -> XOR_ASSIGN\n");}
	| OR_ASSIGN {handleProd("assignment_operator -> OR_ASSIGN\n");}
	;

conditional_expression
	: logical_or_expression {handleProd("conditional_expression -> logical_or_expression\n");}
	| logical_or_expression TERNARY expression COLON conditional_expression {handleProd("conditional_expression -> logical_or_expression TERNARY expression COLON conditional_expression \n");}
	;

constant_expression
	: conditional_expression {handleProd("constant_expression -> conditional_expression\n");}
	;

logical_or_expression
	: logical_and_expression {handleProd("logical_or_expression -> logical_and_expression\n");}
	| logical_or_expression OR_OP logical_and_expression {handleProd("logical_or_expression -> logical_or_expression OR_OP logical_and_expression\n");}
	;

logical_and_expression
	: inclusive_or_expression {handleProd("logical_and_expression -> inclusive_or_expression\n");}
	| logical_and_expression AND_OP inclusive_or_expression {handleProd("logical_and_expression -> logical_and_expression AND_OP inclusive_or_expression\n");}
	;

inclusive_or_expression
	: exclusive_or_expression {handleProd("inclusive_or_expression -> exclusive_or_expression\n");}
	| inclusive_or_expression BAR exclusive_or_expression {handleProd("inclusive_or_expression -> inclusive_or_expression BAR exclusive_or_expression\n");}
	;

exclusive_or_expression
	: and_expression {handleProd("exclusive_or_expression -> and_expression\n");}
	| exclusive_or_expression XOR and_expression {handleProd("exclusive_or_expression -> exclusive_or_expression XOR and_expression\n");}
	;

and_expression
	: equality_expression {handleProd("and_expression -> equality_expression\n");}
	| and_expression AND equality_expression {handleProd("and_expression -> and_expression AND equality_expression\n");}
	;

equality_expression
	: relational_expression {handleProd("equality_expression -> relational_expression\n");}
	| equality_expression EQ_OP relational_expression {handleProd("equality_expression -> equality_expression EQ_OP relational_expression\n");}
	| equality_expression NE_OP relational_expression {handleProd("equality_expression -> equality_expression NE_OP relational_expression\n");}
	;

relational_expression
	: shift_expression {handleProd("relational_expression -> shift_expression\n");}
	| relational_expression LESSTH shift_expression {handleProd("relational_expression -> relational_expression LESSTH shift_expression\n");}
	| relational_expression GREATH shift_expression {handleProd("relational_expression -> relational_expression GREATH shift_expression\n");}
	| relational_expression LE_OP shift_expression {handleProd("relational_expression -> relational_expression LE_OP shift_expression\n");}
	| relational_expression GE_OP shift_expression {handleProd("relational_expression -> relational_expression GE_OP shift_expression\n");}
	;

shift_expression
	: additive_expression {handleProd("shift_expression -> additive_expression\n");}
	| shift_expression LEFT_OP additive_expression {handleProd("shift_expression -> shift_expression LEFT_OP additive_expression\n");}
	| shift_expression RIGHT_OP additive_expression {handleProd("shift_expression -> shift_expression RIGHT_OP additive_expression\n");}
	;

additive_expression
	: multiplicative_expression {handleProd("additive_expression -> multiplicative_expression\n");}
	| additive_expression PLUS multiplicative_expression {handleProd("additive_expression -> additive_expression PLUS multiplicative_expression\n");}
	| additive_expression MINUS multiplicative_expression {handleProd("additive_expression -> additive_expression MINUS multiplicative_expression\n");}
	;

multiplicative_expression
	: cast_expression {handleProd("multiplicative_expression -> cast_expression\n");}
	| multiplicative_expression STAR cast_expression {handleProd("multiplicative_expression -> multiplicative_expression STAR cast_expression\n");}
	| multiplicative_expression SLASH cast_expression {handleProd("multiplicative_expression -> multiplicative_expression SLASH cast_expression\n");}
	| multiplicative_expression MODULO cast_expression {handleProd("multiplicative_expression -> multiplicative_expression MODULO cast_expression\n");}
	;

cast_expression
	: unary_expression {handleProd("cast_expression -> unary_expression\n");}
	| OPENPAR type_name CLOSEPAR cast_expression {handleProd("cast_expression -> OPENPAR type_name CLOSEPAR cast_expression\n");}
	;

unary_expression
	: postfix_expression {handleProd("unary_expression -> postfix_expression\n");}
	| INC_OP unary_expression {handleProd("unary_expression -> INC_OP unary_expression\n");}
	| DEC_OP unary_expression {handleProd("unary_expression -> DEC_OP unary_expression\n");}
	| unary_operator cast_expression {handleProd("unary_expression -> unary_operator cast_expression\n");}
	| SIZEOF unary_expression {handleProd("unary_expression -> SIZEOF unary_expression\n");}
	| SIZEOF OPENPAR type_name CLOSEPAR {handleProd("unary_expression -> SIZEOF OPENPAR type_name CLOSEPAR\n");}
	;

unary_operator
	: AND {handleProd("unary_operator -> AND\n");}
	| STAR {handleProd("unary_operator -> STAR\n");}
	| PLUS {handleProd("unary_operator -> PLUS\n");}
	| MINUS {handleProd("unary_operator -> MINUS\n");}
	| TILDE {handleProd("unary_operator -> TILDE\n");}
	| BANG {handleProd("unary_operator -> BANG\n");}
	;

postfix_expression
	: primary_expression {handleProd("postfix_expression -> primary_expression\n");}
	| postfix_expression OPENSQ expression CLOSSQ {handleProd("postfix_expression -> postfix_expression OPENSQ expression CLOSSQ\n");}
	| postfix_expression OPENPAR CLOSEPAR {handleProd("postfix_expression -> postfix_expression OPENPAR CLOSEPAR\n");}
	| postfix_expression OPENPAR argument_expression_list CLOSEPAR {handleProd("postfix_expression -> postfix_expression OPENPAR argument_expression_list CLOSEPAR\n");}
	| postfix_expression PERIOD identifier {handleProd("postfix_expression -> postfix_expression PERIOD identifier\n");}
	| postfix_expression PTR_OP identifier {handleProd("postfix_expression -> postfix_expression PTR_OP identifier\n");}
	| postfix_expression INC_OP {handleProd("postfix_expression -> postfix_expression INC_OP\n");}
	| postfix_expression DEC_OP {handleProd("postfix_expression -> postfix_expression DEC_OP\n");}
	;

primary_expression
	: identifier {handleProd("primary_expression -> identifier\n");}
	| constant {handleProd("primary_expression -> constant\n");}
	| string {handleProd("primary_expression -> string\n");}
	| OPENPAR expression CLOSEPAR {handleProd("primary_expression -> OPENPAR expression CLOSEPAR\n");}
	;

argument_expression_list
	: assignment_expression {handleProd("argument_expression_list -> assignment_expression\n");}
	| argument_expression_list COMMA assignment_expression {handleProd("argument_expression_list -> argument_expression_list COMMA assignment_expression\n");}
	;

constant
	: INTEGER_CONSTANT {handleProd("constant -> INTEGER_CONSTANT\n");}
	| CHARACTER_CONSTANT {handleProd("constant -> CHARACTER_CONSTANT\n");}
	| FLOATING_CONSTANT {handleProd("constant -> FLOATING_CONSTANT\n");}
	| ENUMERATION_CONSTANT {handleProd("constant -> ENUMERATION_CONSTANT\n");}
	;

string
	: STRING_LITERAL {handleProd("string -> STRING_LITERAL\n");}
	;

identifier
	: IDENTIFIER {handleProd("identifier -> IDENTIFIER\n");}
	;
%%

/**
 * @brief The yyerror function is a default yacc function that is called whenever
 *        bison cannot match a production.
 * @details yyerror prints out the type of error followed with the
 * @param s is the type of error that bison detects.
 */
extern int column;

/** error function called when parsing fails, prints error to stderr stream thingy
 *
 * @param s the error string to be output
 */
void yyerror (char const* s)
{
    ifstream errInput;
    string currentLine;
    errInput.open(fileName);
    for(int i = 0; i < yylloc.first_line - 1; i++)
        getline(errInput, currentLine);

    deque <char> errQueue;
    while(errInput.peek() != '\n')
        errQueue.push_back(errInput.get());

    while(!errQueue.empty()) {
        cerr << errQueue.front();
        errQueue.pop_front();
    }
    cerr << endl;

    for(int i = 0; i < yyleng; i++)
        columnQueue.pop_back();

    int columnNum = columnQueue.size();
    while(!columnQueue.empty()) {
        if(columnQueue.front() == '\t')
            cerr << columnQueue.front();
        else
            cerr << ' ';

        columnQueue.pop_front();
    }
        cerr << "^ " << "\n";

    cerr << s << " on line " << yylloc.first_line << " (column " << columnNum + 1 << ")" << endl;
	return;
}

/**
 * this function handles outputting of the productions
 * @param prod the production handled
 */
void handleProd (string prod)
{
    if(debug[3])
    {
        prodStream << prod;
    }
    ofstream pStream;

    if(debug[4])
        pStream.open(newOutputFile, ios::app);
    else
        pStream.open("list_file", ios::app);

    pStream << prod;
}

//The entry point to the ScannerParser
int main(int argc, char **argv)
{
    SymbolTable symbolTable;
    table_ptr = &symbolTable;
    for(int i = 0; i < 5; i++) //initialize all debug options to false
        debug[i] = false;
    debug[3] = true;
    if(argc > 1)
    {
        for(int i = 1; i < argc; i++)
            {
                string buffer = argv[i];
                if(buffer[0] == '-')
                {
                    if(strcmp(argv[i],"-d") == 0)
                        debug[0] = true;
                    else if(strcmp(argv[i],"-l") == 0)
                        debug[1] = true;
                    else if(strcmp(argv[i],"-s") == 0)
                        debug[2] = true;
                    else if(strcmp(argv[i],"-p") == 0)
                        printProd = true;
                    else if(strcmp(argv[i],"-o") == 0)
                    {
                        debug[4] = true;
                        newOutputFile = argv[i+1];
                        i++;
                    }
                    else
                        cout << argv[1] << " is not a valid command line argument." << endl;
                }
                else
                {
                    yyin = fopen(argv[argc - 1], "r");
                         if ( !yyin )
                         {
                             cout << "Opening file unsuccessful, aborting." << endl;
                             return(-1);
                         }
                         else
                                     fileName = argv[argc - 1];
                }
            }

    }

    if(debug[4])
    {
        ofstream ofs;
        ofs.open(newOutputFile, std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }
    else
    {
        ofstream ofs;
        ofs.open("list_file", std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }

    if(debug[1] && debug[0])
    {
        ofstream ofs;
        ofs.open("tokens.out", std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }
    if(debug[2] && debug[0])
    {
        ofstream ofs;
        ofs.open("SymDump.out", std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }
	yyparse();
    if(printProd)
    {
        ofstream ofs;
        ofs.open("productions.out", std::ofstream::out | std::ofstream::trunc);
        ofs << prodStream.str();
        ofs.close();
    }
	return 0;
}

