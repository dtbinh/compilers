%{
#include	<stdio.h>
#include	<stdlib.h>
#define 	YYSTYPE float
%}
%token	DOLAR
%token	CTE
%token	MAIS
%token	VEZES
%token	ABPAR
%token	FPAR
%%
line	:	expr	DOLAR {
				printf("valor: %g\n",$1);
				return 0;}
		;
expr	:	expr	MAIS	term 	{$$ = $1 + $3;}
		|	term
		;
term	:	term	VEZES fat	{$$ = $1 * $3;}
		|	fat
		;
fat	:	CTE
		|	ABPAR	 expr	 FPAR	 {$$ = $2;}
		;
%%
#include "lex.yy.c"