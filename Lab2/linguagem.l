%{
#include    <string.h>
#define     ID      1
#define     CTINT    2
#define     CTCARAC 3
#define     CTREAL  4
#define     OR      5
#define     AND     6
#define     NOT     7
#define     OPREL   8
#define     OPAD    9
#define     OPMULT  10
#define     NEG     11
#define     ABPAR   12
#define     FPAR    13
#define     ABCOL   14
#define     FCOL    15
#define     ABCHAVE 16
#define     FCHAVE  17
#define     PVIRG   18
#define     VIRG    19
#define     ATRIB   20
#define     CADEIA  21
#define     INVAL   22
#define     CARAC   23
#define     INT     24
#define     REAL    25
#define     VERDADE 26
#define     CHAMAR  27
#define     LER     28
#define     REPETIR 29
#define     ENQUANTO 30
#define     LOGIC    31
#define     RETORNAR 32
#define     ESCREVER 33
#define     PARA     34
#define     SE       35
#define     FALSO    36
#define     PROCEDIMENTO 37
#define     SENAO    38
#define     FUNCAO   39
#define     PROGRAMA 40
#define     VAR      41

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

union {
    char string[50];
    int atr, valor;
    float valreal;
    char carac;
} yylval;
void comentario (void);
%} 
delim           [ \t\n\r]
ws              {delim}+
digito          [0-9]
letra           [A-Za-z]
ctint           {digito}+
id              {letra}({letra}|{digito})*
ctreal          {digito}+\.{digito}*([Ee][+-]?{digito}+)?
carac1          \\.|[^\\']
carac2          \\.|[^\\\"]
ctcarac         '{carac1}'
cadeia          \"{carac2}*\"
Prog            {programa} {id} {PVIRG} {Decls} {SubProgs} {CmdComp}
Decls           ({var} {ListDecl})?
ListDecl        {Declaracao} | {ListDecl} {Declaracao}
Declaracao      {Tipo} {ListElemDecl} {PVIRG}
Tipo            {int} | {real} | {carac} | {logic}
ListElemDecl    {ElemDecl} | {ListElemDecl} {VIRG} {ElemDecl}
ElemDecl        {id} | {id} {ABCOL} {ListDim} {FCOL}
ListDim         {CINT} | {ListDim} {VIRG} {CINT}
SubProgs        ({SubProgrs}  {DeclSubProg})?
DeclSubProg     {Cabecalho}   {Decls}   {CmdComp}
Cabecalho       {CabFunc} | {CabProc}
CabFunc         {funcao}   {Tipo}   {id}   {ABPAR}   {FPAR}   {PVIRG} | {funcao} {Tipo} {id} {ABPAR} {ListParam} {FPAR} {PVIRG}
CabProc         {procedimento} {id} {ABPAR} {FPAR} {PVIRG} | {procedimento} {id} {ABPAR} {ListParam} {FPAR} {PVIRG}
ListParam       {Parametro}  |  {ListParam}   {VIRG}   {Parametro}
Parametro       {Tipo}   {id}
CmdComp         {ABCHAV}   {ListCmd}   {FCHAV}
ListCmd         ({ListCmd}   {Comando})?
Comando         {CmdComp} |  {CmdSe} | {CmdEnquanto} | {CmdRepetir} | {CmdPara} | {CmdLer} | {CmdEscrever} | {CmdAtrib} | {ChamaProc} | {CmdRetornar} | {PVIRG}
CmdSe           {se} {ABPAR}  {Expressao} {FPAR} {Comando} {CmdSenao}
CmdSenao        (senao {Comando})?
CmdEnquanto     {enquanto} {ABPAR} {Expressao} {FPAR} {Comando}
CmdRepetir      {repetir} {Comando} {enquanto} {ABPAR} {Expressao} FPAR PVIRG
CmdPara         {para} {ABPAR} {Variavel} {ATRIB} {Expressao} {PVIRG} {Expressao} {PVIRG} {Variavel} {ATRIB} {Expressao} {FPAR} {Comando}
CmdLer          {ler} {ABPAR} {ListVar} {FPAR} {PVIRG}
ListVar         {Variavel} |  {ListVar} {VIRG} {Variavel}
CmdEscrever     {escrever} {ABPAR} {ListEscr}   {FPAR} {PVIRG}
ListEscr        {ElemEscr} | {ListEscr} {VIRG} {ElemEscr}
ElemEscr        {cadeia} | {Expressao}
ChamaProc       {chamar} {id} {ABPAR} {FPAR} {PVIRG} | {chamar} {id} {ABPAR} {ListExpr}   {FPAR}   {PVIRG}
CmdRetornar     {retornar}   {PVIRG} | {retornar}   {Expressao}   {PVIRG}
CmdAtrib        {Variavel}   {ATRIB}   {Expressao}   {PVIRG}
ListExpr        {Expressao} | {ListExpr}   {VIRG}   {Expressao}
Expressao       {ExprAux1} | {Expressao}   {OR}   {ExprAux1}
ExprAux1        {ExprAux2} | {ExprAux1}   {AND}   {ExprAux2}
ExprAux2        {ExprAux3} | {NOT}   {ExprAux3}
ExprAux3        {ExprAux4} | {ExprAux4}   {OPREL}   {ExprAux4}
ExprAux4        {Termo} | {ExprAux4}   {OPAD}   {Termo}
Termo           {Fator} | {Termo}   {OPMULT}   {Fator}
Fator           {Variavel} | {CTINT} | {ctreal} | {ctcarac} | {verdade} | {falso} | {NEG}  {Fator} | {ABPAR}  {Expressao}   {FPAR} | {ChamaFunc}
Variavel        {id} | {id}   {ABCOL}   {ListSubscr}   {FCOL}
ListSubscr      {ExprAux4} | {ListSubscr}   {VIRG}   {ExprAux4}
ChamaFunc       {id}   {ABPAR}    {FPAR} |  {id}   {ABPAR}   {ListExpr}  {FPAR}
%%
{ws}            { ;}
carac           {return CARAC;}
int             {return INT;}
real            {return REAL;}
verdade         {return VERDADE;}
chamar          {return CHAMAR;}
ler             {return LER;}
repetir         {return REPETIR;}
enquanto        {return ENQUANTO;}
logic           {return LOGIC;}
retornar        {return RETORNAR;}
escrever        {return ESCREVER;}
para            {return PARA;}
se              {return SE;}
falso           {return FALSO;}
procedimento    {return PROCEDIMENTO;}
senao           {return SENAO;}
funcao          {return FUNCAO;}
programa        {return PROGRAMA;}
var             {return VAR;}
{id}            {strcpy (yylval.string, yytext); return ID;}
{ctint}         {yylval.valor = atoi(yytext); return CTINT;}
{ctcarac}       {strcpy (yylval.string, yytext); return CTCARAC;}
{cadeia}        {strcpy (yylval.string, yytext); return CADEIA;}
{ctreal}        {yylval.valreal = atof(yytext); return CTREAL;}
"<"             {yylval.atr = LT; return OPREL;}
"<="            {yylval.atr = LE; return OPREL;}
">"             {yylval.atr = GT; return OPREL;}
">="            {yylval.atr = GE; return OPREL;}
"="            {yylval.atr = EQ; return OPREL;}
"!="            {yylval.atr = NE; return OPREL;}
"!"             {return NOT;}
"||"            {return OR;}
"&&"            {return AND;}
"+"             {yylval.atr = MAIS; return OPAD;}
"-"             {yylval.atr = MENOS; return OPAD;}
"*"             {yylval.atr = MULT; return OPMULT;}
"/"             {yylval.atr = DIV; return OPMULT;}
"%"             {yylval.atr = RESTO; return OPMULT;}
"~"             {return NEG;}
"/*"            {comentario();}
"["             {return ABCOL;}
"]"             {return FCOL;}
"{"             {return ABCHAVE;}
"}"             {return FCHAVE;}
"("             {return ABPAR;}
")"             {return FPAR;}
";"             {return PVIRG;}
":="            {return ATRIB;}
","             {return VIRG;}
.               {yylval.carac = yytext[0]; return INVAL;}
%%
void comentario () {
    char c = input();
    int estado = 1;
    while(c != EOF && estado != 3){
        if(c=='*'){
            estado = 2;
        }
        if(c=='/' && estado==2){
            estado = 3;
        }
        c = input();
    }
}
main () {
    int i;
    printf ("\n      texto      |   tipo   |     atributo    \n");
    printf ("----------------------------------------------\n");
    while (i = yylex ()) {
        printf ("%17s|%10d|", yytext, i);
        switch (i) {
            case ID: case CTCARAC: case CADEIA:
                printf ("%17s", yylval.string); break;
            case CTINT:
                printf ("%17d", yylval.valor); break;
            case CTREAL:
                printf ("%17g", yylval.valreal); break;
            case OPREL:
                printf ("%17d", yylval.atr); break;
            case INVAL:
            printf ("%17c", yylval.carac); break;
      }
        printf ("\n");
    }
}
