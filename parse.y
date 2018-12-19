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
#include <list>
#include <utility>
#include <deque>
#include <stack>

#include "SymbolTable.h"
#include "ASTNodes.h"
#include "include/tree.hh"
#include "include/tree_util2.hh"
#include "generateMIPS.cpp"

SymbolTable * table_ptr;

/* Global Variables */

using namespace std;

ASTNode * idNode;
set<int> types;

list<int> size_decl_list;
list<ASTNode*> idList;
list<set<int>> paramList;
list<pair<string, set<int>>> definitionList;

extern int yylineno;
extern deque <char> columnQueue;
extern string currentLine;
string newOutputFile;
string TOKENPATH;
string PRODPATH;
string SYMBOLPATH;
string ASTPATH;
string THREEACPATH;
string MIPSPATH;
extern FILE * yyin;
bool debug[7]; // -d, -l, -s, productions flag, -o, -a, -3
// -d enable debugging
// -l produces a list of tokens and their values to a file
// -s dumps symbol table at key points to a file
// -p prints all productions to a file
// -o name a file to output interspersed reductions to
// -a prints AST to a file named ast.dot
// -3 prints 3AC to a file
// always prints asm to a file
char* fileName;

extern void outputError(string errmsg1, string errmsg2, bool errtype);
void yyerror (char const *s);
void handleProd (string prod);
stringstream& printParamError (list<set<int>> params);
bool printProd = false;
extern int yyleng;
stringstream prodStream;

ASTNode * root_ptr;

stack<ASTNode*> assignNodes;

/* Function declarations */

int yylex();
%}


%union {
    float fval;
    char cval;
    ASTNode * node;
    string * sval;
    int ival;
}

%type <node> translation_unit external_declaration function_definition declaration
%type <node> declaration_list declaration_specifiers
%type <node> struct_or_union_specifier struct_declaration_list
%type <node> init_declarator_list init_declarator struct_declaration specifier_qualifier_list
%type <node> struct_declarator_list struct_declarator enum_specifier enumerator_list
%type <node> enumerator declarator direct_declarator pointer
%type <node> identifier_list initializer initializer_list type_name
%type <node> parameter_type_list parameter_list parameter_declaration
%type <node> abstract_declarator direct_abstract_declarator statement labeled_statement
%type <node> expression_statement compound_statement statement_list selection_statement
%type <node> iteration_statement jump_statement expression assignment_expression
%type <node> conditional_expression constant_expression logical_or_expression
%type <node> logical_and_expression inclusive_or_expression exclusive_or_expression and_expression
%type <node> equality_expression relational_expression shift_expression additive_expression
%type <node> multiplicative_expression cast_expression unary_expression
%type <node> postfix_expression primary_expression argument_expression_list constant
%type <node> string identifier

%type <ival> assignment_operator unary_operator struct_or_union type_qualifier_list
%type <ival> type_specifier type_qualifier storage_class_specifier

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

%token<sval> IDENTIFIER
%token<ival> INTEGER_CONSTANT
%token<fval> FLOATING_CONSTANT
%token<cval> CHARACTER_CONSTANT
%token ENUMERATION_CONSTANT
%token<sval> STRING_LITERAL
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
	list<ASTNode*> tmp;
	tmp.push_back($1);
	$$ = new SeqNode('g', tmp);
	root_ptr = $$;
	handleProd("translation_unit -> external_declaration\n");}

	| translation_unit external_declaration {
	list<ASTNode*> seq = $1->getChildren();
    seq.push_back($2);
    $$ = new SeqNode('g', seq);
	root_ptr = $$;
	handleProd("translation_unit -> translation_unit external_declaration\n");}
	;

external_declaration
	: function_definition {
	$$ = $1;
	handleProd("external_declaration -> function_definition\n");}

	| declaration {
	$$ = $1;
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

	list<set<int>> types; //declare things
	list<ASTNode*> tmpList;

	types.push_back($1->getTypes()); //populate declared things
	tmpList.push_back($3);

	$$ = new FuncNode($2->getName(), types, tmpList, definitionList, 1); //create definition funcnode, has param names and types

	tuple<SymbolTableNode2*, string> searchResult = getTable()->search($2->getName()); //search sym table for function
    SymbolTableNode2* it;
    string status;
    tie(it, status) = searchResult;

    it->types = $1->getTypes();
	getTable()->change($2->getName(), *it); //set return type of functions in sym table

    definitionList.clear();
    getTable()->popLevel();

	handleProd("function_definition -> declaration_specifiers declarator compound_statement\n");}

	| declaration_specifiers declarator declaration_list compound_statement {
	//weird production, skip it
	$$ = new ASTNode();
	handleProd("function_definition -> declaration_specifiers declarator declaration_list compound_statement\n");}
	;

declaration
	: declaration_specifiers SEMI {
	$$ = $1; //this is an incredibly strange and useless line
	handleProd("declaration -> declaration_specifiers SEMI\n");}

	| declaration_specifiers init_declarator_list SEMI {

	list<set<int>> empty;

	string name = idNode->getName();
    set<int> x = $1->getTypes();
    SymbolTableNode2* s = new SymbolTableNode2(name, x, size_decl_list, false, empty, 0);
    idNode->setSymbolNode(s);
    //now insert it into the symbol table
    pair<string, SymbolTableNode2> entry = make_pair(name,*s);
    tuple<bool, bool> result = getTable()->insert(entry);
    //now you also need to make sure the identifier node has the symbol table node stuff
    $$ = new DeclNode($1, $2);

    bool insertSuccess, notShadowing;
    tie(insertSuccess, notShadowing) = result;
    if (!insertSuccess) {
        outputError("Already exists", "Variable already exists on this scope.", false);
    } else if (!notShadowing) {
        outputError("Already exists", "Shadowing an identifier from an outer scope.", true);
    }
    size_decl_list.clear(); //reset this too
	handleProd("declaration -> declaration_specifiers init_declarator_list SEMI\n");}
	;

declaration_list
	: declaration {
	list<ASTNode*> seq;
    seq.push_back($1);
    $$ = new SeqNode('d', seq);
	handleProd("declaration_list -> declaration\n");}

	| declaration_list declaration {
	list<ASTNode*> seq = $1->getChildren();
    seq.push_back($2);
    $$ = new SeqNode('d', seq);
	handleProd("declaration_list -> declaration_list declaration\n");}
	;

declaration_specifiers
	: storage_class_specifier {
	set<int> tmp;
    tmp.insert($1);
    $$ = new TypeNode(tmp);
	handleProd("declaration_specifiers -> storage_class_specifier\n");}

	| storage_class_specifier declaration_specifiers {
	set<int> x = $2->getTypes();
    x.insert($1);
    $$ = new TypeNode(x);
	handleProd("declaration_specifiers -> storage_class_specifier declaration_specifiers\n");}

	| type_specifier {
	set<int> tmp;
    tmp.insert($1);
    $$ = new TypeNode(tmp);
	handleProd("declaration_specifiers -> type_specifier\n");}

	| type_specifier declaration_specifiers {
	set<int> x = $2->getTypes();
    x.insert($1);
    $$ = new TypeNode(x);
	handleProd("declaration_specifiers -> type_specifier declaration_specifiers\n");}

	| type_qualifier {
	set<int> tmp;
    tmp.insert($1);
    $$ = new TypeNode(tmp);
	handleProd("declaration_specifiers -> type_qualifier\n");}

	| type_qualifier declaration_specifiers {
	set<int> x = $2->getTypes();
    x.insert($1);
    $$ = new TypeNode(x);
	handleProd("declaration_specifiers -> type_qualifier declaration_specifiers\n");}
	;

storage_class_specifier
	: AUTO {
	$$ = AUTO;
	handleProd("storage_class_specifier -> AUTO\n");}
	| REGISTER {
	$$ = REGISTER;
	handleProd("storage_class_specifier -> REGISTER\n");}
	| STATIC {
	$$ = STATIC;
	handleProd("storage_class_specifier -> STATIC\n");}
	| EXTERN {
	$$ = EXTERN;
	handleProd("storage_class_specifier -> EXTERN\n");}
	| TYPEDEF {
	$$ = TYPEDEF;
	handleProd("storage_class_specifier -> TYPEDEF\n");}
	;

type_specifier
	: VOID {
	$$ = VOID;
	handleProd("type_specifier -> VOID\n");}
	| CHAR {
	$$ = CHAR;
	handleProd("type_specifier -> CHAR\n");}
	| SHORT {
	$$ = SHORT;
	handleProd("type_specifier -> SHORT\n");}
	| INT {
	$$ = INT;
	handleProd("type_specifier -> INT\n");}
	| LONG {
	$$ = LONG;
	handleProd("type_specifier -> LONG\n");}
	| FLOAT {
	$$ = FLOAT;
	handleProd("type_specifier -> FLOAT\n");}
	| DOUBLE {
	$$ = DOUBLE;
	handleProd("type_specifier -> DOUBLE\n");}
	| SIGNED {
	$$ = SIGNED;
	handleProd("type_specifier -> SIGNED\n");}
	| UNSIGNED {
	$$ = UNSIGNED;
	handleProd("type_specifier -> UNSIGNED\n");}
	| struct_or_union_specifier {
	$$ = -1; //unused
	handleProd("type_specifier -> struct_or_union_specifier\n");}
	| enum_specifier {
	$$ = -1; //unused
	handleProd("type_specifier -> enum_specifier\n");}
	| TYPEDEF_NAME {
	$$ = TYPEDEF_NAME;
	handleProd("type_specifier -> TYPEDEF_NAME\n");}
	;

type_qualifier
	: CONST {
	$$ = CONST;
	handleProd("type_qualifier -> CONST\n");}
	| VOLATILE {
	$$ = VOLATILE;
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
	$$ = STRUCT;
	handleProd("struct_or_union -> STRUCT\n");}
	| UNION {
	$$ = UNION;
	handleProd("struct_or_union -> UNION\n");}
	;

struct_declaration_list
	: struct_declaration {
	$$ = $1;
	handleProd("struct_declaration_list -> struct_declaration\n");}
	| struct_declaration_list struct_declaration {
	$$ = new SeqNode('t', $1, $2);
	handleProd("struct_declaration_list -> struct_declaration_list struct_declaration\n");}
	;

init_declarator_list
	: init_declarator {
	$$ = $1;
	handleProd("init_declarator_list -> init_declarator\n");}
	| init_declarator_list COMMA init_declarator {
	$$ = new SeqNode('q', $1, $3); //I'm pretty sure this doesn't work with the Symbol Table
	handleProd("init_declarator_list -> init_declarator_list COMMA init_declarator\n");}
	;

init_declarator
	: declarator {
	$$ = $1;
	handleProd("init_declarator -> declarator\n");}
	| declarator ASSIGN initializer {
	$$ = $1;
	assignNodes.push($1);
	assignNodes.push($3);
	handleProd("init_declarator -> declarator ASSIGN initializer\n");}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMI {
	$$ = new ASTNode();
	handleProd("struct_declaration -> specifier_qualifier_list struct_declarator_list SEMI\n");}
	;

specifier_qualifier_list
	: type_specifier {
	set<int> tmp;
	tmp.insert($1);
	$$ = new TypeNode(tmp);
	handleProd("specifier_qualifier_list -> type_specifier\n");}

	| type_specifier specifier_qualifier_list {
	set<int> x = $2->getTypes();
	x.insert($1);
	$$ = new TypeNode(x);
	handleProd("specifier_qualifier_list -> type_specifier specifier_qualifier_list\n");}

	| type_qualifier {
	set<int> tmp;
	tmp.insert($1);
	$$ = new TypeNode(tmp);
	handleProd("specifier_qualifier_list -> type_qualifier\n");}

	| type_qualifier specifier_qualifier_list {
	set<int> x = $2->getTypes();
    x.insert($1);
    $$ = new TypeNode(x);
	handleProd("specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n");}
	;

struct_declarator_list
	: struct_declarator {
	$$ = $1;
	handleProd("struct_declarator_list -> struct_declarator\n");}
	| struct_declarator_list COMMA struct_declarator {
	$$ = new ASTNode();
	handleProd("struct_declarator_list -> struct_declarator_list COMMA struct_declarator\n");}
	;

struct_declarator
	: declarator {
	$$ = $1;
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
	$$ = $1;
	handleProd("enumerator_list -> enumerator\n");}
	| enumerator_list COMMA enumerator {
	$$ = new SeqNode('e', $1, $3);
	handleProd("enumerator_list -> enumerator_list COMMA enumerator\n");}
	;

enumerator
	: identifier {
	$$ = $1;
	handleProd("enumerator -> identifier\n");}
	| identifier ASSIGN constant_expression {
	$$ = new ASTNode();
	handleProd("enumerator -> identifier ASSIGN constant_expression\n");}
	;

declarator
	: direct_declarator {
	$$ = $1;
	handleProd("declarator -> direct_declarator\n");}
	| pointer direct_declarator {
	$$ = new ASTNode(); //Pointer
	handleProd("declarator -> pointer direct_declarator\n");}
	;

direct_declarator
	: identifier {
	$$ = $1;
	handleProd("direct_declarator -> identifier\n");}

	| OPENPAR declarator CLOSEPAR {
	$$ = $2;
	handleProd("direct_declarator -> OPENPAR declarator CLOSEPAR\n");}

	| direct_declarator OPENSQ CLOSSQ {
	list<ASTNode *> empty;
	$$ = new ArrayNode(idNode, empty);
	handleProd("direct_declarator -> direct_declarator OPENSQ CLOSSQ\n");}

	| direct_declarator OPENSQ constant_expression CLOSSQ {
	list<ASTNode*> sizes = $1->getSizes(); //only returns a list with contents if good, otherwise returns empty list
	sizes.push_back($3);
	$$ = new ArrayNode(idNode, sizes);
	//the following assumes that $3 is an integer constant when declaring the array.
	size_decl_list.push_back($3->getVal());
	handleProd("direct_declarator -> direct_declarator OPENSQ constant_expression CLOSSQ\n");}

	| direct_declarator OPENPAR CLOSEPAR {

	tuple<SymbolTableNode2*, string> searchResult = getTable()->search($1->getName());
	SymbolTableNode2* it;
	string status;
	tie(it, status) = searchResult;

	if(status != "not") //was found, means another of the same name is here
	{
        outputError("Already exists", "Trying to redeclare a function", false);
	}

    list<set<int>> empty;
	list<ASTNode*> empty2;
    list<pair<string, set<int>>> empty3;
	set<int> x;

	$$ = new FuncNode($1->getName(), empty, empty2, empty3, 0);

    SymbolTableNode2* s = new SymbolTableNode2($1->getName(), x, size_decl_list, true, paramList, false);
    idNode->setSymbolNode(s);
    //now insert it into the symbol table
    pair<string, SymbolTableNode2> entry = make_pair($1->getName(),*s);
    tuple<bool, bool> result = getTable()->insert(entry);
    //now you also need to make sure the identifier node has the symbol table node stuff

    getTable()->pushLevel();

    paramList.clear();
	handleProd("direct_declarator -> direct_declarator OPENPAR CLOSEPAR\n");}

	| direct_declarator OPENPAR parameter_type_list CLOSEPAR {

	tuple<SymbolTableNode2*, string> searchResult = getTable()->search($1->getName());
	SymbolTableNode2* it;
	string status;
	tie(it, status) = searchResult;

	if(status != "not") //was found, means another of the same name is here
	{
        outputError("Already exists", "Trying to redeclare a function", false);
	}

    list<set<int>> empty;
    list<ASTNode*> empty2;
    list<pair<string, set<int>>> empty3;
	set<int> x;

	$$ = new FuncNode($1->getName(), empty, empty2, empty3, 0);

    SymbolTableNode2* s = new SymbolTableNode2($1->getName(), x, size_decl_list, true, paramList, false);
    idNode->setSymbolNode(s);
    //now insert it into the symbol table
    pair<string, SymbolTableNode2> entry = make_pair($1->getName(),*s);
    tuple<bool, bool> result = getTable()->insert(entry);
    getTable()->pushLevel();
    //now you also need to make sure the identifier node has the symbol table node stuff

    for(auto i : definitionList)
    {
        SymbolTableNode2* s = new SymbolTableNode2(i.first, i.second, size_decl_list, false, empty, false);
        idNode->setSymbolNode(s);
        //now insert it into the symbol table
        pair<string, SymbolTableNode2> entry = make_pair(i.first,*s);
        tuple<bool, bool> result = getTable()->insert(entry);
    }

    paramList.clear();
	handleProd("direct_declarator -> direct_declarator OPENPAR parameter_type_list CLOSEPAR\n");}

	| direct_declarator OPENPAR identifier_list CLOSEPAR {
	//This is legacy code and bad.
	outputError("Stop", "This is bad, legacy code");
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
	$$ = $1;
	handleProd("type_qualifier_list -> type_qualifier\n");}
	;

parameter_type_list
	: parameter_list {
	$$ = $1;
	handleProd("parameter_type_list -> parameter_list\n");}
	| parameter_list COMMA ELIPSIS {
	//not handling elipsis
	$$ = new ASTNode();
	handleProd("parameter_type_list -> parameter_list COMMA ELIPSIS\n");}
	;

parameter_list
	: parameter_declaration {
    $$ = $1;
	handleProd("parameter_list -> parameter_declaration\n");}
	| parameter_list COMMA parameter_declaration {
	list<ASTNode*> seq = $1->getChildren();
    seq.push_back($3);
    $$ = new SeqNode('p', seq);
	handleProd("parameter_list -> parameter_list COMMA parameter_declaration\n");}
	;

parameter_declaration
	: declaration_specifiers declarator {

	paramList.push_back($1->getTypes());

	list<int> empty;
	list<set<int>> empty2;
	pair<string, set<int>> tmpPair ($2->getName(), $1->getTypes());
    definitionList.push_back(tmpPair);

	$$ = new ASTNode();
	handleProd("parameter_declaration -> declaration_specifiers declarator\n");}

	| declaration_specifiers {
	$$ = new ASTNode();
	paramList.push_back($1->getTypes());
	handleProd("parameter_declaration -> declaration_specifiers\n");}

	| declaration_specifiers abstract_declarator {
	$$ = new ASTNode();
	paramList.push_back($1->getTypes());
	handleProd("parameter_declaration -> declaration_specifiers abstract_declarator\n");}
	;

identifier_list
	: identifier {
	$$ = $1;
	handleProd("identifier_list -> identifier\n");}
	| identifier_list COMMA identifier {
	$$ = new SeqNode('i', $1, $3);
	handleProd("identifier_list -> identifier_list COMMA identifier\n");}
	;

initializer
	: assignment_expression {
	$$ = $1;
	handleProd("initializer -> assignment_expression\n");}

	| OPENCUR initializer_list CLOSCUR {
	$$ = new ASTNode(); //array init
	handleProd("initializer -> OPENCUR initializer_list CLOSCUR\n");}

	| OPENCUR initializer_list COMMA CLOSCUR {
	$$ = new ASTNode(); //array init
	handleProd("initializer -> OPENCUR initializer_list COMMA CLOSCUR\n");}
	;

initializer_list
	: initializer {
	$$ = new ASTNode(); //array init
	handleProd("initializer_list -> initializer\n");}
	| initializer_list COMMA initializer {
	$$ = new ASTNode(); //array init
	handleProd("initializer_list -> initializer_list COMMA initializer\n");}
	;

type_name
	: specifier_qualifier_list {
	$$ = $1;
	handleProd("type_name -> specifier_qualifier_list\n");}
	| specifier_qualifier_list abstract_declarator {
	//This production lets you cast/find sizeof with arrays/pointers/functions
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
	$$ = $1;
	handleProd("statement -> labeled_statement\n");}
	| compound_statement {
	$$ = $1;
	handleProd("statement -> compound_statement\n");}
	| expression_statement {
	$$ = $1;
	handleProd("statement -> expression_statement\n");}
	| selection_statement {
	$$ = $1;
	handleProd("statement -> selection_statement\n");}
	| iteration_statement {
	$$ = $1;
	handleProd("statement -> iteration_statement\n");}
	| jump_statement {
	$$ = $1;
	handleProd("statement -> jump_statement\n");}
	;

labeled_statement
	: identifier COLON statement {
	$$ = new ASTNode(); //this is for a goto label
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
	$$ = new NoneNode();
	handleProd("expression_statement -> SEMI\n");}
	| expression SEMI {
	$$ = $1;
	handleProd("expression_statement -> expression SEMI\n");}
	;

compound_statement
	: OPENCUR CLOSCUR {
	$$ = new NoneNode();
	handleProd("compound_statement -> OPENCUR CLOSCUR\n");}
	| OPENCUR statement_list CLOSCUR {
    $$ = $2;
	handleProd("compound_statement -> OPENCUR statement_list CLOSCUR\n");}
	| OPENCUR declaration_list CLOSCUR {
	$$ = $2;
	handleProd("compound_statement -> OPENCUR declaration_list CLOSCUR\n");}
	| OPENCUR declaration_list statement_list CLOSCUR {
    while (!assignNodes.empty()) { //TODO IMPORTANT: THIS PRODUCTION DOES NOT GO HERE. IT MUST GO WITH STATEMENT, NOT COMPOUND ONLY
        cerr << "THIS NEEDS TO HAPPEN LOL" << endl;
        auto right = assignNodes.top();
        assignNodes.pop();
        auto left = assignNodes.top();
        assignNodes.pop();
        auto newNode = new AssignNode(left, right);
        auto place = $3->getChildren();
        place.push_front(newNode);
        $3 = new SeqNode('s', place);
    }
    $$ = new SeqNode('c', $2, $3);
	handleProd("compound_statement -> OPENCUR declaration_list statement_list CLOSCUR\n");}
	;

statement_list
	: statement {
	list<ASTNode*> tmp;
	tmp.push_back($1);
	$$ = new SeqNode('s', tmp);
	handleProd("statement_list -> statement\n");}

	| statement_list statement {
	list<ASTNode*> seq = $1->getChildren();
	seq.push_back($2);
	$$ = new SeqNode('s', seq);
	handleProd("statement_list -> statement_list statement\n");}
	;

selection_statement
	: IF OPENPAR expression CLOSEPAR statement {
	$$ = new IfNode($3, $5);
	handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement\n");}
	| IF OPENPAR expression CLOSEPAR statement ELSE statement {
	$$ = new IfNode($3, $5, $7);
	handleProd("selection_statement -> IF OPENPAR expression CLOSEPAR statement ELSE statement\n");}
	| SWITCH OPENPAR expression CLOSEPAR statement {
	$$ = new ASTNode();
	handleProd("selection_statement -> SWITCH OPENPAR expression CLOSEPAR statement\n");}
	;

iteration_statement
	: WHILE OPENPAR expression CLOSEPAR statement {
	$$ = new WhileNode($3, $5, false);
	handleProd("iteration_statement -> WHILE OPENPAR expression CLOSEPAR statement\n");}
	| DO statement WHILE OPENPAR expression CLOSEPAR SEMI {
	$$ = new WhileNode($5, $2, true);
	handleProd("iteration_statement -> DO statement WHILE OPENPAR expression CLOSEPAR SEMI\n");}
	| FOR OPENPAR SEMI SEMI CLOSEPAR statement {
	list<ASTNode*> tmpList;
	bool arr[3] = {0, 0, 0};
	$$ = new ForNode(tmpList, arr, $6);
	handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI SEMI expression CLOSEPAR statement {
	list<ASTNode*> tmpList;
	tmpList.push_back($5);
	bool arr[3] = {0, 0, 1};
	$$ = new ForNode(tmpList, arr, $7);
	handleProd("iteration_statement -> FOR OPENPAR SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($4);
    bool arr[3] = {0, 1, 0};
    $$ = new ForNode(tmpList, arr, $7);
	handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($4);
    tmpList.push_back($6);
    bool arr[3] = {0, 1, 1};
    $$ = new ForNode(tmpList, arr, $8);
	handleProd("iteration_statement -> FOR OPENPAR SEMI expression SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($3);
    bool arr[3] = {1, 0, 0};
    $$ = new ForNode(tmpList, arr, $7);
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($3);
    tmpList.push_back($6);
    bool arr[3] = {1, 0, 1};
    $$ = new ForNode(tmpList, arr, $8);
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI SEMI expression CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($3);
    tmpList.push_back($5);
    bool arr[3] = {1, 1, 0};
    $$ = new ForNode(tmpList, arr, $8);
	handleProd("iteration_statement -> FOR OPENPAR expression SEMI expression SEMI CLOSEPAR statement\n");}
	| FOR OPENPAR expression SEMI expression SEMI expression CLOSEPAR statement {
	list<ASTNode*> tmpList;
    tmpList.push_back($3);
    tmpList.push_back($5);
    tmpList.push_back($7);
    bool arr[3] = {1, 1, 1};
    $$ = new ForNode(tmpList, arr, $9);
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
	$$ = new ReturnNode(NULL);
	handleProd("jump_statement -> RETURN SEMI\n");}
	| RETURN expression SEMI {
	$$ = new ReturnNode($2);
	handleProd("jump_statement -> RETURN expression SEMI\n");}
	;

expression
	: assignment_expression {
	$$ = $1;
	handleProd("expression -> assignment_expression\n");}
	| expression COMMA assignment_expression {
	list<ASTNode*> seq = $1->getChildren();
    seq.push_back($3);
    $$ = new SeqNode('x', seq);
	handleProd("expression -> expression COMMA assignment_expression\n");}
	;

assignment_expression
	: conditional_expression {
	$$ = $1;
	handleProd("assignment_expression -> conditional_expression\n");}
	| unary_expression assignment_operator assignment_expression {
	switch ($2) {
	    case ASSIGN:
            $$ = new AssignNode($1, $3);
            break;
        case MUL_ASSIGN:
            $$ = new AssignNode($1, new BinaryMathNode(STAR, $1, $3));
            break;
        case DIV_ASSIGN:
            $$ = new AssignNode($1, new BinaryMathNode(SLASH, $1, $3));
            break;
        case MOD_ASSIGN:
            $$ = new AssignNode($1, new BinaryMathNode(MODULO, $1, $3));
            break;
        case ADD_ASSIGN:
            $$ = new AssignNode($1, new BinaryMathNode(PLUS, $1, $3));
            break;
        case SUB_ASSIGN:
            $$ = new AssignNode($1, new BinaryMathNode(MINUS, $1, $3));
            break;
        //bitwise assigns
	    default:
	        break;
	}
	handleProd("assignment_expression -> unary_expression assignment_operator assignment_expression\n");}
	;

assignment_operator
	: ASSIGN {
	$$ = ASSIGN;
	handleProd("assignment_operator -> ASSIGN\n");}
	| MUL_ASSIGN {
	$$ = MUL_ASSIGN;
	handleProd("assignment_operator -> MUL_ASSIGN\n");}
	| DIV_ASSIGN {
	$$ = DIV_ASSIGN;
	handleProd("assignment_operator -> DIV_ASSIGN\n");}
	| MOD_ASSIGN {
	$$ = MOD_ASSIGN;
	handleProd("assignment_operator -> MOD_ASSIGN\n");}
	| ADD_ASSIGN {
	$$ = ADD_ASSIGN;
	handleProd("assignment_operator -> ADD_ASSIGN\n");}
	| SUB_ASSIGN {
	$$ = SUB_ASSIGN;
	handleProd("assignment_operator -> SUB_ASSIGN\n");}
	| LEFT_ASSIGN {
	$$ = LEFT_ASSIGN;
	handleProd("assignment_operator -> LEFT_ASSIGN\n");}
	| RIGHT_ASSIGN {
	$$ = RIGHT_ASSIGN;
	handleProd("assignment_operator -> RIGHT_ASSIGN\n");}
	| AND_ASSIGN {
	$$ = AND_ASSIGN;
	handleProd("assignment_operator -> AND_ASSIGN\n");}
	| XOR_ASSIGN {
	$$ = XOR_ASSIGN;
	handleProd("assignment_operator -> XOR_ASSIGN\n");}
	| OR_ASSIGN {
	$$ = OR_ASSIGN;
	handleProd("assignment_operator -> OR_ASSIGN\n");}
	;

conditional_expression
	: logical_or_expression {
	$$ = $1;
	handleProd("conditional_expression -> logical_or_expression\n");}
	| logical_or_expression TERNARY expression COLON conditional_expression {
	$$ = new IfNode($1, $3, $5);
	handleProd("conditional_expression -> logical_or_expression TERNARY expression COLON conditional_expression \n");}
	;

constant_expression
	: conditional_expression {
	$$ = $1;
	handleProd("constant_expression -> conditional_expression\n");}
	;

logical_or_expression
	: logical_and_expression {
	$$ = $1;
	handleProd("logical_or_expression -> logical_and_expression\n");}
	| logical_or_expression OR_OP logical_and_expression {
	$$ = new LogicalNode(OR_OP, $1, $3);
	handleProd("logical_or_expression -> logical_or_expression OR_OP logical_and_expression\n");}
	;

logical_and_expression
	: inclusive_or_expression {
	$$ = $1;
	handleProd("logical_and_expression -> inclusive_or_expression\n");}
	| logical_and_expression AND_OP inclusive_or_expression {
	$$ = new LogicalNode(AND_OP, $1, $3);
	handleProd("logical_and_expression -> logical_and_expression AND_OP inclusive_or_expression\n");}
	;

inclusive_or_expression
	: exclusive_or_expression {
	$$ = $1;
	handleProd("inclusive_or_expression -> exclusive_or_expression\n");}
	| inclusive_or_expression BAR exclusive_or_expression {
	$$ = new BitwiseNode(BAR, $1, $3);
	handleProd("inclusive_or_expression -> inclusive_or_expression BAR exclusive_or_expression\n");}
	;

exclusive_or_expression
	: and_expression {
	$$ = $1;
	handleProd("exclusive_or_expression -> and_expression\n");}
	| exclusive_or_expression XOR and_expression {
	$$ = new BitwiseNode(XOR, $1, $3);
	handleProd("exclusive_or_expression -> exclusive_or_expression XOR and_expression\n");}
	;

and_expression
	: equality_expression {
	$$ = $1;
	handleProd("and_expression -> equality_expression\n");}
	| and_expression AND equality_expression {
	$$ = new BitwiseNode(AND, $1, $3);
	handleProd("and_expression -> and_expression AND equality_expression\n");}
	;

equality_expression
	: relational_expression {
	$$ = $1;
	handleProd("equality_expression -> relational_expression\n");}
	| equality_expression EQ_OP relational_expression {
	$$ = new RelationalNode(EQ_OP, $1, $3);
	handleProd("equality_expression -> equality_expression EQ_OP relational_expression\n");}
	| equality_expression NE_OP relational_expression {
	$$ = new RelationalNode(NE_OP, $1, $3);
	handleProd("equality_expression -> equality_expression NE_OP relational_expression\n");}
	;

relational_expression
	: shift_expression {
	$$ = $1;
	handleProd("relational_expression -> shift_expression\n");}
	| relational_expression LESSTH shift_expression {
	$$ = new RelationalNode(LESSTH, $1, $3);
	handleProd("relational_expression -> relational_expression LESSTH shift_expression\n");}
	| relational_expression GREATH shift_expression {
	$$ = new RelationalNode(GREATH, $1, $3);
	handleProd("relational_expression -> relational_expression GREATH shift_expression\n");}
	| relational_expression LE_OP shift_expression {
	$$ = new RelationalNode(LE_OP, $1, $3);
	handleProd("relational_expression -> relational_expression LE_OP shift_expression\n");}
	| relational_expression GE_OP shift_expression {
	$$ = new RelationalNode(GE_OP, $1, $3);
	handleProd("relational_expression -> relational_expression GE_OP shift_expression\n");}
	;

shift_expression
	: additive_expression {
	$$ = $1;
	handleProd("shift_expression -> additive_expression\n");}
	| shift_expression LEFT_OP additive_expression {
	$$ = new BitwiseNode(LEFT_OP, $1, $3);
	handleProd("shift_expression -> shift_expression LEFT_OP additive_expression\n");}
	| shift_expression RIGHT_OP additive_expression {
	$$ = new BitwiseNode(RIGHT_OP, $1, $3);
	handleProd("shift_expression -> shift_expression RIGHT_OP additive_expression\n");}
	;

additive_expression
	: multiplicative_expression {
	$$ = $1;
	handleProd("additive_expression -> multiplicative_expression\n");}
	| additive_expression PLUS multiplicative_expression {
	$$ = new BinaryMathNode(PLUS, $1, $3);
	handleProd("additive_expression -> additive_expression PLUS multiplicative_expression\n");}
	| additive_expression MINUS multiplicative_expression {
	$$ = new BinaryMathNode(MINUS, $1, $3);
	handleProd("additive_expression -> additive_expression MINUS multiplicative_expression\n");}
	;

multiplicative_expression
	: cast_expression {
	$$ = $1;
	handleProd("multiplicative_expression -> cast_expression\n");}
	| multiplicative_expression STAR cast_expression {
	$$ = new BinaryMathNode(STAR, $1, $3);
	handleProd("multiplicative_expression -> multiplicative_expression STAR cast_expression\n");}
	| multiplicative_expression SLASH cast_expression {
	$$ = new BinaryMathNode(SLASH, $1, $3);
	handleProd("multiplicative_expression -> multiplicative_expression SLASH cast_expression\n");}
	| multiplicative_expression MODULO cast_expression {
	$$ = new BinaryMathNode(MODULO, $1, $3);
	handleProd("multiplicative_expression -> multiplicative_expression MODULO cast_expression\n");}
	;

cast_expression
	: unary_expression {
	$$ = $1;
	handleProd("cast_expression -> unary_expression\n");}
	| OPENPAR type_name CLOSEPAR cast_expression {
	$$ = new CastNode($2, $4);
	handleProd("cast_expression -> OPENPAR type_name CLOSEPAR cast_expression\n");}
	;

unary_expression
	: postfix_expression {
    $$ = $1;
	handleProd("unary_expression -> postfix_expression\n");}
	| INC_OP unary_expression {
	auto tmp = new BinaryMathNode(PLUS, $2, new IntNode(1));
	$$ = new AssignNode($2, tmp);
	handleProd("unary_expression -> INC_OP unary_expression\n");}
	| DEC_OP unary_expression {
	auto tmp = new BinaryMathNode(MINUS, $2, new IntNode(1));
	$$ = new AssignNode($2, tmp);
	handleProd("unary_expression -> DEC_OP unary_expression\n");}
	| unary_operator cast_expression {
	switch($1) {
	    case AND:
	        $$ = new UnaryNode(AND, $2);
	        break;
	    case STAR:
	        $$ = new UnaryNode(STAR, $2);
	        break;
	    case PLUS:
	        $$ = new UnaryNode(PLUS, $2);
	        break;
	    case MINUS:
	        $$ = new UnaryNode(MINUS, $2);
	        break;
	    case TILDE:
	        $$ = new UnaryNode(TILDE, $2);
	        break;
	    case BANG:
	        $$ = new UnaryNode(BANG, $2);
	        break;
	    default:
	        cout << "Something went wrong with unary nodes." << endl;
	        $$ = new ASTNode();
	        break;
	}
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
	$$ = AND;
	handleProd("unary_operator -> AND\n");}
	| STAR {
	$$ = STAR;
	handleProd("unary_operator -> STAR\n");}
	| PLUS {
	$$ = PLUS;
	handleProd("unary_operator -> PLUS\n");}
	| MINUS {
	$$ = MINUS;
	handleProd("unary_operator -> MINUS\n");}
	| TILDE {
	$$ = TILDE;
	handleProd("unary_operator -> TILDE\n");}
	| BANG {
	$$ = BANG;
	handleProd("unary_operator -> BANG\n");}
	;

postfix_expression
	: primary_expression {
    $$ = $1;
	handleProd("postfix_expression -> primary_expression\n");}
	| postfix_expression OPENSQ expression CLOSSQ {
	//postfix_expression can be a variable or array as far as i care
	list<ASTNode*> sizes = $1->getSizes();
    sizes.push_back($3);
    if ($1->getChildren().empty()) {
    //$1 is an identifier
    	$$ = new ArrayNode($1, sizes);
    } else {
    //$1 is an array
        $$ = new ArrayNode($1->getChildren().front(), sizes);
    }

	handleProd("postfix_expression -> postfix_expression OPENSQ expression CLOSSQ\n");}

	| postfix_expression OPENPAR CLOSEPAR {
    tuple<SymbolTableNode2*, string> result = getTable()->search($1->getName());
    SymbolTableNode2* it;
    string status;
    tie(it, status) = result;
	if(status == "not") //a function of the same name was not found
	{
	    outputError("Not found", "Function not found", false);
	}
	else if(status != "not")
	{
	    list<set<int>> compareEmpty;
	    if(compareEmpty != it->paramTypes)
        {
	        outputError("Incorrect parameters", "Mismatched parameters", false);
        }
	}

	list<set<int>> empty;
	list<ASTNode*> empty2;
	list<pair<string, set<int>>> args;
	$$ = new FuncNode($1->getName(), empty, empty2, args, 2);
	$$->setTypes(it->types);
	handleProd("postfix_expression -> postfix_expression OPENPAR CLOSEPAR\n");}

	| postfix_expression OPENPAR argument_expression_list CLOSEPAR {
	//function call with parameters

	list<set<int>> types;

    for(auto iterator : $3->getChildren())
    {
        types.push_back(iterator->getTypes());
    }

    tuple<SymbolTableNode2*, string> result = getTable()->search($1->getName());
    SymbolTableNode2* it;
    string status;
    tie(it, status) = result;
    if(status == "not") //a function of the same name was not found
    {
        outputError("Not found", "Function not found", false);
    }
    else if(status != "not")
    {
        if(types != it->paramTypes)
        {
            outputError("Incorrect parameters", "Mismatched parameters", false);
        }
    }

	list<ASTNode*> tmpList;
	tmpList.push_back($3);
	list<pair<string, set<int>>> args;
	$$ = new FuncNode($1->getName(), types, tmpList, args, 2);
	$$->setTypes(it->types);
	handleProd("postfix_expression -> postfix_expression OPENPAR argument_expression_list CLOSEPAR\n");}

	| postfix_expression PERIOD identifier {
	$$ = new ASTNode(); //structs
	handleProd("postfix_expression -> postfix_expression PERIOD identifier\n");}
	| postfix_expression PTR_OP identifier {
	$$ = new ASTNode(); //pointers
	handleProd("postfix_expression -> postfix_expression PTR_OP identifier\n");}
	| postfix_expression INC_OP {
	auto tmp = new BinaryMathNode(PLUS, $1, new IntNode(1));
    $$ = new AssignNode($1, tmp);
	handleProd("postfix_expression -> postfix_expression INC_OP\n");}
	| postfix_expression DEC_OP {
	auto tmp = new BinaryMathNode(MINUS, $1, new IntNode(1));
    $$ = new AssignNode($1, tmp);
	handleProd("postfix_expression -> postfix_expression DEC_OP\n");}
	;

primary_expression
	: identifier {
	$$ = $1;
	handleProd("primary_expression -> identifier\n");}
	| constant {
	$$ = $1;
	handleProd("primary_expression -> constant\n");}
	| string {
	$$ = $1;
	handleProd("primary_expression -> string\n");}
	| OPENPAR expression CLOSEPAR {
	$$ = $2;
	handleProd("primary_expression -> OPENPAR expression CLOSEPAR\n");}
	;

argument_expression_list
	: assignment_expression {
	list<ASTNode*> seq;
	seq.push_back($1);
	$$ = new SeqNode('a', seq);
	handleProd("argument_expression_list -> assignment_expression\n");}
	| argument_expression_list COMMA assignment_expression {
	list<ASTNode*> seq = $1->getChildren();
    seq.push_back($3);
    $$ = new SeqNode('a', seq);
	handleProd("argument_expression_list -> argument_expression_list COMMA assignment_expression\n");}
	;

constant
	: INTEGER_CONSTANT {
	$$ = new IntNode($1);
	handleProd("constant -> INTEGER_CONSTANT\n");}
	| CHARACTER_CONSTANT {
	$$ = new CharNode($1);
	handleProd("constant -> CHARACTER_CONSTANT\n");}
	| FLOATING_CONSTANT {
	$$ = new FloatNode($1);
	handleProd("constant -> FLOATING_CONSTANT\n");}
	| ENUMERATION_CONSTANT {
	$$ = new ASTNode();
	handleProd("constant -> ENUMERATION_CONSTANT\n");}
	;

string
	: STRING_LITERAL {
	$$ = new StringNode($1);
	handleProd("string -> STRING_LITERAL\n");}
	;

identifier
	: IDENTIFIER {
	$$ = new IdentifierNode($1);
	idNode = $$;
	tuple<SymbolTableNode2*, string> result = getTable()->search(*$1);
    SymbolTableNode2* it;
    string status;
    tie(it, status) = result;
    if (status != "not") {
        $$->setSymbolNode(it);
    }
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
    for(int i = 0; i < 6; i++) //initialize all debug options to false
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
                    else if(strcmp(argv[i],"-a") == 0)
                        debug[5] = true;
                    else if(strcmp(argv[i],"-3") == 0)
                        debug[6] = true;
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
        string outputF = argv[argc-1];
        outputF.erase(0, 11);
        outputF.erase(outputF.length()-2, 2);
        outputF = "tests/output_tokens/tokens_" + outputF;
        outputF += ".txt";
        TOKENPATH = outputF;
        ofstream ofs;
        ofs.open(TOKENPATH, std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }
    if(debug[2] && debug[0])
    {
        string outputF = argv[argc-1];
        outputF.erase(0, 11);
        outputF.erase(outputF.length()-2, 2);
        outputF = "tests/output_symbol/symbol_" + outputF;
        outputF += ".txt";
        SYMBOLPATH = outputF;
        ofstream ofs;
        ofs.open(SYMBOLPATH, std::ofstream::out | std::ofstream::trunc);
        ofs.close();
    }

    string outputF = argv[argc-1];
    outputF.erase(0, 11);
    outputF.erase(outputF.length()-2, 2);
    outputF = "tests/output_MIPS/MIPS_" + outputF;
    outputF += ".s";
    MIPSPATH = outputF;

	yyparse();
	root_ptr->walk();
	root_ptr->output3ac();
    auto tac = root_ptr->get3ac();
    generateMIPS(tac);

    if(printProd)
    {
        string outputF = argv[argc-1];
        outputF.erase(0, 11);
        outputF.erase(outputF.length()-2, 2);
        outputF = "tests/output_prods/prods_" + outputF;
        outputF += ".txt";
        PRODPATH = outputF;
        ofstream ofs;
        ofs.open(PRODPATH, std::ofstream::out | std::ofstream::trunc);
        ofs << prodStream.str();
        ofs.close();
    }
    if(debug[5])
    {
        string outputF = argv[argc-1];
        outputF.erase(0, 11);
        outputF.erase(outputF.length()-2, 2);
        outputF = "tests/output_ast/ast_" + outputF;
        outputF += ".dot";
        ASTPATH = outputF;
        tree<ASTNode*> ast;
        ASTNode::copyTree(root_ptr, ast);
        kptree::print_tree_bracketed(ast);
    }
    if(debug[6])
    {
        string outputF = argv[argc-1];
        outputF.erase(0, 11);
        outputF.erase(outputF.length()-2, 2);
        outputF = "tests/output_3AC/3AC_" + outputF;
        outputF += ".txt";
        THREEACPATH = outputF;
        tree<ASTNode*> ast;
        ofstream ofs;
        ofs.open(THREEACPATH, std::ofstream::out | std::ofstream::trunc);
    }
	return 0;
}

