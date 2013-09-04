delim		[ \t\n]
ws			{delim}+
digito	[0-9]
letra		[A-Za-z]
ctint		{digito}+
id			{letra}({letra}|{digito})*
%%
{ws}		{ ;}
{id}		{strcpy (yylval.cadeia, yytext); return ID;}
{ctint}	{yylval.valint = atoi(yytext); return CTINT;}
"+"		{yylval.atr = MAIS; return OPAD;}
"-"		{yylval.atr = MENOS; return OPAD;}
"("		{return ABPAR;}
")"		{return FPAR;}
"{"		{return ABCHAV;}
"}"		{return FCHAV;}
";"		{return PVIRG;}
":="		{return ATRIB;}
.			{yylval.carac = yytext[0]; return INVAL;}
%%
