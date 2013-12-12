%{
void comentario (void);
char tratachar (char *);
void tratacadeia (char *);
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
{ctcarac}       {yylval.carac = tratachar(yytext); return CTCARAC;}
{cadeia}        {strcpy (yylval.cadeia, yytext); tratacadeia (yylval.cadeia); return CADEIA;}
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
/*
    tratachar: retorna o codigo ASCII de uma constante do tipo char,
   eliminando os apostrofos e as barras invertidas
 */

char tratachar (char *s) {
    if (s[1] != '\\') return s[1];
    else switch (s[2]) {
        case 'a':   return 7;       case '\\':  return 92;
        case 'b':   return 8;       case 'r':   return 13;
        case '\"':  return 34;      case 'f':   return 12;
        case 't':   return 9;       case 'n':   return 10;
        case '0':   return 0;       case '\'':  return 39;
        case 'v':   return 11;
        default:        return s[2];
    }
}

/*
    tratacadeia: elimina as aspas e as barras invertidas
    de uma constante do tipo char, substituindo-as pelo respectivo
    codigo ASCII
 */

 void tratacadeia (char *s) {
    int i, n, d;
    n = strlen (s);
    for (i = 0, d = 1; i <= n-2-d; i++)   {
        if (s[i+d] != '\\') s[i] = s[i+d];
        else { 
            switch (s[i+d+1]) {
                case 'a':   s[i] = 7;break;
                case '\\':  s[i] = 92; break;
                case 'b':   s[i] = 8; break;
                case 'r':   s[i] = 13; break;
                case '\"':  s[i] = 34; break;
                case 'f':   s[i] = 12; break;
                case 't':   s[i] = 9;  break;
                case 'n':   s[i] = 10; break;
                case '\0':  s[i] = 0;  break;
                case '\'':  s[i] = 39; break;
                case 'v':   s[i] = 11; break;
                default:        s[i] = s[i+d+1];
            }
            d++;
        }
    }
    s[i] = s[n];
}