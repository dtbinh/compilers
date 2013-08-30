delim		[ \t\n\r]
ws			{delim}+
digit		[0-9]
num		{digit}+
%%
{ws}		{ ;}
{num}		{return CTE;}
"+"		{return OPAD;}
"-"		{return OPAD;}
"*"		{return OPMULT;}
"/"		{return OPMULT;}
"("		{return ABPAR;}
")"		{return FPAR;}
"$"		{return DOLAR;}
.			{return INVAL;}
%%