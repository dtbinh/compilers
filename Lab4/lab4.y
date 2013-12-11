%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define     LT      1
#define     LE      2
#define     GT      3
#define     GE      4
#define     EQ      5
#define     NE      6

#define     MAIS    1
#define     MENOS   2

#define     MULT    1
#define     DIV     2
#define     RESTO   3

#define     IDPROG  1
#define     IDVAR   2

#define     NOTVAR  0
#define     INTEGER 1
#define     LOGICAL 2
#define     FLOAT   3
#define     CHAR    4

#define     NCLASSHASH  23
#define     TRUE        1
#define     FALSE       0
#define     MAXDIMS     10

int tab = 0;
char str[20];

char *nometipid[3] = {" ", "IDPROG", "IDVAR"};

char *nometipvar[5] = {"NOTVAR",
    "INTEGER", "LOGICAL", "FLOAT", "CHAR"
};

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
    char *cadeia;
    int tid, tvar, ndims, dims[MAXDIMS+1];
    char inic, ref, array;
    simbolo prox;
};

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;

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
void Esperado (char *);
void NaoEsperado (char *);

%}

%union {
    char cadeia[50];
    int atr, valint;
    float valreal;
    char carac;
    simbolo simb;
    int tipoexpr;
    int nsubscr;
}


%type       <tipoexpr>  Expressao  ExprAux1 ExprAux2 ExprAux3   ExprAux4   Termo   Fator
%type       <simb>      Variavel
%type       <nsubscr>   ListSubscr
%type       <cadeia>    ElemEscr
%type       <cadeia>    ChamaProc
%token      <cadeia>    ID
%token      <valint>    CTINT
%token      <atr>       OPAD
%token                  ABPAR
%token                  FPAR
%token                  ABCHAVE
%token                  FCHAVE
%token                  PVIRG
%token                  ATRIB
%token      <carac>     INVAL
%token                  ABCOL
%token                  AND
%token      <cadeia>    CADEIA
%token      <carac>     CTCARAC
%token                  FCOL
%token                  NEG
%token      <atr>       CTREAL
%token                  NOT
%token      <atr>       OPMULT
%token      <atr>       OPREL
%token                  OR
%token                  VIRG
%token                  CARAC
%token                  CHAMAR
%token                  ENQUANTO
%token                  ESCREVER
%token                  FALSO
%token                  FUNCAO
%token                  INT
%token                  LER
%token                  LOGIC
%token                  PARA
%token                  PROCEDIMENTO
%token                  PROGRAMA
%token                  REAL
%token                  REPETIR
%token                  RETORNAR
%token                  SE
%token                  SENAO
%token                  VAR
%token                  VERDADE
%%
Prog            :   {InicTabSimb();}
                    PROGRAMA   ID   PVIRG {printf("programa %s;\n", $3); InsereSimb($3, IDPROG, NOTVAR);}
                    Decls    SubProgs   CmdComp
                    {VerificaInicRef(); ImprimeTabSimb();}

Decls           :   |   VAR {printf("var ");}   ListDecl
                
ListDecl        :   Declaracao    |   ListDecl   Declaracao

Declaracao      :   Tipo   ListElemDecl   PVIRG {printf(";\n");}

Tipo            :   INT {printf("int "); tipocorrente = INTEGER;}
                |   REAL {printf("real ");tipocorrente = FLOAT;}
                |   CARAC {printf("carac ");tipocorrente = CHAR;}
                |   LOGIC {printf("logic ");tipocorrente = LOGICAL;}

ListElemDecl    :   ElemDecl      |     ListElemDecl   VIRG {printf(",");}   ElemDecl

ElemDecl        :   ID
                    {
                        printf("%s", $1);
                        if  (ProcuraSimb ($1)  !=  NULL)
                            DeclaracaoRepetida ($1);
                        else{
                            simb = InsereSimb ($1,  IDVAR,  tipocorrente);
                            simb->array = FALSE;
                        }
                    }
                    |    ID   ABCOL
                    {
                        printf("%s [", $1);
                        if  (ProcuraSimb ($1)  !=  NULL)
                            DeclaracaoRepetida ($1);
                        else{
                            simb = InsereSimb ($1,  IDVAR,  tipocorrente);
                            simb->array = TRUE;
                            simb->ndims = 0;
                        }
                    }  ListDim
                    FCOL {printf("]");}

ListDim         :   CTINT
                    {
                        printf("%d",$1);
                        if($1 <= 0) Esperado("Valor inteiro positivo");
                        simb->ndims++;simb->dims[simb->ndims] = $1;
                    }
                    |    ListDim   VIRG   CTINT
                    {
                        printf(",%d",$3);
                        if ($3 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims++; simb->dims[simb->ndims] = $3;
                    }

SubProgs        :   |   SubProgs   DeclSubProg

DeclSubProg     :   Cabecalho   Decls   CmdComp

Cabecalho       :   CabFunc   |   CabProc

CabFunc         :   FUNCAO {printf("funcao ");} Tipo   ID   ABPAR   FPAR   PVIRG   {printf("%s\();\n",$4);}
                |   FUNCAO {printf("funcao ");} Tipo   ID   ABPAR  {printf("%s\(",$4);}
                    ListParam   FPAR   PVIRG {printf(");\n");}

CabProc         :   PROCEDIMENTO   ID   ABPAR   FPAR   PVIRG {printf("procedimento %s\();\n",$2);}
                |   PROCEDIMENTO   ID   ABPAR   {printf("procedimento %s\(",$2);}
                    ListParam   FPAR   PVIRG {printf(");\n");}

ListParam       :   Parametro    |   ListParam   VIRG {printf(",");}   Parametro

Parametro       :   Tipo   ID {printf("%s", $2);}

CmdComp         :   ABCHAVE
                    {tabular();printf("{\n"); tab++;}
                    ListCmd   FCHAVE
                    {tab--;tabular();printf ("}\n");}

ListCmd         :   Comando |   ListCmd   Comando

Comando         :   CmdComp   |   CmdSe   |   CmdEnquanto   |   CmdRepetir   |   CmdPara   
                |   CmdLer   |   CmdEscrever   |   CmdAtrib   |   ChamaProc   |   CmdRetornar   
                |   PVIRG {printf(";\n");}

CmdSe           :   SE {tabular();printf ("se ");}
                    ABPAR {printf("\(");}
                    Expressao
                    {
                        if($5 != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do SE");
                    }
                    FPAR {printf (")\n");}
                    Comando   CmdSenao

CmdSenao        :   |   SENAO {tabular();printf ("senao\n");}
                    Comando

CmdEnquanto     :   ENQUANTO {tabular();printf ("enquanto");}
                    ABPAR {printf("\( ");} 
                    Expressao
                    {
                        if($5 != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do ENQUANTO");
                    }
                    FPAR {printf(" )\n");}  Comando

CmdRepetir      :   REPETIR {tabular();printf ("repetir\n");}  Comando
                    ENQUANTO  ABPAR {tabular();printf ("enquanto\(");}  Expressao   FPAR   PVIRG {printf (");\n");}

CmdPara         :   PARA   ABPAR {tabular();printf ("para\(");}  
                    Comando  Variavel   ATRIB {printf(":= ");}  Expressao
                    PVIRG {printf(",");}  Expressao   PVIRG {printf(",");}
                    Variavel   ATRIB {printf(":= ");}  Expressao   FPAR {printf(")\n");}  Comando

CmdLer          :   LER  ABPAR {tabular();printf ("ler\(");} ListVar   FPAR   PVIRG {printf (");\n");}

ListVar         :   Variavel {$1->inic = $1->ref = TRUE;}
                |   ListVar   VIRG {printf(",");}   Variavel

CmdEscrever     :   ESCREVER   ABPAR  {tabular();printf ("escrever\(");} ListEscr   FPAR   PVIRG {printf (");\n");}

ListEscr        :   ElemEscr   |   ListEscr   VIRG {printf(",");}  ElemEscr

ElemEscr        :   CADEIA  {printf("%s", $1);} |  Expressao

ChamaProc       :   CHAMAR  ID   ABPAR   FPAR   PVIRG {tabular();printf("chamar %s\();\n", $2);}
                |   CHAMAR   ID   ABPAR   {tabular();printf ("chamar %s\(", $2);}
                    ListExpr   FPAR   PVIRG {printf (");\n");}

CmdRetornar     :   RETORNAR   PVIRG {tabular();printf("retornar;\n");}
                |   RETORNAR {tabular();printf("retornar ");}  Expressao   PVIRG {printf (";\n");}

CmdAtrib        :   {tabular();} Variavel
                    {
                        if  ($2 != NULL) $2->inic = $2->ref = TRUE;
                    }
                    ATRIB {printf(" := ");}
                    Expressao   PVIRG
                    {
                        printf(";\n");
                        if ($2 != NULL)
                        if ((($2->tvar == INTEGER || $2->tvar ==CHAR)
                            && ($6 == FLOAT || $6 == LOGICAL)) ||
                            ($2->tvar == FLOAT && $6 == LOGICAL) ||
                            ($2->tvar == LOGICAL && $6 != LOGICAL))
                            Incompatibilidade("Lado direito de comando de atribuicao improprio");
                    }

ListExpr        :   Expressao   |   ListExpr   VIRG {printf(", ");}   Expressao

Expressao       :   ExprAux1
                |   Expressao   OR {printf(" || ");}  ExprAux1 
                
ExprAux1        :   ExprAux2
                |   ExprAux1   AND {printf(" && ");} ExprAux2 

ExprAux2        :   ExprAux3
                |   NOT {printf("!");} ExprAux3 
                
ExprAux3        :   ExprAux4
                |   ExprAux4   OPREL {
                        switch ($2){
                            case LT:
                                printf (" < ");
                                break;
                            case LE:
                                printf (" <= ");
                                break;
                            case GT:
                                printf (" > ");
                                break;
                            case GE:
                                printf (" >= ");
                                break;
                            case EQ:
                                printf (" = ");
                                break;
                            case NE:
                                printf (" != ");
                                break;
                        }
                    }
                    ExprAux4
                
ExprAux4        :   Termo
                |   ExprAux4   OPAD  {
                        if ($2 == MAIS) printf (" + ");
                        else printf (" - ");
                    }
                    Termo
                {
                    if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                        Incompatibilidade ("Operando improprio para operador aritmetico");
                    if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                    else $$ = INTEGER;
                }

Termo           :   Fator
                |   Termo  OPMULT {
                        switch ($2){
                            case MULT:
                                printf (" * ");
                                break;
                            case DIV:
                                printf (" / ");
                                break;
                            case RESTO:
                                printf (" % ");
                                break;
                        }
                    }
                    Fator
                {switch($2){
                    case MULT:case DIV:
                        if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                        else $$ = INTEGER;
                        break;
                    case RESTO:
                        if ($1 != INTEGER && $1 != CHAR|| $4 != INTEGER && $4 != CHAR)
                            Incompatibilidade("Operando improprio para operador resto");
                        $$ = INTEGER;
                        break;
                }}

Fator           :   Variavel
                {
                    if ($1 != NULL){
                        $1->ref = TRUE;
                        $$ = $1->tvar;
                    }
                }
                |   CTINT {printf("%d",$1);$$ = INTEGER;}
                |   CTREAL {printf("%d",$1);$$ = FLOAT;}
                |   CTCARAC {printf("%c",$1);$$ = CHAR;}
                |   VERDADE {printf("verdade");$$ = LOGICAL;}
                |   FALSO {printf("falso");$$ = LOGICAL;}
                |   NEG {printf("~");} Fator
                {
                    {
                        if ($3 != INTEGER && $3 != FLOAT && $3 != CHAR)
                            Incompatibilidade ("Operando improprio para menos unario");
                        if ($3 == FLOAT) $$ = FLOAT;
                        else $$ = INTEGER;
                    }
                }
                |   ABPAR {printf("\( ");}
                    Expressao
                    FPAR {printf(") "); $$ = $3;}
                |   ChamaFunc

Variavel        :   ID 
                {
                    printf("%s", $1);
                    simb = ProcuraSimb ($1);
                    if (simb == NULL)   NaoDeclarado ($1);
                    else if (simb->tid != IDVAR) TipoInadequado ($1);
                    $$ = simb;
                    if ($$ != NULL)
                        if ($$->array == TRUE)
                            Esperado ("Subscrito\(s)");
                }
                |   ID   ABCOL
                {
                    printf ("%s [", $1);
                    simb = ProcuraSimb ($1);
                    if (simb == NULL)   NaoDeclarado ($1);
                    else if (simb->tid != IDVAR) TipoInadequado ($1);
                    $<simb>$ = simb;
                }
                    ListSubscr   FCOL 
                    {
                        printf ("]");
                        $$ = $<simb>3;
                        if ($$ != NULL)
                            if ($$->array == FALSE)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$->ndims != $4)
                                Incompatibilidade("Numero de subscritos incompativel com declaracao");
                    }

ListSubscr      :   ExprAux4
                {
                    if($1 != INTEGER && $1 != CHAR)
                        Incompatibilidade("Tipo Inadequado para subscrito");
                    $$ = 1;
                }
                |   ListSubscr   VIRG {printf(",");}  ExprAux4
                {
                    if ($4 != INTEGER && $4 != CHAR)
                        Incompatibilidade ("Tipo inadequado para subscrito");
                    $$ = $1+1;
                }

ChamaFunc       :   ID   ABPAR    FPAR
                    {printf("%s", $1);printf("\(");printf(")");}
                |   ID   ABPAR {printf("%s", $1);printf("(");}  ListExpr
                    FPAR {printf(")");}
%%
#include "lex.yy.c"
tabular () {
    int i;
    for (i = 1; i <= tab; i++)
    printf ("\t");
}

void InicTabSimb () {
    int i;
    for (i = 0; i < NCLASSHASH; i++) 
        tabsimb[i] = NULL;
}

simbolo ProcuraSimb (char *cadeia) {
    simbolo s; int i;
    i = hash (cadeia);
    for (s = tabsimb[i]; (s!=NULL) && strcmp(cadeia, s->cadeia); 
        s = s->prox);
    return s;
}

simbolo InsereSimb (char *cadeia, int tid, int tvar) {
    int i; simbolo aux, s;
    i = hash (cadeia); aux = tabsimb[i];
    s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
    s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
    strcpy (s->cadeia, cadeia);
    s->tid = tid;       s->tvar = tvar;
    s->inic = FALSE;    s->ref = FALSE;
    s->prox = aux;  return s;
}

int hash (char *cadeia) {
    int i, h;
    for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
    h = h % NCLASSHASH;
    return h;
}

void ImprimeTabSimb () {
    int i; simbolo s;
    printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i]) {
            printf ("Classe %d:\n", i);
            for (s = tabsimb[i]; s!=NULL; s = s->prox){
                printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
                if (s->tid == IDVAR){
                    printf (", %s, %d, %d", nometipvar[s->tvar], s->inic, s->ref);
                    if (s->array == TRUE) {
                        int j;
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
                        for (j = 1; j <= s->ndims; j++)
                        printf (" %d", s->dims[j]);
                    }
                }
                printf(")\n");
            }
        }
}

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

void Esperado (char *s) {
    printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
    printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}
