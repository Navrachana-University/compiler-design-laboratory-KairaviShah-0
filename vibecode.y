%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char *yytext;
void yyerror(const char *s);
int yylex(void);

// TAC generation variables
int temp_count = 0;
int label_count = 0;

// Symbol table entry
typedef struct {
    char *name;
    char *type;
} Symbol;

Symbol symbol_table[1000];
int symbol_count = 0;

// TAC output file
FILE *tac_file;

// Function to generate new temporary variable
char *new_temp() {
    char *temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

// Function to generate new label
char *new_label() {
    char *label = malloc(10);
    sprintf(label, "L%d", label_count++);
    return label;
}

// Function to emit TAC
void emit_tac(char *result, char *arg1, char *op, char *arg2) {
    fprintf(tac_file, "%s = %s %s %s\n", result, arg1, op, arg2);
}

// Function to emit TAC for single operand or assignment
void emit_tac_single(char *result, char *op, char *arg) {
    fprintf(tac_file, "%s = %s%s\n", result, op, arg);
}

// Function to emit label
void emit_label(char *label) {
    fprintf(tac_file, "%s:\n", label);
}

// Function to emit jump
void emit_jump(char *op, char *arg, char *label) {
    fprintf(tac_file, "%s %s %s\n", op, arg, label);
}

// Function to add symbol to table
void add_symbol(char *name, char *type) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].type = strdup(type);
    symbol_count++;
}

// Function to check if symbol exists
int symbol_exists(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return 1;
        }
    }
    return 0;
}
%}

%union {
    char *str;
    struct {
        char *code;
        char *place;
        char *begin;
        char *after;
    } expr;
}

%token VIBECHECK YEET SLAPS SENDIT SPILLTHETEA SUS NOCAP
%token GOAT LIT_TYPE DRIP_TYPE GHOST_TYPE KEEPIT100
%token <str> EQ NE LE GE LT GT
%token <str> DRIPPING LITNUM IDENTIFIER STRING

%type <str> type
%type <expr> expr statement statements function_call
%type <expr> program function functions declaration declarations

// Operator precedence
%left EQ NE
%left LE GE LT GT
%left '+' '-'
%left '*' '/'
%right '='

%%

program:
    VIBECHECK declarations functions YEET {
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s", $2.code, $3.code);
        fprintf(tac_file, "%s", $$.code);
    }
    ;

declarations:
    /* empty */ {
        $$.code = strdup("");
    }
    | declarations declaration {
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s", $1.code, $2.code);
    }
    ;

declaration:
    GOAT type IDENTIFIER ';' {
        if (symbol_exists($3)) {
            yyerror("Bruh, variable already declared");
        }
        add_symbol($3, $2);
        $$.code = strdup("");
    }
    ;

type:
    LIT_TYPE { $$ = strdup("int"); }
    | DRIP_TYPE { $$ = strdup("float"); }
    ;

functions:
    /* empty */ {
        $$.code = strdup("");
    }
    | functions function {
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s", $1.code, $2.code);
    }
    ;

function:
    SLAPS type IDENTIFIER '(' ')' '{' statements '}' {
        $$.code = malloc(1000);
        sprintf($$.code, "%s:\n%sret\n", $3, $7.code);
    }
    | SLAPS GHOST_TYPE IDENTIFIER '(' ')' '{' statements '}' {
        $$.code = malloc(1000);
        sprintf($$.code, "%s:\n%sret\n", $3, $7.code);
    }
    ;

statements:
    /* empty */ {
        $$.code = strdup("");
    }
    | statements statement {
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s", $1.code, $2.code);
    }
    ;

statement:
    declaration {
        $$.code = $1.code;
    }
    | IDENTIFIER '=' expr ';' {
        if (!symbol_exists($1)) {
            yyerror("Bruh, undeclared variable");
        }
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s = %s\n", $3.code, $1, $3.place);
    }
    | SPILLTHETEA expr ';' {
        $$.code = malloc(1000);
        char *temp = new_temp();
        sprintf($$.code, "%s%s = %s\nprint %s\n", $2.code, temp, $2.place, temp);
    }
    | SPILLTHETEA STRING ';' {
        $$.code = malloc(1000);
        sprintf($$.code, "print \"%s\"\n", $2);
    }
    | SENDIT expr ';' {
        $$.code = malloc(1000);
        sprintf($$.code, "%sret %s\n", $2.code, $2.place);
    }
    | SUS '(' expr ')' '{' statements '}' {
        char *label1 = new_label();
        char *label2 = new_label();
        $$.code = malloc(1000);
        sprintf($$.code, "%sif %s goto %s\ngoto %s\n%s:\n%s%s:\n",
                $3.code, $3.place, label1, label2, label1, $6.code, label2);
    }
    | SUS '(' expr ')' '{' statements '}' NOCAP '{' statements '}' {
        char *label1 = new_label();
        char *label2 = new_label();
        char *label3 = new_label();
        $$.code = malloc(1000);
        sprintf($$.code, "%sif %s goto %s\ngoto %s\n%s:\n%sgoto %s\n%s:\n%s%s:\n",
                $3.code, $3.place, label1, label2, label1, $6.code, label3, label2, $10.code, label3);
    }
    | KEEPIT100 '(' expr ')' '{' statements '}' {
        char *begin = new_label();
        char *label1 = new_label();
        char *label2 = new_label();
        $$.code = malloc(1000);
        sprintf($$.code, "%s:\n%sif %s goto %s\ngoto %s\n%s:\n%sgoto %s\n%s:\n",
                begin, $3.code, $3.place, label1, label2, label1, $6.code, begin, label2);
    }
    | function_call ';' {
        $$.code = $1.code;
    }
    ;

function_call:
    IDENTIFIER '(' ')' {
        $$.code = malloc(1000);
        $$.place = new_temp();
        sprintf($$.code, "%s = call %s\n", $$.place, $1);
    }
    ;

expr:
    LITNUM {
        $$.place = $1;
        $$.code = strdup("");
    }
    | DRIPPING {
        $$.place = $1;
        $$.code = strdup("");
    }
    | IDENTIFIER {
        if (!symbol_exists($1)) {
            yyerror("Bruh, undeclared variable");
        }
        $$.place = $1;
        $$.code = strdup("");
    }
    | expr '+' expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s + %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr '-' expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s - %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr '*' expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s * %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr '/' expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s / %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr EQ expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s == %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr NE expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s != %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr LE expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s <= %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr GE expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s >= %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr LT expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s < %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | expr GT expr {
        $$.place = new_temp();
        $$.code = malloc(1000);
        sprintf($$.code, "%s%s%s = %s > %s\n", $1.code, $3.code, $$.place, $1.place, $3.place);
    }
    | '(' expr ')' {
        $$.place = $2.place;
        $$.code = $2.code;
    }
    | function_call {
        $$.place = $1.place;
        $$.code = $1.code;
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
    exit(1);
}

int main() {
    tac_file = fopen("tac_output.txt", "w");
    if (!tac_file) {
        fprintf(stderr, "Cannot open TAC output file\n");
        return 1;
    }
    yyparse();
    fclose(tac_file);
    return 0;
}