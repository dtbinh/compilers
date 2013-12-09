%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 		LT 		1
#define 		LE 		2
#define		GT			3
#define		GE			4
#define		EQ			5
#define		NE			6
#define		MAIS     7
#define		MENOS    8
#define		MULT    	9
#define		DIV   	10
#define		RESTO   	11

/*   Definicao dos tipos de identificadores   */

#define 	IDPROG		1
#define 	IDVAR			2

/*  Definicao dos tipos de variaveis   */

#define 	NOTVAR		0
#define 	INTEGER		1
#define 	LOGICAL		2
#define 	FLOAT			3
#define 	CHAR			4

/*   Definicao de outras constantes   */

#define	NCLASSHASH	23
#define	TRUE			1
#define	FALSE			0

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[3] = {" ", "IDPROG", "IDVAR"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NOTVAR",
	"INTEGER", "LOGICAL", "FLOAT", "CHAR"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
	char *cadeia;
	int tid, tvar;
	char inic, ref;
	simbolo prox;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica  */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;

/* Prototipos das funcoes para a tabela de simbolos e analise semantica */

void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int);
int hash (char *);
simbolo ProcuraSimb (char *);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void Incompatibilidade (char *);
void VerificaInicRef (void);

%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
	char cadeia[50];
	int atr, valint;
	float valreal;
	char carac;
   simbolo simb;
   int tipoexpr;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type 		<tipoexpr> 	Expressao  ExprAux1 ExprAux2
								ExprAux3   ExprAux4   Termo   Fator
%type			<simb>		Variavel
%token		<cadeia>		ID
%token		<carac>		CTCARAC
%token		<valint>		CTINT
%token		<valreal>	CTREAL
%token		<cadeia>		CADEIA
%token						OR
%token						AND
%token						NOT
%token		<atr>			OPREL
%token		<atr>			OPAD
%token		<atr>			OPMULT
%token						NEG
%token		ABPAR
%token		FPAR
%token		ABCOL
%token		FCOL
%token		ABCHAV
%token		FCHAV
%token		VIRG
%token		PVIRG
%token		ATRIB
%token		CARAC
%token		ENQUANTO
%token		ESCREVER
%token		FALSO
%token		INT
%token		LER
%token		LOGIC
%token		PROGRAMA
%token		REAL
%token		SE
%token		SENAO
%token		VAR
%token		VERDADE
%token		<carac>		INVAL
%%
/* Producoes da gramatica:

	Os terminais sao escritos e, depois de alguns,
	para alguma estetica, ha mudanca de linha       */

Prog		:	{InicTabSimb ();}  PROGRAMA   ID   PVIRG  {
					printf ("programa %s ;\n", $3);
               InsereSimb ($3, IDPROG, NOTVAR);
				}  Decls   CmdComp  {
            	VerificaInicRef ();
            	ImprimeTabSimb ();
            }
         ;
Decls 	:
			|	VAR  {printf ("var\n");}   ListDecl
         ;
ListDecl	:	Declaracao    |   ListDecl   Declaracao
         ;
Declaracao:	Tipo   ListElemDecl   PVIRG  {printf (";\n");}
         ;
Tipo		: 	INT  {printf ("int "); tipocorrente = INTEGER;}
			|	REAL  {printf ("real "); tipocorrente = FLOAT;}
         | 	CARAC  {printf ("carac "); tipocorrente = CHAR;}
         |  LOGIC  {printf ("logic "); tipocorrente = LOGICAL;}
         ;
ListElemDecl:	ElemDecl
			|	ListElemDecl   VIRG   {printf (", ");}   ElemDecl
         ;
ElemDecl :	ID   {
					printf ("%s ", $1);
               if  (ProcuraSimb ($1)  !=  NULL)
						DeclaracaoRepetida ($1);
					else
						InsereSimb ($1,  IDVAR,  tipocorrente);
				}
			|  ID   ABCOL   {
         		printf ("%s [ ", $1);
               if  (ProcuraSimb ($1)  !=  NULL)
						DeclaracaoRepetida ($1);
					else
						InsereSimb ($1,  IDVAR,  tipocorrente);
         	}   ListDim
         	FCOL   {printf ("] ");}
         ;
ListDim	: 	CTINT   {printf ("%d ", $1);}
			|  ListDim   VIRG   CTINT   {printf (", %d ", $3);}
         ;
CmdComp	:  ABCHAV   {printf ("{\n");}   ListCmd   FCHAV   {printf ("}\n");}
         ;
ListCmd	:
			|  ListCmd   Comando
         ;
Comando  :  CmdComp
			|  CmdSe
         |  CmdEnquanto
			|  CmdLer
         |  CmdEscrever
         |  CmdAtrib
         ;
CmdSe		:  SE   ABPAR   {printf ("se ( ");}   Expressao   FPAR
				{printf (")\n");}   Comando   CmdSenao
         ;
CmdSenao	:
			|  SENAO   {printf ("senao\n");}   Comando
         ;
CmdEnquanto:	ENQUANTO   ABPAR   {printf ("enquanto ( ");}   Expressao
				FPAR   {printf (")\n");}   Comando
         ;
CmdLer	:  LER   ABPAR   {printf ("ler ( ");}   ListVar
				FPAR   PVIRG   {printf (") ;\n");}
         ;
ListVar	:  Variavel
			|  ListVar   VIRG  {printf (", ");}   Variavel
         ;
CmdEscrever:	ESCREVER   ABPAR   {printf ("escrever ( ");}   ListEscr
				FPAR   PVIRG   {printf (") ;\n");}
         ;
ListEscr	:	ElemEscr
			|  ListEscr   VIRG  {printf (", ");}   ElemEscr
         ;
ElemEscr	:  CADEIA  {printf ("\"%s\" ", $1);}
			|  Expressao
         ;
CmdAtrib :  Variavel  {
					if  ($1 != NULL) $1->inic = $1->ref = TRUE;
				}  ATRIB   {printf (":= ");}   Expressao
				PVIRG   {printf (";\n");}
         ;
Expressao:  ExprAux1
			|  Expressao   OR   {printf ("|| ");}   ExprAux1  {
         		if ($1 != LOGICAL || $4 != LOGICAL)
               	Incompatibilidade	("Operando improprio para OR");
               $$ = LOGICAL;
         	}
         ;
ExprAux1 :  ExprAux2
			|  ExprAux1   AND  {printf ("&& ");}   ExprAux2  {
         		if ($1 != LOGICAL || $4 != LOGICAL)
               	Incompatibilidade	("Operando improprio para AND");
               $$ = LOGICAL;
         	}
         ;
ExprAux2 :  ExprAux3
			|  NOT  {printf ("! ");}   ExprAux3  {
         		if ($3 != LOGICAL)
               	Incompatibilidade	("Operando improprio para NOT");
               $$ = LOGICAL;
         	}
         ;
ExprAux3 :  ExprAux4
			|  ExprAux4   OPREL   {
         		switch ($2) {
               	case LT: printf ("< "); break;
                  case LE: printf ("<= "); break;
                  case EQ: printf ("= "); break;
                  case NE: printf ("!= "); break;
                  case GT: printf ("> "); break;
                  case GE: printf (">= "); break;
               }
         	}   ExprAux4  {
            	switch ($2) {
               	case LT: case LE: case GT: case GE:
                  	if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                     	Incompatibilidade	("Operando improprio para operador relacional");
                     break;
                  case EQ: case NE:
                  	if (($1 == LOGICAL || $4 == LOGICAL) && $1 != $4)
                     	Incompatibilidade ("Operando improprio para operador relacional");
                     break;
               }
               $$ = LOGICAL;
            }
         ;
ExprAux4 :	Termo
			|  ExprAux4   OPAD   {
         		switch ($2) {
               	case MAIS: printf ("+ "); break;
                  case MENOS: printf ("- "); break;
               }
         	}  Termo  {
            	if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
               	Incompatibilidade	("Operando improprio para operador aritmetico");
               if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
               else $$ = INTEGER;
            }
         ;
Termo  	:  Fator
			|  Termo   OPMULT   {
         		switch ($2) {
               	case MULT: printf ("* "); break;
                  case DIV: printf ("/ "); break;
                  case RESTO: printf ("%% "); break;
               }
         	}   Fator  {
            	switch ($2) {
		     			case MULT: case DIV:
		        			if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
		               	Incompatibilidade	("Operando improprio para operador aritmetico");
		        			if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
		        			else $$ = INTEGER;
                  	break;
		     			case RESTO:
		        			if ($1 != INTEGER && $1 != CHAR ||  $4 != INTEGER && $4 != CHAR)
		               	Incompatibilidade ("Operando improprio para operador resto");
		        			$$ = INTEGER;
                  	break;
		     		}
            }
         ;
Fator		:  Variavel  {
					if  ($1 != NULL)  {
               	$1->ref  =  TRUE;
                  $$ = $1->tvar;
               }
				}
			|  CTINT  {printf ("%d ", $1); $$ = INTEGER;}
         |  CTREAL   {printf ("%g ", $1); $$ = FLOAT;}
         |  CTCARAC   {printf ("\'%c\' ", $1); $$ = CHAR;}
         |  VERDADE   {printf ("verdade ");  $$ = LOGICAL;}
         |  FALSO   {printf ("falso ");  $$ = LOGICAL;}
			|	NEG   {printf ("~ ");}   Fator  {
					if ($3 != INTEGER && $3 != FLOAT && $3 != CHAR)
						Incompatibilidade  ("Operando improprio para menos unario");
               if ($3 == FLOAT) $$ = FLOAT;
					else $$ = INTEGER;
		    	}
         |  ABPAR   {printf ("( ");}   Expressao   FPAR   {
         		printf (") ");
               $$ = $3;
         	}
         ;
Variavel	:  ID   {
					printf ("%s ", $1);
               simb = ProcuraSimb ($1);
					if (simb == NULL)   NaoDeclarado ($1);
					else if (simb->tid != IDVAR) TipoInadequado ($1);
               $$ = simb;
				}
			|  ID   ABCOL   {
         		printf ("%s [ ", $1);
               simb = ProcuraSimb ($1);
					if (simb == NULL)   NaoDeclarado ($1);
					else if (simb->tid != IDVAR) TipoInadequado ($1);
               $<simb>$ = simb;
         	}   ListSubscr
         	FCOL  {
            	printf ("] ");
               $$ = $<simb>3;
            }
         ;
ListSubscr: ExprAux4
			|  ListSubscr   VIRG  {printf (", ");}   ExprAux4
         ;
%%

/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
	int i;
	for (i = 0; i < NCLASSHASH; i++) 
		tabsimb[i] = NULL;
}

/*
	ProcuraSimb (cadeia): Procura cadeia na tabela de simbolos;
	Caso ela ali esteja, retorna um ponteiro para sua celula;
	Caso contrario, retorna NULL.
 */

simbolo ProcuraSimb (char *cadeia) {
	simbolo s; int i;
	i = hash (cadeia);
	for (s = tabsimb[i]; (s!=NULL) && strcmp(cadeia, s->cadeia); 
		s = s->prox);
	return s;
}

/*
	InsereSimb (cadeia, tid, tvar): Insere cadeia na tabela de
	simbolos, com tid como tipo de identificador e com tvar como
	tipo de variavel; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar) {
	int i; simbolo aux, s;
	i = hash (cadeia); aux = tabsimb[i];
	s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
	s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
	strcpy (s->cadeia, cadeia);
	s->tid = tid;		s->tvar = tvar;
	s->inic = FALSE;	s->ref = FALSE;
	s->prox = aux;	return s;
}

/*
	hash (cadeia): funcao que determina e retorna a classe
	de cadeia na tabela de simbolos implementada por hashing
 */

int hash (char *cadeia) {
	int i, h;
	for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
	h = h % NCLASSHASH;
	return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  */

void ImprimeTabSimb () {
	int i; simbolo s;
	printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i]) {
			printf ("Classe %d:\n", i);
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
				if (s->tid == IDVAR)
					printf (", %s, %d, %d", 
						nometipvar[s->tvar], s->inic, s->ref);
				printf(")\n");
			}
		}
}

/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s) {
	printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}

void NaoDeclarado (char *s) {
	printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
	printf ("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void Incompatibilidade (char *s) {
	printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

/*  Verificacao das variaveis inicializadas e referenciadas  */

void VerificaInicRef () {
	int i; simbolo s;

	printf ("\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i])
			for (s = tabsimb[i]; s!=NULL; s = s->prox)
				if (s->tid == IDVAR) {
					if (s->inic == FALSE)
						printf ("%s: Nao Inicializada\n", s->cadeia);
					if (s->ref == FALSE)
						printf ("%s: Nao Referenciada\n", s->cadeia);
				}
}

