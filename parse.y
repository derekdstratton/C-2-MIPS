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
#include "ASTNodes.h"
#include "include/tree.hh"
#include "include/tree_util2.hh"

SymbolTable * table_ptr;

/* Global Variables */

using namespace std;
extern list<ASTNode*> empty;

/* Global Variables */
//SymbolTable * table_ptr;

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

ASTNode * root_ptr;

/* Function declarations */

int yylex();
%}


%union {
//todo this should be YYSTYPE node *, no stupid union overhead
    //long ival;
    //float fval;
    //char cval;
    //char * sval;
    ASTNode * node;
}

%type <node> translation_unit external_declaration function_definition declaration
%type <node> declaration_list declaration_specifiers storage_class_specifier type_specifier
%type <node> type_qualifier struct_or_union_specifier struct_or_union struct_declaration_list
%type <node> init_declarator_list init_declarator struct_declaration specifier_qualifier_list
%type <node> struct_declarator_list struct_declarator enum_specifier enumerator_list
%type <node> enumerator declarator direct_declarator pointer
%type <node> type_qualifier_list parameter_type_list parameter_list parameter_declaration
%type <node> identifier_list initializer initializer_list type_name
%type <node> abstract_declarator direct_abstract_declarator statement labeled_statement
%type <node> expression_statement compound_statement statement_list selection_statement
%type <node> iteration_statement jump_statement expression assignment_expression
%type <node> assignment_operator conditional_expression constant_expression logical_or_expression
%type <node> logical_and_expression inclusive_or_expression exclusive_or_expression and_expression
%type <node> equality_expression relational_expression shift_expression additive_expression
%type <node> multiplicative_expression cast_expression unary_expression unary_operator
%type <node> postfix_expression primary_expression argument_expression_list constant
%type <node> string identifier



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
%token<node> INTEGER_CONSTANT
%token<node> FLOATING_CONSTANT
%token<node> CHARACTER_CONSTANT
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
	: external_declaration {
	list <ASTNode*> tempList;
	tempList.push_back($1);
    $$ = new ASTNode("translation_unit", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	root_ptr = $$;
	handleProd("translation_unit -> external_declaration\n");}
	| translation_unit external_declaration {handleProd("translation_unit -> translation_unit external_declaration\n");}
	;

external_declaration
	: function_definition {
	list <ASTNode*> tempList;
	tempList.push_back($1);
    $$ = new ASTNode("external_declaration", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("external_declaration -> function_definition\n");}
	| declaration {
	$$ = new ASTNode();
	handleProd("external_declaration -> declaration\n");}
	;

function_definition
	: declarator compound_statement {
	$$ = new ASTNode();
	handleProd("function_definition -> declarator compound_statement\n");}
	| declarator declaration_list compound_statement {
	$$ = new ASTNode();
	handleProd("function_definition -> declarator declaration_list compound_statement\n");}
	| declaration_specifiers declarator compound_statement {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    tempList.push_back($2);
    tempList.push_back($3);
    $$ = new ASTNode("function_definition", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("function_definition -> declaration_specifiers declarator compound_statement\n");}
	| declaration_specifiers declarator declaration_list compound_statement {
	$$ = new ASTNode();
	handleProd("function_definition -> declaration_specifiers declarator declaration_list compound_statement\n");}
	;

declaration
	: declaration_specifiers SEMI {
	$$ = new ASTNode();
	handleProd("declaration -> declaration_specifiers SEMI\n");}
	| declaration_specifiers init_declarator_list SEMI {
	$$ = new ASTNode();
	handleProd("declaration -> declaration_specifiers init_declarator_list SEMI\n");}
	;

declaration_list
	: declaration {
	$$ = new ASTNode();
	handleProd("declaration_list -> declaration\n");}
	| declaration_list declaration {
	$$ = new ASTNode();
	handleProd("declaration_list -> declaration_list declaration\n");}
	;

declaration_specifiers
	: storage_class_specifier {
	$$ = new ASTNode();
	handleProd("declaration_specifiers -> storage_class_specifier\n");}
	| storage_class_specifier declaration_specifiers {
	$$ = new ASTNode();
	handleProd("declaration_specifiers -> storage_class_specifier declaration_specifiers\n");}
	| type_specifier {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("declaration_specifiers", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("declaration_specifiers -> type_specifier\n");}
	| type_specifier declaration_specifiers {
	$$ = new ASTNode();
	handleProd("declaration_specifiers -> type_specifier declaration_specifiers\n");}
	| type_qualifier {
	$$ = new ASTNode();
	handleProd("declaration_specifiers -> type_qualifier\n");}
	| type_qualifier declaration_specifiers {
	$$ = new ASTNode();
	handleProd("declaration_specifiers -> type_qualifier declaration_specifiers\n");}
	;

storage_class_specifier
	: AUTO {
	$$ = new ASTNode();
	handleProd("storage_class_specifier -> AUTO\n");}
	| REGISTER {
	$$ = new ASTNode();
	handleProd("storage_class_specifier -> REGISTER\n");}
	| STATIC {
	$$ = new ASTNode();
	handleProd("storage_class_specifier -> STATIC\n");}
	| EXTERN {
	$$ = new ASTNode();
	handleProd("storage_class_specifier -> EXTERN\n");}
	| TYPEDEF {
	$$ = new ASTNode();
	handleProd("storage_class_specifier -> TYPEDEF\n");}
	;

type_specifier
	: VOID {
	$$ = new ASTNode();
	handleProd("type_specifier -> VOID\n");}
	| CHAR {
	$$ = new ASTNode();
	handleProd("type_specifier -> CHAR\n");}
	| SHORT {
	$$ = new ASTNode();
	handleProd("type_specifier -> SHORT\n");}
	| INT {
	list <ASTNode*> tempList;
    tempList.push_back(yylval.node);
    $$ = new ASTNode("type_specifier", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("type_specifier -> INT\n");}
	| LONG {
	$$ = new ASTNode();
	handleProd("type_specifier -> LONG\n");}
	| FLOAT {
	$$ = new ASTNode();
	handleProd("type_specifier -> FLOAT\n");}
	| DOUBLE {
	$$ = new ASTNode();
	handleProd("type_specifier -> DOUBLE\n");}
	| SIGNED {
	$$ = new ASTNode();
	handleProd("type_specifier -> SIGNED\n");}
	| UNSIGNED {
	$$ = new ASTNode();
	handleProd("type_specifier -> UNSIGNED\n");}
	| struct_or_union_specifier {
	$$ = new ASTNode();
	handleProd("type_specifier -> struct_or_union_specifier\n");}
	| enum_specifier {
	$$ = new ASTNode();
	handleProd("type_specifier -> enum_specifier\n");}
	| TYPEDEF_NAME {
	$$ = new ASTNode();
	handleProd("type_specifier -> TYPEDEF_NAME\n");}
	;

type_qualifier
	: CONST {
	$$ = new ASTNode();
	handleProd("type_qualifier -> CONST\n");}
	| VOLATILE {
	$$ = new ASTNode();
	handleProd("type_qualifier -> VOLATILE\n");}
	;

struct_or_union_specifier
	: struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("struct_or_union_specifier -> struct_or_union identifier OPENCUR struct_declaration_list CLOSCUR\n");}
	| struct_or_union OPENCUR struct_declaration_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("struct_or_union_specifier -> struct_or_union OPENCUR struct_declaration_list CLOSCUR\n");}
	| struct_or_union identifier {
	$$ = new ASTNode();
	handleProd("struct_or_union_specifier -> struct_or_union identifier\n");}
	;

struct_or_union
	: STRUCT {
	$$ = new ASTNode();
	handleProd("struct_or_union -> STRUCT\n");}
	| UNION {
	$$ = new ASTNode();
	handleProd("struct_or_union -> UNION\n");}
	;

struct_declaration_list
	: struct_declaration {
	$$ = new ASTNode();
	handleProd("struct_declaration_list -> struct_declaration\n");}
	| struct_declaration_list struct_declaration {
	$$ = new ASTNode();
	handleProd("struct_declaration_list -> struct_declaration_list struct_declaration\n");}
	;

init_declarator_list
	: init_declarator {
	$$ = new ASTNode();
	handleProd("init_declarator_list -> init_declarator\n");}
	| init_declarator_list COMMA init_declarator {
	$$ = new ASTNode();
	handleProd("init_declarator_list -> init_declarator_list COMMA init_declarator\n");}
	;

init_declarator
	: declarator {
	$$ = new ASTNode();
	handleProd("init_declarator -> declarator\n");}
	| declarator ASSIGN initializer {
	$$ = new ASTNode();
	handleProd("init_declarator -> declarator ASSIGN initializer\n");}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMI {
	$$ = new ASTNode();
	handleProd("struct_declaration -> specifier_qualifier_list struct_declarator_list SEMI\n");}
	;

specifier_qualifier_list
	: type_specifier {
	$$ = new ASTNode();
	handleProd("specifier_qualifier_list -> type_specifier\n");}
	| type_specifier specifier_qualifier_list {
	$$ = new ASTNode();
	handleProd("specifier_qualifier_list -> type_specifier specifier_qualifier_list\n");}
	| type_qualifier {
	$$ = new ASTNode();
	handleProd("specifier_qualifier_list -> type_qualifier\n");}
	| type_qualifier specifier_qualifier_list {
	$$ = new ASTNode();
	handleProd("specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n");}
	;

struct_declarator_list
	: struct_declarator {
	$$ = new ASTNode();
	handleProd("struct_declarator_list -> struct_declarator\n");}
	| struct_declarator_list COMMA struct_declarator {
	$$ = new ASTNode();
	handleProd("struct_declarator_list -> struct_declarator_list COMMA struct_declarator\n");}
	;

struct_declarator
	: declarator {
	$$ = new ASTNode();
	handleProd("struct_declarator -> declarator\n");}
	| COLON constant_expression {
	$$ = new ASTNode();
	handleProd("struct_declarator -> COLON constant_expression\n");}
	| declarator COLON constant_expression {
	$$ = new ASTNode();
	handleProd("struct_declarator -> declarator COLON constant_expression\n");}
	;

enum_specifier
	: ENUM OPENCUR enumerator_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("enum_specifier -> ENUM OPENCUR enumerator_list CLOSCUR\n");}
	| ENUM identifier OPENCUR enumerator_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("enum_specifier -> ENUM identifier OPENCUR enumerator_list CLOSCUR\n");}
	| ENUM identifier {
	$$ = new ASTNode();
	handleProd("enum_specifier -> ENUM identifier\n");}
	;

enumerator_list
	: enumerator {
	$$ = new ASTNode();
	handleProd("enumerator_list -> enumerator\n");}
	| enumerator_list COMMA enumerator {
	$$ = new ASTNode();
	handleProd("enumerator_list -> enumerator_list COMMA enumerator\n");}
	;

enumerator
	: identifier {
	$$ = new ASTNode();
	handleProd("enumerator -> identifier\n");}
	| identifier ASSIGN constant_expression {
	$$ = new ASTNode();
	handleProd("enumerator -> identifier ASSIGN constant_expression\n");}
	;

declarator
	: direct_declarator {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("declarator", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("declarator -> direct_declarator\n");}
	| pointer direct_declarator {
	$$ = new ASTNode();handleProd("declarator -> pointer direct_declarator\n");}
	;

direct_declarator
	: identifier {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("direct_declarator", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("direct_declarator -> identifier\n");}
	| OPENPAR declarator CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_declarator -> OPENPAR declarator CLOSEPAR\n");}
	| direct_declarator OPENSQ CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_declarator -> direct_declarator OPENSQ CLOSSQ\n");}
	| direct_declarator OPENSQ constant_expression CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_declarator -> direct_declarator OPENSQ constant_expression CLOSSQ\n");}
	| direct_declarator OPENPAR CLOSEPAR {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("direct_declarator", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("direct_declarator -> direct_declarator OPENPAR CLOSEPAR\n");}
	| direct_declarator OPENPAR parameter_type_list CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_declarator -> direct_declarator OPENPAR parameter_type_list CLOSEPAR\n");}
	| direct_declarator OPENPAR identifier_list CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_declarator -> direct_declarator OPENPAR identifier_list CLOSEPAR\n");}
	;

pointer
	: STAR {
	$$ = new ASTNode();
	handleProd("pointer -> STAR\n");}
	| STAR type_qualifier_list {
	$$ = new ASTNode();
	handleProd("pointer -> STAR type_qualifier_list\n");}
	| STAR pointer {
	$$ = new ASTNode();
	handleProd("pointer -> STAR pointer\n");}
	| STAR type_qualifier_list pointer {
	$$ = new ASTNode();
	handleProd("pointer -> STAR type_qualifier_list pointer\n");}
	;

type_qualifier_list
	: type_qualifier {
	$$ = new ASTNode();
	handleProd("type_qualifier_list -> type_qualifier\n");}
	;

parameter_type_list
	: parameter_list {
	$$ = new ASTNode();
	handleProd("parameter_type_list -> parameter_list\n");}
	| parameter_list COMMA ELIPSIS {
	$$ = new ASTNode();
	handleProd("parameter_type_list -> parameter_list COMMA ELIPSIS\n");}
	;

parameter_list
	: parameter_declaration {
	$$ = new ASTNode();
	handleProd("parameter_list -> parameter_declaration\n");}
	| parameter_list COMMA parameter_declaration {
	$$ = new ASTNode();
	handleProd("parameter_list -> parameter_list COMMA parameter_declaration\n");}
	;

parameter_declaration
	: declaration_specifiers declarator {
	$$ = new ASTNode();
	handleProd("parameter_declaration -> declaration_specifiers declarator\n");}
	| declaration_specifiers {
	$$ = new ASTNode();
	handleProd("parameter_declaration -> declaration_specifiers\n");}
	| declaration_specifiers abstract_declarator {
	$$ = new ASTNode();
	handleProd("parameter_declaration -> declaration_specifiers abstract_declarator\n");}
	;

identifier_list
	: identifier {
	$$ = new ASTNode();
	handleProd("identifier_list -> identifier\n");}
	| identifier_list COMMA identifier {
	$$ = new ASTNode();
	handleProd("identifier_list -> identifier_list COMMA identifier\n");}
	;

initializer
	: assignment_expression {
	$$ = new ASTNode();
	handleProd("initializer -> assignment_expression\n");}
	| OPENCUR initializer_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("initializer -> OPENCUR initializer_list CLOSCUR\n");}
	| OPENCUR initializer_list COMMA CLOSCUR {
	$$ = new ASTNode();
	handleProd("initializer -> OPENCUR initializer_list COMMA CLOSCUR\n");}
	;

initializer_list
	: initializer {
	$$ = new ASTNode();
	handleProd("initializer_list -> initializer\n");}
	| initializer_list COMMA initializer {
	$$ = new ASTNode();
	handleProd("initializer_list -> initializer_list COMMA initializer\n");}
	;

type_name
	: specifier_qualifier_list {
	$$ = new ASTNode();
	handleProd("type_name -> specifier_qualifier_list\n");}
	| specifier_qualifier_list abstract_declarator {
	$$ = new ASTNode();
	handleProd("type_name -> specifier_qualifier_list abstract_declarator\n");}
	;

abstract_declarator
	: pointer {
	$$ = new ASTNode();
	handleProd("abstract_declarator -> pointer\n");}
	| direct_abstract_declarator {
	$$ = new ASTNode();
	handleProd("abstract_declarator -> direct_abstract_declarator\n");}
	| pointer direct_abstract_declarator {
	$$ = new ASTNode();
	handleProd("abstract_declarator -> pointer direct_abstract_declarator\n");}
	;

direct_abstract_declarator
	: OPENPAR abstract_declarator CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> OPENPAR abstract_declarator CLOSEPAR\n");}
	| OPENSQ CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> OPENSQ CLOSSQ\n");}
	| OPENSQ constant_expression CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> OPENSQ constant_expression CLOSSQ\n");}
	| direct_abstract_declarator OPENSQ CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENSQ CLOSSQ\n");}
	| direct_abstract_declarator OPENSQ constant_expression CLOSSQ {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENSQ constant_expression CLOSSQ\n");}
	| OPENPAR CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> OPENPAR CLOSEPAR\n");}
	| OPENPAR parameter_type_list CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> OPENPAR parameter_type_list CLOSEPAR\n");}
	| direct_abstract_declarator OPENPAR CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENPAR CLOSEPAR\n");}
	| direct_abstract_declarator OPENPAR parameter_type_list CLOSEPAR {
	$$ = new ASTNode();
	handleProd("direct_abstract_declarator -> direct_abstract_declarator OPENPAR parameter_type_list\n");}
	;

statement
	: labeled_statement {
	$$ = new ASTNode();
	handleProd("statement -> labeled_statement\n");}
	| compound_statement {
	$$ = new ASTNode();
	handleProd("statement -> compound_statement\n");}
	| expression_statement {
	$$ = new ASTNode();
	handleProd("statement -> expression_statement\n");}
	| selection_statement {
	$$ = new ASTNode();
	handleProd("statement -> selection_statement\n");}
	| iteration_statement {
	$$ = new ASTNode();
	handleProd("statement -> iteration_statement\n");}
	| jump_statement {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("statement", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("statement -> jump_statement\n");}
	;

labeled_statement
	: identifier COLON statement {
	$$ = new ASTNode();
	handleProd("labeled_statement -> identifier COLON statement\n");}
	| CASE constant_expression COLON statement {
	$$ = new ASTNode();
	handleProd("labeled_statement -> CASE constant_expression COLON statement\n");}
	| DEFAULT COLON statement {
	$$ = new ASTNode();
	handleProd("labeled_statement -> DEFAULT COLON statement\n");}
	;

expression_statement
	: SEMI {
	$$ = new ASTNode();
	handleProd("expression_statement -> SEMI\n");}
	| expression SEMI {
	$$ = new ASTNode();
	handleProd("expression_statement -> expression SEMI\n");}
	;

compound_statement
	: OPENCUR CLOSCUR {
	$$ = new ASTNode();
	handleProd("compound_statement -> OPENCUR CLOSCUR\n");}
	| OPENCUR statement_list CLOSCUR {
	list <ASTNode*> tempList;
    tempList.push_back($2);
    $$ = new ASTNode("compound_statement", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("compound_statement -> OPENCUR statement_list CLOSCUR\n");}
	| OPENCUR declaration_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("compound_statement -> OPENCUR declaration_list CLOSCUR\n");}
	| OPENCUR declaration_list statement_list CLOSCUR {
	$$ = new ASTNode();
	handleProd("compound_statement -> OPENCUR declaration_list statement_list CLOSCUR\n");}
	;

statement_list
	: statement {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("statement_list", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("statement_list -> statement\n");}
	| statement_list statement {
	$$ = new ASTNode();
	handleProd("statement_list -> statement_list statement\n");}
	;

selection_statement
	: IF OPENPAR expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement\n");}
	| IF OPENPAR expression CLOSEPAR statement ELSE statement {
	$$ = new ASTNode();
	handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement ELSE statement\n");}
	| SWITCH OPENPAR expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("selection_statement -> SWITCH OPENPAR expression CLOSEPAR statement\n");}
	;

iteration_statement
	: WHILE OPENPAR expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> WHILE OPENPAR expression CLOSEPAR statement\n");}
	| DO statement WHILE OPENPAR expression CLOSEPAR SEMI {
	$$ = new ASTNode();
	handleProd("iteration_statement -> DO statement WHILE OPENPAR expression CLOSEPAR SEMI\n");}
	| FOR OPENPAR SEMI SEMI CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI SEMI expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement\n");}
	;

jump_statement
	: GOTO identifier SEMI {
	$$ = new ASTNode();
	handleProd("jump_statement -> GOTO identifier SEMI\n");}
	| CONTINUE  {
	$$ = new ASTNode();
	handleProd("jump_statement -> CONTINUE \n");}
	| BREAK  {
	$$ = new ASTNode();
	handleProd("jump_statement -> BREAK\n");}
	| RETURN SEMI {
	$$ = new ASTNode();
	handleProd("jump_statement -> RETURN SEMI\n");}
	| RETURN expression SEMI {
	list <ASTNode*> tempList;
    tempList.push_back($2);
    $$ = new ASTNode("jump_statement", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("jump_statement -> RETURN expression SEMI\n");}
	;

expression
	: assignment_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("expression -> assignment_expression\n");}
	| expression COMMA assignment_expression {
	$$ = new ASTNode();
	handleProd("expression -> expression COMMA assignment_expression\n");}
	;

assignment_expression
	: conditional_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("assignment_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("assignment_expression -> conditional_expression\n");}
	| unary_expression assignment_operator assignment_expression {
	$$ = new ASTNode();
	handleProd("assignment_expression -> unary_expression assignment_operator assignment_expression\n");}
	;

assignment_operator
	: ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> ASSIGN\n");}
	| MUL_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> MUL_ASSIGN\n");}
	| DIV_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> DIV_ASSIGN\n");}
	| MOD_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> MOD_ASSIGN\n");}
	| ADD_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> ADD_ASSIGN\n");}
	| SUB_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> SUB_ASSIGN\n");}
	| LEFT_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> LEFT_ASSIGN\n");}
	| RIGHT_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> RIGHT_ASSIGN\n");}
	| AND_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> AND_ASSIGN\n");}
	| XOR_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> XOR_ASSIGN\n");}
	| OR_ASSIGN {
	$$ = new ASTNode();
	handleProd("assignment_operator -> OR_ASSIGN\n");}
	;

conditional_expression
	: logical_or_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("conditional_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("conditional_expression -> logical_or_expression\n");}
	| logical_or_expression TERNARY expression COLON conditional_expression {
	$$ = new ASTNode();
	handleProd("conditional_expression -> logical_or_expression TERNARY expression COLON conditional_expression \n");}
	;

constant_expression
	: conditional_expression {
	$$ = new ASTNode();
	handleProd("constant_expression -> conditional_expression\n");}
	;

logical_or_expression
	: logical_and_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("logical_or_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("logical_or_expression -> logical_and_expression\n");}
	| logical_or_expression OR_OP logical_and_expression {
	$$ = new ASTNode();
	handleProd("logical_or_expression -> logical_or_expression OR_OP logical_and_expression\n");}
	;

logical_and_expression
	: inclusive_or_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("logical_and_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("logical_and_expression -> inclusive_or_expression\n");}
	| logical_and_expression AND_OP inclusive_or_expression {
	$$ = new ASTNode();
	handleProd("logical_and_expression -> logical_and_expression AND_OP inclusive_or_expression\n");}
	;

inclusive_or_expression
	: exclusive_or_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("inclusive_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("inclusive_or_expression -> exclusive_or_expression\n");}
	| inclusive_or_expression BAR exclusive_or_expression {
	$$ = new ASTNode();
	handleProd("inclusive_or_expression -> inclusive_or_expression BAR exclusive_or_expression\n");}
	;

exclusive_or_expression
	: and_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("exclusive_or_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("exclusive_or_expression -> and_expression\n");}
	| exclusive_or_expression XOR and_expression {
	$$ = new ASTNode();
	handleProd("exclusive_or_expression -> exclusive_or_expression XOR and_expression\n");}
	;

and_expression
	: equality_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("and_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("and_expression -> equality_expression\n");}
	| and_expression AND equality_expression {
	$$ = new ASTNode();
	handleProd("and_expression -> and_expression AND equality_expression\n");}
	;

equality_expression
	: relational_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("equality_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("equality_expression -> relational_expression\n");}
	| equality_expression EQ_OP relational_expression {
	$$ = new ASTNode();
	handleProd("equality_expression -> equality_expression EQ_OP relational_expression\n");}
	| equality_expression NE_OP relational_expression {
	$$ = new ASTNode();
	handleProd("equality_expression -> equality_expression NE_OP relational_expression\n");}
	;

relational_expression
	: shift_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("relational_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("relational_expression -> shift_expression\n");}
	| relational_expression LESSTH shift_expression {
	$$ = new ASTNode();
	handleProd("relational_expression -> relational_expression LESSTH shift_expression\n");}
	| relational_expression GREATH shift_expression {
	$$ = new ASTNode();
	handleProd("relational_expression -> relational_expression GREATH shift_expression\n");}
	| relational_expression LE_OP shift_expression {
	$$ = new ASTNode();
	handleProd("relational_expression -> relational_expression LE_OP shift_expression\n");}
	| relational_expression GE_OP shift_expression {
	$$ = new ASTNode();
	handleProd("relational_expression -> relational_expression GE_OP shift_expression\n");}
	;

shift_expression
	: additive_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("shift_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("shift_expression -> additive_expression\n");}
	| shift_expression LEFT_OP additive_expression {
	$$ = new ASTNode();
	handleProd("shift_expression -> shift_expression LEFT_OP additive_expression\n");}
	| shift_expression RIGHT_OP additive_expression {
	$$ = new ASTNode();
	handleProd("shift_expression -> shift_expression RIGHT_OP additive_expression\n");}
	;

additive_expression
	: multiplicative_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("additive_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("additive_expression -> multiplicative_expression\n");}
	| additive_expression PLUS multiplicative_expression {
	$$ = new ASTNode();
	handleProd("additive_expression -> additive_expression PLUS multiplicative_expression\n");}
	| additive_expression MINUS multiplicative_expression {
	$$ = new ASTNode();
	handleProd("additive_expression -> additive_expression MINUS multiplicative_expression\n");}
	;

multiplicative_expression
	: cast_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("multiplicative_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("multiplicative_expression -> cast_expression\n");}
	| multiplicative_expression STAR cast_expression {
	$$ = new ASTNode();
	handleProd("multiplicative_expression -> multiplicative_expression STAR cast_expression\n");}
	| multiplicative_expression SLASH cast_expression {
	$$ = new ASTNode();
	handleProd("multiplicative_expression -> multiplicative_expression SLASH cast_expression\n");}
	| multiplicative_expression MODULO cast_expression {
	$$ = new ASTNode();
	handleProd("multiplicative_expression -> multiplicative_expression MODULO cast_expression\n");}
	;

cast_expression
	: unary_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("cast_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("cast_expression -> unary_expression\n");}
	| OPENPAR type_name CLOSEPAR cast_expression {
	$$ = new ASTNode();
	handleProd("cast_expression -> OPENPAR type_name CLOSEPAR cast_expression\n");}
	;

unary_expression
	: postfix_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("unary_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("unary_expression -> postfix_expression\n");}
	| INC_OP unary_expression {
	$$ = new ASTNode();
	handleProd("unary_expression -> INC_OP unary_expression\n");}
	| DEC_OP unary_expression {
	$$ = new ASTNode();
	handleProd("unary_expression -> DEC_OP unary_expression\n");}
	| unary_operator cast_expression {
	$$ = new ASTNode();
	handleProd("unary_expression -> unary_operator cast_expression\n");}
	| SIZEOF unary_expression {
	$$ = new ASTNode();
	handleProd("unary_expression -> SIZEOF unary_expression\n");}
	| SIZEOF OPENPAR type_name CLOSEPAR {
	$$ = new ASTNode();
	handleProd("unary_expression -> SIZEOF OPENPAR type_name CLOSEPAR\n");}
	;

unary_operator
	: AND {
	$$ = new ASTNode();
	handleProd("unary_operator -> AND\n");}
	| STAR {
	$$ = new ASTNode();
	handleProd("unary_operator -> STAR\n");}
	| PLUS {
	$$ = new ASTNode();
	handleProd("unary_operator -> PLUS\n");}
	| MINUS {
	$$ = new ASTNode();
	handleProd("unary_operator -> MINUS\n");}
	| TILDE {
	$$ = new ASTNode();
	handleProd("unary_operator -> TILDE\n");}
	| BANG {
	$$ = new ASTNode();
	handleProd("unary_operator -> BANG\n");}
	;

postfix_expression
	: primary_expression {
	list <ASTNode*> tempList;
    tempList.push_back($1);
    $$ = new ASTNode("postfix_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("postfix_expression -> primary_expression\n");}
	| postfix_expression OPENSQ expression CLOSSQ {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression OPENSQ expression CLOSSQ\n");}
	| postfix_expression OPENPAR CLOSEPAR {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression OPENPAR CLOSEPAR\n");}
	| postfix_expression OPENPAR argument_expression_list CLOSEPAR {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression OPENPAR argument_expression_list CLOSEPAR\n");}
	| postfix_expression PERIOD identifier {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression PERIOD identifier\n");}
	| postfix_expression PTR_OP identifier {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression PTR_OP identifier\n");}
	| postfix_expression INC_OP {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression INC_OP\n");}
	| postfix_expression DEC_OP {
	$$ = new ASTNode();
	handleProd("postfix_expression -> postfix_expression DEC_OP\n");}
	;

primary_expression
	: identifier {
	$$ = new ASTNode();
	handleProd("primary_expression -> identifier\n");}
	| constant {
	list <ASTNode*> tempList;
	tempList.push_back($1);
	$$ = new ASTNode("primary_expression", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("primary_expression -> constant\n");}
	| string {
	$$ = new ASTNode();
	handleProd("primary_expression -> string\n");}
	| OPENPAR expression CLOSEPAR {
	$$ = new ASTNode();
	handleProd("primary_expression -> OPENPAR expression CLOSEPAR\n");}
	;

argument_expression_list
	: assignment_expression {
	$$ = new ASTNode();
	handleProd("argument_expression_list -> assignment_expression\n");}
	| argument_expression_list COMMA assignment_expression {
	$$ = new ASTNode();
	handleProd("argument_expression_list -> argument_expression_list COMMA assignment_expression\n");}
	;

constant
	: INTEGER_CONSTANT {
    list <ASTNode*> tempList;
    tempList.push_back(yylval.node);
	$$ = new ASTNode("constant", yylloc.first_line, columnQueue.size() - yyleng + 1, tempList);
	handleProd("constant -> INTEGER_CONSTANT\n");}
	| CHARACTER_CONSTANT {
	$$ = new ASTNode();
	handleProd("constant -> CHARACTER_CONSTANT\n");}
	| FLOATING_CONSTANT {
	$$ = new ASTNode();
	handleProd("constant -> FLOATING_CONSTANT\n");}
	| ENUMERATION_CONSTANT {
	$$ = new ASTNode();
	handleProd("constant -> ENUMERATION_CONSTANT\n");}
	;

string
	: STRING_LITERAL {
	$$ = new ASTNode();
	handleProd("string -> STRING_LITERAL\n");}
	;

identifier
	: IDENTIFIER {
	//list <ASTNode*> tempList;
    //tempList.push_back($1);
    $$ = new ASTNode("identifier", yylloc.first_line, columnQueue.size() - yyleng + 1, empty); //todo use actual value
	handleProd("identifier -> IDENTIFIER\n");}
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
    tree<ASTNode*> ast;
    auto top = ast.begin();
    ast.insert(top, root_ptr);
    //todo make a function that copies my tree into the tree.hh tree. Should be an easy pre-order
    kptree::print_tree_bracketed(ast);
	return 0;
}

