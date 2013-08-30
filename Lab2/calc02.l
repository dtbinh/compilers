delim		[ \t\n]
ws		{delim}+
digit		[0-9]
cte		{digit}+(\.{digit}*)?
%%
{ws}		{ ;}
{cte}		{yylval = atof(yytext); return CTE;}
"+"		{return MAIS;}
"*"		{return VEZES;}
"("		{return ABPAR;}
")"		{return FPAR;}
"$"		{return DOLAR;}
%%