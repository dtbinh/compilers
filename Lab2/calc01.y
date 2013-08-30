%{
#include	<stdio.h>
#include	<stdlib.h>
#define 	MAIS		1
#define 	MENOS		2
#define 	VEZES		3
#define 	DIV		4
%}
%token	DOLAR
%token	CTE
%token	OPAD
%token	OPMULT
%token	ABPAR
%token	FPAR
%%
line	:	expr	DOLAR	{
				printf("valor: %d\n", $1);
			}
		;
expr	:	expr	OPAD	term
		{
			switch ($2) 
			{
				case MAIS : $$ = $1 + $3; break;
				case MENOS : $$ = $1 - $3; break;
			}
		}
		|	term
		;
term	:	term	OPMULT fat
		{
			switch ($2) 
			{
				case VEZES: $$ = $1 * $3; break;
				case DIV: $$ = $1 / $3; break;
			}
		}
		|	fat
		;
fat	:	CTE
		|	ABPAR expr	 FPAR	 {$$ = $2;}
		;
%%
#include "lex.yy.c"