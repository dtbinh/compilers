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

int tab = 0;
char str[20];
%}
%union {
    char cadeia[50];
    int atr, valint;
    char carac;
    float valreal;
}

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
Prog            :   PROGRAMA   ID   PVIRG {printf("programa %s;\n", $2);}
                    Decls    SubProgs   CmdComp 

Decls           :   |   VAR {printf("var ");}   ListDecl
                
ListDecl        :   Declaracao    |   ListDecl   Declaracao

Declaracao      :   Tipo   ListElemDecl   PVIRG {printf(";\n");}

Tipo            :   INT {printf("int ");}
                |   REAL {printf("real ");}
                |   CARAC {printf("carac ");}
                |   LOGIC {printf("logic ");}

ListElemDecl    :   ElemDecl      |     ListElemDecl   VIRG {printf(",");}   ElemDecl

ElemDecl        :   ID {printf("%s", $1);}  |    ID   ABCOL {printf("%s [", $1);}  ListDim
                    FCOL {printf("]");}

ListDim         :   CTINT {printf("%d",$1);}   |    ListDim   VIRG   CTINT {printf(",%d",$3);}

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
                    FPAR {printf (")\n");}
                    Comando   CmdSenao

CmdSenao        :   |   SENAO {tabular();printf ("senao\n");}
                    Comando

CmdEnquanto     :   ENQUANTO {tabular();printf ("enquanto");}
                    ABPAR {printf("\( ");} 
                    Expressao
                    FPAR {printf(" )\n");}  Comando

CmdRepetir      :   REPETIR {tabular();printf ("repetir\n");}  Comando
                    ENQUANTO  ABPAR {tabular();printf ("enquanto\(");}  Expressao   FPAR   PVIRG {printf (");\n");}

CmdPara         :   PARA   ABPAR {tabular();printf ("para\(");}  
                    Comando  Variavel   ATRIB {printf(":= ");}  Expressao
                    PVIRG {printf(",");}  Expressao   PVIRG {printf(",");}
                    Variavel   ATRIB {printf(":= ");}  Expressao   FPAR {printf(")\n");}  Comando

CmdLer          :   LER  ABPAR {tabular();printf ("ler\(");} ListVar   FPAR   PVIRG {printf (");\n");}

ListVar         :   Variavel   |   ListVar   VIRG {printf(",");}   Variavel

CmdEscrever     :   ESCREVER   ABPAR  {tabular();printf ("escrever\(");} ListEscr   FPAR   PVIRG {printf (");\n");}

ListEscr        :   ElemEscr   |   ListEscr   VIRG {printf(",");}  ElemEscr

ElemEscr        :   CADEIA  {printf("%s", $1);} |  Expressao

ChamaProc       :   CHAMAR  ID   ABPAR   FPAR   PVIRG {tabular();printf("chamar %s\();\n", $2);}
                |   CHAMAR   ID   ABPAR   {tabular();printf ("chamar %s\(", $2);}
                    ListExpr   FPAR   PVIRG {printf (");\n");}

CmdRetornar     :   RETORNAR   PVIRG {tabular();printf("retornar;\n");}
                |   RETORNAR {tabular();printf("retornar ");}  Expressao   PVIRG {printf (";\n");}

CmdAtrib        :   {tabular();} Variavel
                    ATRIB {printf(" := ");}
                    Expressao   PVIRG {printf(";\n");}

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

Fator           :   Variavel
                |   CTINT {printf("%d",$1);}
                |   CTREAL {printf("%d",$1);}
                |   CTCARAC {printf("%c",$1);}
                |   VERDADE {printf("verdade");}
                |   FALSO {printf("falso");}
                |   NEG {printf("~");} Fator
                |   ABPAR {printf("\( ");}
                    Expressao
                    FPAR {printf(") ");}
                |   ChamaFunc

Variavel        :   ID {printf("%s", $1);}
                |   ID   ABCOL {printf("%s", $1);printf("[");}
                    ListSubscr   FCOL {printf("]");}

ListSubscr      :   ExprAux4
                |   ListSubscr   VIRG {printf(",");}  ExprAux4

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
