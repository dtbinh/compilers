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
#define     IDFUNC  3
#define     IDPROC  4

#define     NOTVAR  0
#define     INTEGER 1
#define     LOGICAL 2
#define     FLOAT   3
#define     CHAR    4

#define     OPOR        1
#define     OPAND       2
#define     OPLT        3
#define     OPLE        4
#define     OPGT        5
#define     OPGE        6
#define     OPEQ        7
#define     OPNE        8
#define     OPMAIS      9
#define     OPMENOS     10
#define     OPMULTIP    11
#define     OPDIV       12
#define     OPRESTO     13
#define     OPMENUN     14
#define     OPNOT       15
#define     OPATRIB     16
#define     OPENMOD     17
#define     NOP         18
#define     OPJUMP      19
#define     OPJF        20
#define     PARAM       21
#define     OPREAD      22
#define     OPWRITE     23
#define     OPJT        24

#define     IDLEOPND    0
#define     VAROPND     1
#define     INTOPND     2
#define     REALOPND    3
#define     CHAROPND    4
#define     LOGICOPND   5
#define     CADOPND     6
#define     ROTOPND     7
#define     MODOPND     8

#define     NCLASSHASH  23
#define     TRUE        1
#define     FALSE       0
#define     MAXDIMS     10

int tab = 0;
char str[20];

char *nometipid[5] = {" ", "IDPROG", "IDVAR", "IDFUNC", "IDPROC"};

char *nometipvar[5] = {"NOTVAR","INTEGER", "LOGICAL", "FLOAT", "CHAR"
};

char *nomeoperquad[25] = {"","OR", "AND", "LT", "LE", "GT", "GE",
 "EQ", "NE", "MAIS",  "MENOS", "MULT", "DIV", "RESTO", "MENUN", 
 "NOT", "ATRIB", "OPENMOD", "NOP", "JUMP", "JF", "PARAM", "READ", 
 "WRITE", "JT"
};

char *nometipoopndquad[9] = {"IDLE","VAR", "INT", "REAL", "CARAC",
 "LOGIC", "CADEIA", "ROTULO", "MODULO"
};

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
    char *cadeia;
    int tid, tvar, ndims, dims[MAXDIMS+1];
    char inic, ref, array; simbolo prox;
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

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

union atribopnd {
    simbolo simb; int valint; float valfloat; 
    char valchar; char vallogic; char *valcad; 
    quadrupla rotulo; modhead modulo;
};

struct operando { 
    int tipo; atribopnd atr;
};

struct celquad {
    int num, oper; operando opnd1, opnd2, result; quadrupla prox;
};

struct celmodhead {
    simbolo modname; modhead prox;
    int modtip; quadrupla listquad;
};

quadrupla quadcorrente, quadaux, quadaux2;
modhead codintermed, modcorrente;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
quadrupla GeraQuadrupla (int, operando, operando, operando);
simbolo NovaTemp (int);
void RenumQuadruplas (quadrupla, quadrupla);

typedef struct infoexpressao infoexpressao;
struct infoexpressao {
    int tipo;
    operando opnd;
};

typedef struct infovariavel infovariavel;
struct infovariavel {
    simbolo simb;
    operando opnd;
};

%}

%union {
    char cadeia[50];
    int atr, valint;
    float valreal;
    char carac;
    simbolo simb;
    infoexpressao infoexpr;
    infovariavel infovar;
    int nsubscr, nargs;
    quadrupla quad;
}


%type       <nargs>     ListVar ListEscr
%type       <infoexpr>  ExprAux1 ExprAux2 ExprAux3 ExprAux4   Termo   Fator ElemEscr Expressao
%type       <infovar>      Variavel
%type       <nsubscr>   ListSubscr
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
Prog            :   {InicTabSimb(); InicCodIntermed (); numtemp = 0;}
                    PROGRAMA   ID   PVIRG
                    {
                        printf("programa %s;\n", $3);
                        simb = InsereSimb ($3, IDPROG, NOTVAR);
                        InicCodIntermMod (simb);
                        opnd1.tipo = MODOPND;
                        opnd1.atr.modulo = modcorrente;
                        GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
                    }
                    Decls    SubProgs   CmdComp
                    {
                        VerificaInicRef();
                        ImprimeTabSimb();
                        ImprimeQuadruplas ();
                    }

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
                        if (ProcuraSimb($1)!=NULL){
                            DeclaracaoRepetida ($1);       
                        }else{
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
                        if($5.tipo != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do SE");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ =GeraQuadrupla (OPJF, $5.opnd, opndidle, opndaux);
                    }
                    FPAR {printf (")\n");}
                    Comando
                    {
                        $<quad>$ = quadcorrente;
                        $<quad>6->result.atr.rotulo=GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                    CmdSenao
                    {
                        if ($<quad>10->prox != quadcorrente) {
                            quadaux = $<quad>10->prox;
                            $<quad>10->prox = quadaux->prox;
                            quadaux->prox = $<quad>10->prox->prox;
                            $<quad>10->prox->prox = quadaux;
                            RenumQuadruplas ($<quad>10, quadcorrente);
                        }
                    }

CmdSenao        :   |   SENAO
                    {
                        tabular();printf ("senao\n");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJUMP, opndidle, opndidle,opndaux);
                    }
                    Comando
                    {
                        $<quad>2->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }

CmdEnquanto     :   ENQUANTO
                    {
                        tabular();printf ("enquanto");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                    ABPAR {printf("\( ");} 
                    Expressao
                    {
                        if($5.tipo != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do ENQUANTO");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJF, $5.opnd, opndidle, opndaux);
                    }
                    FPAR {printf(" )\n");}  Comando
                    {
                        opndaux.tipo = ROTOPND;
                        opndaux.atr.rotulo = $<quad>2;
                        GeraQuadrupla(OPJUMP, opndidle, opndidle, opndaux);
                        $<quad>6->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
                        }

CmdRepetir      :   REPETIR
                    {
                        tabular();printf ("repetir\n");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }  Comando
                    ENQUANTO  ABPAR {tabular();printf ("enquanto\(");}  Expressao
                    {
                        if($7.tipo != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do REPETIR");
                        opndaux.tipo = ROTOPND;
                        opndaux.atr.rotulo = $<quad>2;
                        GeraQuadrupla (OPJT, $7.opnd, opndidle, opndaux);
                    }
                    FPAR   PVIRG {printf (");\n");}

CmdPara         :   PARA   ABPAR {tabular();printf ("para\(");}  
                    Variavel   ATRIB {printf(":= ");}  Expressao
                    PVIRG {
                        printf(";");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }  Expressao
                    {
                        if($10.tipo != LOGICAL)
                            Incompatibilidade("Expressao nao logica na condicao do PARA");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJF, $10.opnd, opndidle, opndaux);
                    }
                    PVIRG {
                        printf(";");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                    Variavel   ATRIB {printf(":= ");}  Expressao   FPAR {printf(")\n");}
                    { $<quad>$ = quadcorrente; }
                    { $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle); }
                    Comando
                    {
                    quadaux = quadcorrente;
                    opndaux.tipo = ROTOPND; opndaux.atr.rotulo = $<quad>9;
                    quadaux2 = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                    $<quad>11->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
                    }

CmdLer          :   LER  ABPAR {tabular();printf ("ler\(");}   ListVar
                    {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $4;
                        GeraQuadrupla (OPREAD, opnd1, opndidle, opndidle);
                    }
                    FPAR   PVIRG {printf (");\n");}

ListVar         :   Variavel
                    {
                        if  ($1.simb != NULL) $1.simb->inic = $1.simb->ref = TRUE;
                        $$ = 1;
                        GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
                |   ListVar   VIRG {printf(",");}   Variavel
                    {
                        if  ($4.simb != NULL) $4.simb->inic = $4.simb->ref = TRUE;
                        $$ = $1 + 1;
                        GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }

CmdEscrever     :   ESCREVER   ABPAR  {tabular();printf ("escrever\(");} 
                    ListEscr
                    {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $4;
                        GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
                    }
                    FPAR   PVIRG {printf (");\n");}

ListEscr        :   ElemEscr 
                {
                    $$ = 1;
                    GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                }
                |   ListEscr   VIRG {printf(",");}  ElemEscr
                {
                    $$ = $1 + 1;
                    GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                }

ElemEscr        :   CADEIA 
                    {
                        printf("%s", $1);
                        $$.opnd.tipo = CADOPND;
                        $$.opnd.atr.valcad = malloc (strlen($1) + 1);
                        strcpy ($$.opnd.atr.valcad, $1);
                    }
                    |  Expressao

ChamaProc       :   CHAMAR  ID   ABPAR   FPAR   PVIRG {tabular();printf("chamar %s\();\n", $2);}
                |   CHAMAR   ID   ABPAR   {tabular();printf ("chamar %s\(", $2);}
                    ListExpr   FPAR   PVIRG {printf (");\n");}

CmdRetornar     :   RETORNAR   PVIRG {tabular();printf("retornar;\n");}
                |   RETORNAR {tabular();printf("retornar ");}  Expressao   PVIRG {printf (";\n");}

CmdAtrib        :   {tabular();} Variavel
                    {
                        if  ($2.simb != NULL) $2.simb->inic = $2.simb->ref = TRUE;
                    }
                    ATRIB {printf(" := ");}
                    Expressao   PVIRG
                    {
                        printf(";\n");
                        if ($2.simb != NULL)
                        if ((($2.simb->tvar == INTEGER || $2.simb->tvar ==CHAR)
                            && ($6.tipo == FLOAT || $6.tipo == LOGICAL)) ||
                            ($2.simb->tvar == FLOAT && $6.tipo == LOGICAL) ||
                            ($2.simb->tvar == LOGICAL && $6.tipo != LOGICAL))
                            Incompatibilidade("Lado direito de comando de atribuicao improprio");
                        GeraQuadrupla (OPATRIB, $6.opnd, opndidle, $2.opnd);
                    }

ListExpr        :   Expressao   |   ListExpr   VIRG {printf(", ");}   Expressao

Expressao       :   ExprAux1
                |   Expressao   OR {printf(" || ");}  ExprAux1
                {
                    if ($1.tipo != LOGICAL || $4.tipo != LOGICAL)
                        Incompatibilidade ("Operando improprio para OR");
                    $$.tipo = LOGICAL;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
                }
                
ExprAux1        :   ExprAux2
                |   ExprAux1   AND {printf(" && ");} ExprAux2
                {
                    if ($1.tipo != LOGICAL || $4.tipo != LOGICAL)
                        Incompatibilidade ("Operando improprio para AND");
                    $$.tipo = LOGICAL;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
                }

ExprAux2        :   ExprAux3
                |   NOT {printf("!");} ExprAux3
                {
                    if ($3.tipo != LOGICAL)
                        Incompatibilidade ("Operando improprio para NOT");
                    $$.tipo = LOGICAL;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($3.tipo);
                    GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);
                }
                
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
                    {
                        switch ($2) {
                            case LT: case LE: case GT: case GE:
                                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1.tipo == LOGICAL || $4.tipo == LOGICAL) && $1.tipo != $4.tipo)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                            break;
                        }
                        $$.tipo = LOGICAL;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        switch ($2) {
                            case LT:
                                GeraQuadrupla (OPLT, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case LE:
                                GeraQuadrupla (OPLE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case GT:
                                GeraQuadrupla (OPGT, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case GE:
                                GeraQuadrupla (OPGE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case EQ:
                                GeraQuadrupla (OPEQ, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case NE:
                                GeraQuadrupla (OPNE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            }
                    }
                
ExprAux4        :   Termo
                |   ExprAux4   OPAD  {
                        if ($2 == MAIS) printf (" + ");
                        else printf (" - ");
                    }
                    Termo
                {
                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                    Incompatibilidade ("Operando improprio para operador aritmetico");
                if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                else $$.tipo = INTEGER;
                $$.opnd.tipo = VAROPND;
                $$.opnd.atr.simb = NovaTemp ($$.tipo);
                if ($2 == MAIS)
                    GeraQuadrupla (OPMAIS, $1.opnd, $4.opnd, $$.opnd);
                else  GeraQuadrupla (OPMENOS, $1.opnd, $4.opnd, $$.opnd);
                }

Termo           :   Fator
                |   Termo  OPMULT {
                        switch ($2){
                            case MULT: printf (" * "); break;
                            case DIV: printf (" / "); break;
                            case RESTO: printf (" % "); break;
                        }
                    }
                    Fator
                {switch ($2) {
                    case MULT: case DIV:
                        if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;  
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        if ($2 == MULT)
                            GeraQuadrupla   (OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
                            else  GeraQuadrupla  (OPDIV, $1.opnd, $4.opnd, $$.opnd);
                        break;
                    case RESTO:
                        if ($1.tipo != INTEGER && $1.tipo != CHAR ||  $4.tipo != INTEGER && $4.tipo != CHAR)
                            Incompatibilidade ("Operando improprio para operador resto");
                        $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;  
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla (OPRESTO, $1.opnd, $4.opnd, $$.opnd);
                        break;
                }}

Fator           :   Variavel
                {
                    if ($1.simb != NULL){
                        $1.simb->ref = TRUE;
                        $$.tipo = $1.simb->tvar;
                        $$.opnd = $1.opnd;
                    }
                }
                |  CTINT  {
                    printf ("%d ", $1); $$.tipo = INTEGER;
                    $$.opnd.tipo = INTOPND;
                    $$.opnd.atr.valint = $1;
                }
                |  CTREAL   {
                        printf ("%g ", $1); $$.tipo = FLOAT;
                        $$.opnd.tipo = REALOPND;
                        $$.opnd.atr.valfloat = $1;
                    }
                |  CTCARAC   {
                        printf ("\'%c\' ", $1); $$.tipo = CHAR;
                        $$.opnd.tipo = CHAROPND;
                        $$.opnd.atr.valchar = $1;
                    }
                |  VERDADE   {
                        printf ("verdade ");  $$.tipo = LOGICAL;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 1;
                    }
                |  FALSO   {
                        printf ("falso ");  $$.tipo = LOGICAL;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 0;
                    }
                |  NEG   {printf ("~ ");}   Fator  {
                        if ($3.tipo != INTEGER && $3.tipo != FLOAT && $3.tipo != CHAR)
                            Incompatibilidade  ("Operando improprio para menos unario");
                        if ($3.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
                    }
                |  ABPAR   {printf ("( ");}   Expressao   FPAR   {
                        printf (") ");
                        $$.tipo = $3.tipo; $$.opnd = $3.opnd;
                    }
                |   ChamaFunc

Variavel        :   ID 
                {
                    printf("%s", $1);
                    simb = ProcuraSimb ($1);
                    if (simb == NULL)   NaoDeclarado ($1);
                    else if (simb->tid != IDVAR) TipoInadequado ($1);
                    $$.simb = simb;
                    if ($$.simb != NULL){
                        if ($$.simb->array == TRUE)
                            Esperado ("Subscrito\(s)");
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = $$.simb;
                    }
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
                        printf ("] ");
                        $$.simb = $<simb>3;
                        if ($$.simb != NULL)
                            if ($$.simb->array == FALSE)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$.simb->ndims != $4)
                                Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                    }

ListSubscr      :   ExprAux4
                {
                    if($1.tipo != INTEGER && $1.tipo != CHAR)
                        Incompatibilidade("Tipo Inadequado para subscrito");
                    $$ = 1;
                }
                |   ListSubscr   VIRG {printf(",");}  ExprAux4
                {
                    if ($4.tipo != INTEGER && $4.tipo != CHAR)
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

void InicCodIntermed () {
   modcorrente = codintermed = malloc (sizeof (celmodhead));
   modcorrente->listquad = NULL;
   modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
   modcorrente->prox = malloc (sizeof (celmodhead));
   modcorrente = modcorrente->prox;
   modcorrente->prox = NULL;
   modcorrente->modname = simb;
   modcorrente->modtip = simb->tid;
   modcorrente->listquad = malloc (sizeof (celquad));
   quadcorrente = modcorrente->listquad;
   quadcorrente->prox = NULL;
   numquadcorrente = 0;
   quadcorrente->num = numquadcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2,
   operando result) {
   quadcorrente->prox = malloc (sizeof (celquad));
   quadcorrente = quadcorrente->prox;
   quadcorrente->oper = oper;
   quadcorrente->opnd1 = opnd1;
   quadcorrente->opnd2 = opnd2;
   quadcorrente->result = result;
   quadcorrente->prox = NULL;
   numquadcorrente ++;
   quadcorrente->num = numquadcorrente;
   return quadcorrente;
}

simbolo NovaTemp (int tip) {
   simbolo simb; int temp, i, j;
   char nometemp[10] = "##", s[10] = {0};

   numtemp ++; temp = numtemp;
   for (i = 0; temp > 0; temp /= 10, i++)
      s[i] = temp % 10 + '0';
   i --;
   for (j = 0; j <= i; j++)
      nometemp[2+i-j] = s[j];
   simb = InsereSimb (nometemp, IDVAR, tip);
   simb->inic = simb->ref = TRUE;
   simb->array = FALSE;
   return simb;
}

void ImprimeQuadruplas () {
   modhead p;
   quadrupla q;
   for (p = codintermed->prox; p != NULL; p = p->prox) {
      printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
      for (q = p->listquad->prox; q != NULL; q = q->prox) {
         printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
         printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
         switch (q->opnd1.tipo) {
            case IDLEOPND: break;
            case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
            case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
            case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
            case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
            case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
            case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
            case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
            case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
               break;
         }
         printf (")");
         printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
         switch (q->opnd2.tipo) {
            case IDLEOPND: break;
            case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
            case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
            case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
            case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
            case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
            case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
            case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
            case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
               break;
         }
         printf (")");
         printf (", (%s", nometipoopndquad[q->result.tipo]);
         switch (q->result.tipo) {
            case IDLEOPND: break;
            case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
            case INTOPND: printf (", %d", q->result.atr.valint); break;
            case REALOPND: printf (", %g", q->result.atr.valfloat); break;
            case CHAROPND: printf (", %c", q->result.atr.valchar); break;
            case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
            case CADOPND: printf (", %s", q->result.atr.valcad); break;
            case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
            case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
               break;
         }
         printf (")");
      }
   }
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
   quadrupla q; int nquad;
   for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox) {
      nquad++;
      q->num = nquad;
   }
}