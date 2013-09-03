%{
#include	<stdio.h>
#include	<stdlib.h>
#define MAIS	1
#define MENOS	2
#define VEZES	3
#define DIV	4
%}
%union {
	int valint, atr;
	float valfloat;
} 
%type 	<valfloat> 	expr  term  fat 
%token			DOLAR
%token	<valint>	CTINT
%token	<valfloat>	CTFLOAT
%token	<atr>		OPAD
%token	<atr>		OPMULT
%token			ABPAR
%token			FPAR
%%
line	:	expr	DOLAR {
				printf("valor: %g\n",$1);
			}
		;
expr	:	expr	OPAD	term
		{
			switch ($2) {
				case MAIS : $$ = $1 + $3; break;
				case MENOS : $$ = $1 - $3; break;
			}
		}
		|	term
		;
term	:	term	OPMULT fat
		{
			switch ($2) {
				case VEZES: $$ = $1 * $3; break;
				case DIV: $$ = $1 / $3; break;
			}
		}
		|	fat
		;
fat	:	CTINT		{$$ = (float)$1;}
		|	CTFLOAT
		|	ABPAR	 expr	 FPAR	 {$$ = $2;}
		;
%%
#include "lex.yy.c" 