%option noyywrap yylineno nounput noinput
%{
/* Matricula: 10240041 | Nombre: DIEGO DECIDERIO GARCIA */
#include "parser_lalr.tab.h"
#include <stdio.h>
#define MAX_LEXEMA 31
void registrar_identificador(const char *lexema, int linea);
%}

LETRA       [a-zA-Z_]
DIGITO      [0-9]
ID_VALIDO   {LETRA}({LETRA}|{DIGITO})*
NUMERO_VAL  {DIGITO}+([.]{DIGITO}+)?

%%
[ \t\r]+            { }
\n                  { }
"//"[^\n]*          { }
{ID_VALIDO}         {
                        if (yyleng > MAX_LEXEMA) {
                            fprintf(stderr,
                                    "ERROR_LEXICO linea=%d identificador_demasiado_largo\n",
                                    yylineno);
                            return (unsigned char) yytext[0];
                        }
                        registrar_identificador(yytext, yylineno);
                        return ID;
                    }
{NUMERO_VAL}        { return NUMERO; }
"="                 { return ASIGNA; }
"+"                 { return SUMA; }
"-"                 { return RESTA; }
"*"                 { return MULTIPLICA; }
"/"                 { return DIVIDE; }
"("                 { return PAR_IZQ; }
")"                 { return PAR_DER; }
";"                 { return PUNTO_COMA; }
"^"                 { return POTENCIA; }
.                   { return (unsigned char) yytext[0]; }
%%