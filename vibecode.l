%{
#include "vibecode.tab.h"
#include <string.h>
extern int yylineno;
%}

%option noyywrap
%option yylineno

%%

"vibecheck"              { return VIBECHECK; }              // Program start
"yeet"                   { return YEET; }                   // Program end
"slaps"                  { return SLAPS; }                  // Function definition
"sendit"                 { return SENDIT; }                 // Return statement
"spillthetea"            { return SPILLTHETEA; }            // Print statement
"sus"                    { return SUS; }                    // If statement
"nocap"                  { return NOCAP; }                  // Else statement
"goat"                   { return GOAT; }                   // Variable declaration
"lit"                    { return LIT_TYPE; }               // Integer type
"drip"                   { return DRIP_TYPE; }              // Float type
"ghost"                  { return GHOST_TYPE; }             // Void type
"keepit100"              { return KEEPIT100; }              // While loop

"=="                     { yylval.str = strdup(yytext); return EQ; }       // Equality
"!="                     { yylval.str = strdup(yytext); return NE; }       // Inequality
"<="                     { yylval.str = strdup(yytext); return LE; }       // Less than or equal
">="                     { yylval.str = strdup(yytext); return GE; }       // Greater than or equal
"<"                      { yylval.str = strdup(yytext); return LT; }       // Less than
">"                      { yylval.str = strdup(yytext); return GT; }       // Greater than

[0-9]+\.[0-9]+          { yylval.str = strdup(yytext); return DRIPPING; }   // Float literal
[0-9]+                   { yylval.str = strdup(yytext); return LITNUM; }     // Integer literal

#_([a-zA-Z][_a-zA-Z0-9]*) { yylval.str = strdup(yytext + 2); return IDENTIFIER; } // Identifier (starts with #_)

\"[^"]*\"               { yylval.str = strdup(yytext + 1); yylval.str[strlen(yylval.str) - 1] = '\0'; return STRING; } // String literal

"="                      { return '='; }                   // Assignment
"+"                      { return '+'; }                   // Addition
"-"                      { return '-'; }                   // Subtraction
"*"                      { return '*'; }                   // Multiplication
"/"                      { return '/'; }                   // Division
"("                      { return '('; }                   // Left parenthesis
")"                      { return ')'; }                   // Right parenthesis
"{"                      { return '{'; }                   // Left curly brace
"}"                      { return '}'; }                   // Right curly brace
";"                      { return ';'; }                   // Semicolon

[ \t\r\n]+             { /* skip whitespace */ }          // Ignore whitespace

.                      { fprintf(stderr, "Bruh, invalid token at line %d: %s\n", yylineno, yytext); }

%%