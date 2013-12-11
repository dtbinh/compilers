%{
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
{id}            {strcpy (yylval.cadeia, yytext); return ID;}
{ctint}         {yylval.valint = atoi(yytext); return CTINT;}
{ctcarac}       {yylval.carac = yytext; return CTCARAC;}
{cadeia}        {strcpy (yylval.cadeia, yytext); return CADEIA;}
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
