delim		[ \t\n]
ws		{delim}+
digit		[0-9]
ctint		{digit}+
ctfloat	{digit}+\.{digit}*
%%
{ws}		{ ;}
{ctint}	{yylval.valint = atoi(yytext);
				 return CTINT;}
{ctfloat}	{yylval.valfloat = atof(yytext);
				 return CTFLOAT;}
"+"		{yylval.atr = MAIS; return OPAD;}
"-"		{yylval.atr = MENOS; return OPAD;}
"*"		{yylval.atr = VEZES; return OPMULT;}
"/"		{yylval.atr = DIV; return OPMULT;}
"("		{return ABPAR;}
")"		{return FPAR;}
"$"		{return DOLAR;}
%% 