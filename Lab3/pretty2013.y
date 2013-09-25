%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define		MAIS		7
#define		MENOS		8
int tab = 0;
%}
%union {
	char cadeia[50];
	int atr, valint;
	char carac;
}
%token		<cadeia>		ID
%token		<valint>		CTINT
%token		<atr>			OPAD
%token					ABPAR
%token					FPAR
%token					ABCHAV
%token					FCHAV
%token					PVIRG
%token					ATRIB
%token		<carac>		INVAL
%%
CmdComposto:	ABCHAV
				{tabular (); printf ("\{\n"); tab++;} 		
				ListCmds FCHAV 
				{tab--; tabular (); printf ("}\n");}
			;
ListCmds	:	Comando
			|	ListCmds Comando
			;
Comando		:	CmdAtrib
			|	CmdComposto
			;
CmdAtrib 	:	ID {tabular (); printf ("%s ", $1);}
				ATRIB {printf (":= ");}
				Expressao PVIRG {printf(";\n");}
			;
Expressao	:	Termo
			|	Expressao OPAD {
            		if ($2 == MAIS) printf ("+ ");
					else printf ("- ");
            	} Termo
			;
Termo	   	:	ID {printf ("%s ", $1);}
			|	CTINT {printf ("%d ", $1);}
			|  	ABPAR {printf("\( ");}
         		Expressao FPAR {printf (") ");}
          	;
%%
#include "lex.yy.c"
tabular () {
	int i;
	for (i = 1; i <= tab; i++)
   	printf ("\t");
}