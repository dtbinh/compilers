delim		[ \t\n\r]
ws		{delim}+
digit		[0-9]
num		{digit}+
%%
{ws}		{ ;}
{num}		{yylval = atoi(yytext); return CTE;}
"+"		{yylval = MAIS; return OPAD;}
"-"		{yylval = MENOS; return OPAD;}
"*"		{yylval = VEZES; return OPMULT;}
"/"		{yylval = DIV; return OPMULT;}
"("		{return ABPAR;}
")"		{return FPAR;}
"$"		{return DOLAR;}
%%