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
%}
%union {
    char cadeia[50];
    int atr, valint;
    char carac;
    float valreal;
}

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
%token                  CADEIA
%token                  CTCARAC
%token                  FCOL
%token                  NEG
%token                  CTREAL
%token                  NOT
%token                  OPMULT
%token                  OPREL
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
Prog            :   PROGRAMA   ID   PVIRG   Decls    SubProgs   CmdComp 

Decls           :   |   VAR   ListDecl
                
ListDecl        :   Declaracao    |   ListDecl   Declaracao

Declaracao      :   Tipo   ListElemDecl   PVIRG

Tipo            :   INT     |     REAL     |    CARAC     |     LOGIC

ListElemDecl    :   ElemDecl      |     ListElemDecl   VIRG   ElemDecl

ElemDecl        :   ID   |    ID   ABCOL   ListDim   FCOL   

ListDim         :   CTINT    |    ListDim   VIRG   CTINT

SubProgs        :   |   SubProgs   DeclSubProg

DeclSubProg     :   Cabecalho   Decls   CmdComp

Cabecalho       :   CabFunc   |   CabProc

CabFunc         :   FUNCAO   Tipo   ID   ABPAR   FPAR   PVIRG   
                |   FUNCAO   Tipo   ID   ABPAR   ListParam   FPAR   PVIRG

CabProc         :   PROCEDIMENTO   ID   ABPAR   FPAR   PVIRG
                |   PROCEDIMENTO   ID   ABPAR   ListParam   FPAR   PVIRG

ListParam       :   Parametro    |   ListParam   VIRG   Parametro

Parametro       :   Tipo   ID

CmdComp         :   ABCHAVE   ListCmd   FCHAVE

ListCmd         :   |   ListCmd   Comando

Comando         :   CmdComp   |   CmdSe   |   CmdEnquanto   |   CmdRepetir   |   CmdPara   
                |   CmdLer   |   CmdEscrever   |   CmdAtrib   |   ChamaProc   |   CmdRetornar   
                |   PVIRG

CmdSe           :   SE   ABPAR   Expressao   FPAR   Comando   CmdSenao

CmdSenao        :   |   SENAO   Comando

CmdEnquanto     :   ENQUANTO   ABPAR   Expressao   FPAR   Comando

CmdRepetir      :   REPETIR   Comando   ENQUANTO   ABPAR   Expressao   FPAR   PVIRG

CmdPara         :   PARA   ABPAR   Variavel   ATRIB   Expressao   PVIRG   Expressao   PVIRG   
                    Variavel   ATRIB   Expressao   FPAR   Comando

CmdLer          :   LER   ABPAR   ListVar   FPAR   PVIRG

ListVar         :   Variavel   |   ListVar   VIRG   Variavel

CmdEscrever     :   ESCREVER   ABPAR   ListEscr   FPAR   PVIRG

ListEscr        :   ElemEscr   |   ListEscr   VIRG   ElemEscr

ElemEscr        :   CADEIA   |   Expressao

ChamaProc       :   CHAMAR   ID   ABPAR   FPAR   PVIRG
                |   CHAMAR   ID   ABPAR   ListExpr   FPAR   PVIRG

CmdRetornar     :   RETORNAR   PVIRG   |   RETORNAR   Expressao   PVIRG

CmdAtrib        :   Variavel   ATRIB   Expressao   PVIRG

ListExpr        :   Expressao   |   ListExpr   VIRG   Expressao

Expressao       :   ExprAux1     |     Expressao   OR   ExprAux1
                
ExprAux1        :   ExprAux2     |     ExprAux1   AND   ExprAux2
                
ExprAux2        :   ExprAux3     |     NOT   ExprAux3  
                
ExprAux3        :   ExprAux4     |     ExprAux4   OPREL   ExprAux4
                
ExprAux4        :   Termo     |     ExprAux4   OPAD   Termo

Termo           :   Fator   |   Termo   OPMULT   Fator

Fator           :   Variavel   |   CTINT   |   CTREAL   |   CTCARAC   |   VERDADE   |   FALSO   
                |   NEG   Fator   |   ABPAR   Expressao   FPAR   |   ChamaFunc

Variavel        :   ID   |   ID   ABCOL   ListSubscr   FCOL   

ListSubscr      :   ExprAux4   |   ListSubscr   VIRG   ExprAux4

ChamaFunc       :   ID   ABPAR    FPAR  
                |   ID   ABPAR   ListExpr   FPAR

%%
#include "lex.yy.c"
tabular () {
    int i;
    for (i = 1; i <= tab; i++)
    printf ("\t");
}
