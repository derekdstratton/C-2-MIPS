
%{
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
//TODO continue parsing after error happens, use 'error' token or yyerrok
//TODO add in debug option to turn off/on all productions
#include "SymbolTable.h"
SymbolTable * table_ptr;

using namespace std;

extern FILE * yyin;
bool debug[4]; // -d, -l, -s, -o
char* fileName;
void yyerror (char const *s);
int yylex();
stringstream prodStream;
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
    //void apple();
    SymbolTable * getTable();
}

%code {
    //void apple() { cout << "APPLE SALAD BURRITO";}
    SymbolTable * getTable() {
        return table_ptr;
    }
};

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

//user defined tokens
/*
IDENTIFIER
INTEGER_CONSTANT
FLOATING_CONSTANT
CHARACTER_CONSTANT
ENUMERATION_CONSTANT
STRING_LITERAL
OR_ASSIGN
TYPEDEF_NAME
*/

%token SEMI OPENCUR CLOSCUR COMMA ASSIGN COLON OPENSQ CLOSSQ STAR OPENPAR CLOSEPAR TERNARY
%token BAR XOR AND LESSTH GREATH PLUS MINUS SLASH MODULO TILDE BANG PERIOD NEWLINE

%start translation_unit
%%

translation_unit
	/*: TYPEDEF {prodStream << "translation_unit -> TYPEDEF";}*/
	: external_declaration {prodStream << "translation_unit -> external_declaration\n";}
	| translation_unit external_declaration {prodStream << "translation_unit -> translation_unit external_declaration\n";}
	;

external_declaration
	: function_definition {prodStream << "external_declaration -> function_definition\n";}
	| declaration {prodStream << "external_declaration -> declaration\n";}
	;

function_definition
	: declarator compound_statement {prodStream << "function_definition -> declarator compound_statement\n";}
	| declarator declaration_list compound_statement {prodStream << "function_definition -> declarator declaration_list compound_statement\n";}
	| declaration_specifiers declarator compound_statement {prodStream << "function_definition -> declaration_specifiers declarator compound_statement\n";}
	| declaration_specifiers declarator declaration_list compound_statement {prodStream << "function_definition -> declaration_specifiers declarator declaration_list compound_statement\n";}
	;

declaration
	: declaration_specifiers SEMI {prodStream << "declaration -> declaration_specifiers SEMI\n";}
	| declaration_specifiers init_declarator_list SEMI {prodStream << "declaration -> declaration_specifiers init_declarator_list SEMI\n";}
	;

declaration_list
	: declaration {prodStream << "declaration_list -> declaration\n";}
	| declaration_list declaration {prodStream << "declaration_list -> declaration_list declaration\n";}
	;

declaration_specifiers
	: storage_class_specifier {prodStream << "declaration_specifiers -> storage_class_specifier\n";}
	| storage_class_specifier declaration_specifiers {prodStream << "declaration_specifiers -> storage_class_specifier declaration_specifiers\n";}
	| type_specifier {prodStream << "declaration_specifiers -> type_specifier\n";}
	| type_specifier declaration_specifiers {prodStream << "declaration_specifiers -> type_specifier declaration_specifiers\n";}
	| type_qualifier {prodStream << "declaration_specifiers -> type_qualifier\n";}
	| type_qualifier declaration_specifiers {prodStream << "declaration_specifiers -> type_qualifier declaration_specifiers\n";}
	;

storage_class_specifier
	: AUTO {prodStream << "storage_class_specifier -> AUTO\n";}
	| REGISTER {prodStream << "storage_class_specifier -> REGISTER\n";}
	| STATIC {prodStream << "storage_class_specifier -> STATIC\n";}
	| EXTERN {prodStream << "storage_class_specifier -> EXTERN\n";}
	| TYPEDEF {prodStream << "storage_class_specifier -> TYPEDEF\n";}
	;

type_specifier
	: VOID {prodStream << "type_specifier -> VOID\n";}
	| CHAR {prodStream << "type_specifier -> CHAR\n";}
	| SHORT {prodStream << "type_specifier -> SHORT\n";}
	| INT {prodStream << "type_specifier -> INT\n";}
	| LONG {prodStream << "type_specifier -> LONG\n";}
	| FLOAT {prodStream << "type_specifier -> FLOAT\n";}
	| DOUBLE {prodStream << "type_specifier -> DOUBLE\n";}
	| SIGNED {prodStream << "type_specifier -> SIGNED\n";}
	| UNSIGNED {prodStream << "type_specifier -> UNSIGNED\n";}
	| struct_or_union_specifier {prodStream << "type_specifier -> struct_or_union_specifier\n";}
	| enum_specifier {prodStream << "type_specifier -> enum_specifier\n";}
	| TYPEDEF_NAME {prodStream << "type_specifier -> TYPEDEF_NAME\n";}
	;

type_qualifier
	: CONST {prodStream << "type_qualifier -> CONST\n";}
	| VOLATILE {prodStream << "type_qualifier -> VOLATILE\n";}
	;

struct_or_union_specifier
	: struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR {prodStream << "struct_or_union_specifier -> struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR\n";}
	| struct_or_union OPENCUR struct_declaration_list CLOSCUR {prodStream << "struct_or_union_specifier -> struct_or_union OPENCUR struct_declaration_list CLOSCUR\n";}
	| struct_or_union identifier {prodStream << "struct_or_union_specifier -> struct_or_union identifier\n";}
	;

struct_or_union
	: STRUCT {prodStream << "struct_or_union -> STRUCT\n";}
	| UNION {prodStream << "struct_or_union -> UNION\n";}
	;

struct_declaration_list
	: struct_declaration {prodStream << "struct_declaration_list -> struct_declaration\n";}
	| struct_declaration_list struct_declaration {prodStream << "struct_declaration_list -> struct_declaration_list struct_declaration\n";}
	;

init_declarator_list
	: init_declarator {prodStream << "init_declarator_list -> init_declarator\n";}
	| init_declarator_list COMMA init_declarator {prodStream << "init_declarator_list -> init_declarator_list COMMA init_declarator\n";}
	;

init_declarator
	: declarator {prodStream << "init_declarator -> declarator\n";}
	| declarator ASSIGN initializer {prodStream << "init_declarator -> declarator ASSIGN initializer\n";}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMI {prodStream << "struct_declaration -> specifier_qualifier_list struct_declarator_list SEMI\n";}
	;

specifier_qualifier_list
	: type_specifier {prodStream << "specifier_qualifier_list -> type_specifier\n";}
	| type_specifier specifier_qualifier_list {prodStream << "specifier_qualifier_list -> type_specifier specifier_qualifier_list\n";}
	| type_qualifier {prodStream << "specifier_qualifier_list -> type_qualifier\n";}
	| type_qualifier specifier_qualifier_list {prodStream << "specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n";}
	;

struct_declarator_list
	: struct_declarator {prodStream << "struct_declarator_list -> struct_declarator\n";}
	| struct_declarator_list COMMA struct_declarator {prodStream << "struct_declarator_list -> struct_declarator_list COMMA struct_declarator\n";}
	;

struct_declarator
	: declarator {prodStream << "struct_declarator -> declarator\n";}
	| COLON constant_expression {prodStream << "struct_declarator -> COLON constant_expression\n";}
	| declarator COLON constant_expression {prodStream << "struct_declarator -> declarator COLON constant_expression\n";}
	;

enum_specifier
	: ENUM OPENCUR enumerator_list CLOSCUR {prodStream << "enum_specifier -> ENUM OPENCUR enumerator_list CLOSCUR\n";}
	| ENUM identifier OPENCUR enumerator_list CLOSCUR {prodStream << "enum_specifier -> ENUM identifier OPENCUR enumerator_list CLOSCUR\n";}
	| ENUM identifier {prodStream << "enum_specifier -> ENUM identifier\n";}
	;

enumerator_list
	: enumerator {prodStream << "enumerator_list -> enumerator\n";}
	| enumerator_list COMMA enumerator {prodStream << "enumerator_list -> enumerator_list COMMA enumerator\n";}
	;

enumerator
	: identifier {prodStream << "enumerator -> identifier\n";}
	| identifier ASSIGN constant_expression {prodStream << "enumerator -> identifier ASSIGN constant_expression\n";}
	;

declarator
	: direct_declarator {prodStream << "declarator -> direct_declarator\n";}
	| pointer direct_declarator {prodStream << "declarator -> pointer direct_declarator\n";}
	;

direct_declarator
	: identifier {prodStream << "direct_declarator -> identifier\n";}
	| OPENPAR declarator CLOSEPAR {prodStream << "direct_declarator -> OPENPAR declarator CLOSEPAR\n";}
	| direct_declarator OPENSQ CLOSSQ {prodStream << "direct_declarator -> direct_declarator OPENSQ CLOSSQ\n";}
	| direct_declarator OPENSQ constant_expression CLOSSQ {prodStream << "direct_declarator -> direct_declarator OPENSQ constant_expression CLOSSQ\n";}
	| direct_declarator OPENPAR CLOSEPAR {prodStream << "direct_declarator -> direct_declarator OPENPAR CLOSEPAR\n";}
	| direct_declarator OPENPAR parameter_type_list CLOSEPAR {prodStream << "direct_declarator -> direct_declarator OPENPAR parameter_type_list CLOSEPAR\n";}
	| direct_declarator OPENPAR identifier_list CLOSEPAR {prodStream << "direct_declarator -> direct_declarator OPENPAR identifier_list CLOSEPAR\n";}
	;

pointer
	: STAR {prodStream << "pointer -> STAR\n";}
	| STAR type_qualifier_list {prodStream << "pointer -> STAR type_qualifier_list\n";}
	| STAR pointer {prodStream << "pointer -> STAR pointer\n";}
	| STAR type_qualifier_list pointer {prodStream << "pointer -> STAR type_qualifier_list pointer\n";}
	;

type_qualifier_list
	: type_qualifier {prodStream << "type_qualifier_list -> type_qualifier\n";}
	;

parameter_type_list
	: parameter_list {prodStream << "parameter_type_list -> parameter_list\n";}
	| parameter_list COMMA ELIPSIS {prodStream << "parameter_type_list -> parameter_list COMMA ELIPSIS\n";}
	;

parameter_list
	: parameter_declaration {prodStream << "parameter_list -> parameter_declaration\n";}
	| parameter_list COMMA parameter_declaration {prodStream << "parameter_list -> parameter_list COMMA parameter_declaration\n";}
	;

parameter_declaration
	: declaration_specifiers declarator {prodStream << "parameter_declaration -> declaration_specifiers declarator\n";}
	| declaration_specifiers {prodStream << "parameter_declaration -> declaration_specifiers\n";}
	| declaration_specifiers abstract_declarator {prodStream << "parameter_declaration -> declaration_specifiers abstract_declarator\n";}
	;

identifier_list
	: identifier {prodStream << "identifier_list -> identifier\n";}
	| identifier_list COMMA identifier {prodStream << "identifier_list -> identifier_list COMMA identifier\n";}
	;

initializer
	: assignment_expression {prodStream << "initializer -> assignment_expression\n";}
	| OPENCUR initializer_list CLOSCUR {prodStream << "initializer -> OPENCUR initializer_list CLOSCUR\n";}
	| OPENCUR initializer_list COMMA CLOSCUR {prodStream << "initializer -> OPENCUR initializer_list COMMA CLOSCUR\n";}
	;

initializer_list
	: initializer {prodStream << "initializer_list -> initializer\n";}
	| initializer_list COMMA initializer {prodStream << "initializer_list -> initializer_list COMMA initializer\n";}
	;

type_name
	: specifier_qualifier_list {prodStream << "type_name -> specifier_qualifier_list\n";}
	| specifier_qualifier_list abstract_declarator {prodStream << "type_name -> specifier_qualifier_list abstract_declarator\n";}
	;

abstract_declarator
	: pointer {prodStream << "abstract_declarator -> pointer\n";}
	| direct_abstract_declarator {prodStream << "abstract_declarator -> direct_abstract_declarator\n";}
	| pointer direct_abstract_declarator {prodStream << "abstract_declarator -> pointer direct_abstract_declarator\n";}
	;

direct_abstract_declarator
	: OPENPAR abstract_declarator CLOSEPAR {prodStream << "direct_abstract_declarator -> OPENPAR abstract_declarator CLOSEPAR\n";}
	| OPENSQ CLOSSQ {prodStream << "direct_abstract_declarator -> OPENSQ CLOSSQ\n";}
	| OPENSQ constant_expression CLOSSQ {prodStream << "direct_abstract_declarator -> OPENSQ constant_expression CLOSSQ\n";}
	| direct_abstract_declarator OPENSQ CLOSSQ {prodStream << "direct_abstract_declarator -> direct_abstract_declarator OPENSQ CLOSSQ\n";}
	| direct_abstract_declarator OPENSQ constant_expression CLOSSQ {prodStream << "direct_abstract_declarator -> direct_abstract_declarator OPENSQ constant_expression CLOSSQ\n";}
	| OPENPAR CLOSEPAR {prodStream << "direct_abstract_declarator -> OPENPAR CLOSEPAR\n";}
	| OPENPAR parameter_type_list CLOSEPAR {prodStream << "direct_abstract_declarator -> OPENPAR parameter_type_list CLOSEPAR\n";}
	| direct_abstract_declarator OPENPAR CLOSEPAR {prodStream << "direct_abstract_declarator -> direct_abstract_declarator OPENPAR CLOSEPAR\n";}
	| direct_abstract_declarator OPENPAR parameter_type_list CLOSEPAR {prodStream << "direct_abstract_declarator -> direct_abstract_declarator OPENPAR parameter_type_list\n";}
	;

statement
	: labeled_statement {prodStream << "statement -> labeled_statement\n";}
	| compound_statement {prodStream << "statement -> compound_statement\n";}
	| expression_statement {prodStream << "statement -> expression_statement\n";}
	| selection_statement {prodStream << "statement -> selection_statement\n";}
	| iteration_statement {prodStream << "statement -> iteration_statement\n";}
	| jump_statement {prodStream << "statement -> jump_statement\n";}
	;

labeled_statement
	: identifier COLON statement {prodStream << "labeled_statement -> identifier COLON statement\n";}
	| CASE constant_expression COLON statement {prodStream << "labeled_statement -> CASE constant_expression COLON statement\n";}
	| DEFAULT COLON statement {prodStream << "labeled_statement -> DEFAULT COLON statement\n";}
	;

expression_statement
	: SEMI {prodStream << "expression_statement -> SEMI\n";}
	| expression SEMI {prodStream << "expression_statement -> expression SEMI\n";}
	;

compound_statement
	: OPENCUR CLOSCUR {prodStream << "compound_statement -> OPENCUR CLOSCUR\n";}
	| OPENCUR statement_list CLOSCUR {prodStream << "compound_statement -> OPENCUR statement_list CLOSCUR\n";}
	| OPENCUR declaration_list CLOSCUR {prodStream << "compound_statement -> OPENCUR declaration_list CLOSCUR\n";}
	| OPENCUR declaration_list statement_list CLOSCUR {prodStream << "compound_statement -> OPENCUR declaration_list statement_list CLOSCUR\n";}
	;

statement_list
	: statement {prodStream << "statement_list -> statement\n";}
	| statement_list statement {prodStream << "statement_list -> statement_list statement\n";}
	;

selection_statement
	: IF OPENPAR expression CLOSEPAR statement {prodStream << "selection_statement -> IF OPENPAR expression CLOSEPAR statement\n";}
	| IF OPENPAR expression CLOSEPAR statement ELSE statement {prodStream << "selection_statement -> IF OPENPAR expression CLOSEPAR statement ELSE statement\n";}
	| SWITCH OPENPAR expression CLOSEPAR statement {prodStream << "selection_statement -> SWITCH OPENPAR expression CLOSEPAR statement\n";}
	;

iteration_statement
	: WHILE OPENPAR expression CLOSEPAR statement {prodStream << "iteration_statement -> WHILE OPENPAR expression CLOSEPAR statement\n";}
	| DO statement WHILE OPENPAR expression CLOSEPAR SEMI {prodStream << "iteration_statement -> DO statement WHILE OPENPAR expression CLOSEPAR SEMI\n";}
	| FOR OPENPAR SEMI SEMI CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR SEMI SEMI CLOSEPAR statement\n";}
	| FOR OPENPAR SEMI SEMI expression CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR SEMI SEMI expression CLOSEPAR statement\n";}
	| FOR OPENPAR SEMI expression SEMI CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR SEMI expression SEMI CLOSEPAR statement\n";}
	| FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement\n";}
	| FOR OPENPAR expression SEMI SEMI CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR expression SEMI SEMI CLOSEPAR statement\n";}
	| FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement\n";}
	| FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement\n";}
	| FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement {prodStream << "iteration_statement -> FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement\n";}
	;

jump_statement
	: GOTO identifier SEMI {prodStream << "jump_statement -> GOTO identifier SEMI\n";}
	| CONTINUE  {prodStream << "jump_statement -> CONTINUE \n";}
	| BREAK  {prodStream << "jump_statement -> BREAK\n";}
	| RETURN SEMI {prodStream << "jump_statement -> RETURN SEMI\n";}
	| RETURN expression SEMI {prodStream << "jump_statement -> RETURN expression SEMI\n";}
	;

expression
	: assignment_expression {prodStream << "expression -> assignment_expression\n";}
	| expression COMMA assignment_expression {prodStream << "expression -> expression COMMA assignment_expression\n";}
	;

assignment_expression
	: conditional_expression {prodStream << "assignment_expression -> conditional_expression\n";}
	| unary_expression assignment_operator assignment_expression {prodStream << "assignment_expression -> unary_expression assignment_operator assignment_expression\n";}
	;

assignment_operator
	: ASSIGN {prodStream << "assignment_operator -> ASSIGN\n";}
	| MUL_ASSIGN {prodStream << "assignment_operator -> MUL_ASSIGN\n";}
	| DIV_ASSIGN {prodStream << "assignment_operator -> DIV_ASSIGN\n";}
	| MOD_ASSIGN {prodStream << "assignment_operator -> MOD_ASSIGN\n";}
	| ADD_ASSIGN {prodStream << "assignment_operator -> ADD_ASSIGN\n";}
	| SUB_ASSIGN {prodStream << "assignment_operator -> SUB_ASSIGN\n";}
	| LEFT_ASSIGN {prodStream << "assignment_operator -> LEFT_ASSIGN\n";}
	| RIGHT_ASSIGN {prodStream << "assignment_operator -> RIGHT_ASSIGN\n";}
	| AND_ASSIGN {prodStream << "assignment_operator -> AND_ASSIGN\n";}
	| XOR_ASSIGN {prodStream << "assignment_operator -> XOR_ASSIGN\n";}
	| OR_ASSIGN {prodStream << "assignment_operator -> OR_ASSIGN\n";}
	;

conditional_expression
	: logical_or_expression {prodStream << "conditional_expression -> logical_or_expression\n";}
	| logical_or_expression TERNARY expression COLON conditional_expression {prodStream << "conditional_expression -> logical_or_expression TERNARY expression COLON conditional_expression \n";}
	;

constant_expression
	: conditional_expression {prodStream << "constant_expression -> conditional_expression\n";}
	;

logical_or_expression
	: logical_and_expression {prodStream << "logical_or_expression -> logical_and_expression\n";}
	| logical_or_expression OR_OP logical_and_expression {prodStream << "logical_or_expression -> logical_or_expression OR_OP logical_and_expression\n";}
	;

logical_and_expression
	: inclusive_or_expression {prodStream << "logical_and_expression -> inclusive_or_expression\n";}
	| logical_and_expression AND_OP inclusive_or_expression {prodStream << "logical_and_expression -> logical_and_expression AND_OP inclusive_or_expression\n";}
	;

inclusive_or_expression
	: exclusive_or_expression {prodStream << "inclusive_or_expression -> exclusive_or_expression\n";}
	| inclusive_or_expression BAR exclusive_or_expression {prodStream << "inclusive_or_expression -> inclusive_or_expression BAR exclusive_or_expression\n";}
	;

exclusive_or_expression
	: and_expression {prodStream << "exclusive_or_expression -> and_expression\n";}
	| exclusive_or_expression XOR and_expression {prodStream << "exclusive_or_expression -> exclusive_or_expression XOR and_expression\n";}
	;

and_expression
	: equality_expression {prodStream << "and_expression -> equality_expression\n";}
	| and_expression AND equality_expression {prodStream << "and_expression -> and_expression AND equality_expression\n";}
	;

equality_expression
	: relational_expression {prodStream << "equality_expression -> relational_expression\n";}
	| equality_expression EQ_OP relational_expression {prodStream << "equality_expression -> equality_expression EQ_OP relational_expression\n";}
	| equality_expression NE_OP relational_expression {prodStream << "equality_expression -> equality_expression NE_OP relational_expression\n";}
	;

relational_expression
	: shift_expression {prodStream << "relational_expression -> shift_expression\n";}
	| relational_expression LESSTH shift_expression {prodStream << "relational_expression -> relational_expression LESSTH shift_expression\n";}
	| relational_expression GREATH shift_expression {prodStream << "relational_expression -> relational_expression GREATH shift_expression\n";}
	| relational_expression LE_OP shift_expression {prodStream << "relational_expression -> relational_expression LE_OP shift_expression\n";}
	| relational_expression GE_OP shift_expression {prodStream << "relational_expression -> relational_expression GE_OP shift_expression\n";}
	;

shift_expression
	: additive_expression {prodStream << "shift_expression -> additive_expression\n";}
	| shift_expression LEFT_OP additive_expression {prodStream << "shift_expression -> shift_expression LEFT_OP additive_expression\n";}
	| shift_expression RIGHT_OP additive_expression {prodStream << "shift_expression -> shift_expression RIGHT_OP additive_expression\n";}
	;

additive_expression
	: multiplicative_expression {prodStream << "additive_expression -> multiplicative_expression\n";}
	| additive_expression PLUS multiplicative_expression {prodStream << "additive_expression -> additive_expression PLUS multiplicative_expression\n";}
	| additive_expression MINUS multiplicative_expression {prodStream << "additive_expression -> additive_expression MINUS multiplicative_expression\n";}
	;

multiplicative_expression
	: cast_expression {prodStream << "multiplicative_expression -> cast_expression\n";}
	| multiplicative_expression STAR cast_expression {prodStream << "multiplicative_expression -> multiplicative_expression STAR cast_expression\n";}
	| multiplicative_expression SLASH cast_expression {prodStream << "multiplicative_expression -> multiplicative_expression SLASH cast_expression\n";}
	| multiplicative_expression MODULO cast_expression {prodStream << "multiplicative_expression -> multiplicative_expression MODULO cast_expression\n";}
	;

cast_expression
	: unary_expression {prodStream << "cast_expression -> unary_expression\n";}
	| OPENPAR type_name CLOSEPAR cast_expression {prodStream << "cast_expression -> OPENPAR type_name CLOSEPAR cast_expression\n";}
	;

unary_expression
	: postfix_expression {prodStream << "unary_expression -> postfix_expression\n";}
	| INC_OP unary_expression {prodStream << "unary_expression -> INC_OP unary_expression\n";}
	| DEC_OP unary_expression {prodStream << "unary_expression -> DEC_OP unary_expression\n";}
	| unary_operator cast_expression {prodStream << "unary_expression -> unary_operator cast_expression\n";}
	| SIZEOF unary_expression {prodStream << "unary_expression -> SIZEOF unary_expression\n";}
	| SIZEOF OPENPAR type_name CLOSEPAR {prodStream << "unary_expression -> SIZEOF OPENPAR type_name CLOSEPAR\n";}
	;

unary_operator
	: AND {prodStream << "unary_operator -> AND\n";}
	| STAR {prodStream << "unary_operator -> STAR\n";}
	| PLUS {prodStream << "unary_operator -> PLUS\n";}
	| MINUS {prodStream << "unary_operator -> MINUS\n";}
	| TILDE {prodStream << "unary_operator -> TILDE\n";}
	| BANG {prodStream << "unary_operator -> BANG\n";}
	;

postfix_expression
	: primary_expression {prodStream << "postfix_expression -> primary_expression\n";}
	| postfix_expression OPENSQ expression CLOSSQ {prodStream << "postfix_expression -> postfix_expression OPENSQ expression CLOSSQ\n";}
	| postfix_expression OPENPAR CLOSEPAR {prodStream << "postfix_expression -> postfix_expression OPENPAR CLOSEPAR\n";}
	| postfix_expression OPENPAR argument_expression_list CLOSEPAR {prodStream << "postfix_expression -> postfix_expression OPENPAR argument_expression_list CLOSEPAR\n";}
	| postfix_expression PERIOD identifier {prodStream << "postfix_expression -> postfix_expression PERIOD identifier\n";}
	| postfix_expression PTR_OP identifier {prodStream << "postfix_expression -> postfix_expression PTR_OP identifier\n";}
	| postfix_expression INC_OP {prodStream << "postfix_expression -> postfix_expression INC_OP\n";}
	| postfix_expression DEC_OP {prodStream << "postfix_expression -> postfix_expression DEC_OP\n";}
	;

primary_expression
	: identifier {prodStream << "primary_expression -> identifier\n";}
	| constant {prodStream << "primary_expression -> constant\n";}
	| string {prodStream << "primary_expression -> string\n";}
	| OPENPAR expression CLOSEPAR {prodStream << "primary_expression -> OPENPAR expression CLOSEPAR\n";}
	;

argument_expression_list
	: assignment_expression {prodStream << "argument_expression_list -> assignment_expression\n";}
	| argument_expression_list COMMA assignment_expression {prodStream << "argument_expression_list -> argument_expression_list COMMA assignment_expression\n";}
	;

constant
	: INTEGER_CONSTANT {prodStream << "constant -> INTEGER_CONSTANT\n";}
	| CHARACTER_CONSTANT {prodStream << "constant -> CHARACTER_CONSTANT\n";}
	| FLOATING_CONSTANT {prodStream << "constant -> FLOATING_CONSTANT\n";}
	| ENUMERATION_CONSTANT {prodStream << "constant -> ENUMERATION_CONSTANT\n";}
	;

string
	: STRING_LITERAL {prodStream << "string -> STRING_LITERAL\n";}
	;

identifier
	: IDENTIFIER {prodStream << "identifier -> IDENTIFIER\n";}
	;
%%

extern int column;

//error function called when parsing fails, prints error to stderr stream thingy
void yyerror (char const* s)
{
    cerr << s << " on line " << yylloc.first_line << endl;
	return;
}

int main(int argc, char **argv)
{
    //todo yyin file pointers
    SymbolTable symbolTable;
    table_ptr = &symbolTable;
    ofstream ofs;
    ofs.open("tokens.out", std::ofstream::out | std::ofstream::trunc);
    ofs.close();
    for(int i = 0; i < 4; i++) //initialize all debug options to false
        debug[i] = false;
    if(argc > 1)
    {
        for(int i = 1; i < argc; i++)
            {
                if(strcmp(argv[i],"-d") == 0)
                    debug[0] = true;
                else if(strcmp(argv[i],"-l") == 0)
                    debug[1] = true;
                else if(strcmp(argv[i],"-s") == 0)
                    debug[2] = true;
                else if(strcmp(argv[i],"-o") == 0)
                    debug[3] = true;
            }
        yyin = fopen(argv[argc - 1], "r");
        if ( !yyin )
        {
            cout << "Opening file unsuccessful, aborting." << endl;
            return(-1);
        }
        else
            fileName = argv[argc - 1];
    }
	yyparse();
	return 0;
}
