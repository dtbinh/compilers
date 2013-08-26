%{
#include    <string.h>
#define     CTFLOAT     3
#define     OPMULT      1
#define     VEZES       1
#define     DIV         2
#define     REST        3
#define     OPAD        2
#define     MAIS        1
#define     MENOS       2
#define     ID          4
#define     CTINT       5
#define     OPREL       6
#define     MENOR       1
#define     MENIG       2
#define     MAIOR       3
#define     MAIG        4
#define     IGUAL       5
#define     DIFER       6
union {
    char string[50];
    int atr, valor;
    float valreal;
    char carac;
} yylval;
%}
delim       [ \t\n\r]
ws          {delim}+
digito      [0-9]
letra       [A-Za-z]
ctint       {digito}+
ctfloat     {digito}+\.{digito}*
id          {letra}({letra}|{digito})*
expr        {exprSimpl}|{exprSimpl}{oprel}{exprSimpl}
exprSimpl   {term}|{term}{opad}{exprSimpl}
term        {fat}|{fat}{opmult}{term}
fat         {id}|{ctint}|{ctfloat}|(expr)
%%
{ws}        { ;}
{id}        {strcpy (yylval.string, yytext); return ID;}
{ctint}     {yylval.valor = atoi(yytext); return CTINT;}
{ctfloat}   {yylval.valreal = atof(yytext); return CTFLOAT;}
"<"         {yylval.atr = MENOR; return OPREL;}
"<="        {yylval.atr = MENIG; return OPREL;}
">"         {yylval.atr = MAIOR; return OPREL;}
">="        {yylval.atr = MAIG; return OPREL;}
"="         {yylval.atr = IGUAL; return OPREL;}
"<>"        {yylval.atr = DIFER; return OPREL;}
"*"         {yylval.atr = VEZES; return OPMULT;}
"/"         {yylval.atr = DIV; return OPMULT;}
"%"         {yylval.atr = REST; return OPMULT;}
"+"         {yylval.atr = MAIS; return OPAD;}
"-"         {yylval.atr = MENOS; return OPAD;}
%%

main () {
    int i;
    printf ("\n   texto  |   tipo   | atributo \n");
    printf ("--------------------------------\n");
    while (i = yylex ()) {
        printf ("%10s|%10d|", yytext, i);
        switch (i) {
            case ID:
                printf ("%10s", yylval.string); break;
            case CTINT:
                printf ("%10d", yylval.valor); break;
            case CTFLOAT:
                printf ("%10f", yylval.valreal); break;
            case OPREL:
                printf ("%10d", yylval.atr); break;
            case OPMULT:
                printf ("%10d", yylval.atr); break;
            case OPAD:
                printf ("%10d", yylval.atr); break;
        }
        printf ("\n");
    }
} 