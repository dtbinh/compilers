%{
#define 		DOLAR 	0
#define		LT		1
#define		LE		2
#define		EQ		3
#define		NE		4
#define		GT		5
#define		GE		6
#define		IF		7
#define 		THEN 		8
#define 		ELSE 		9
#define		ID		10
#define		NUM		11
%}
delim		[ \t\n\r]
ws			{delim}+
digito	[0-9]
letra		[A-Za-z]
num		{digito}+
id			{letra}({letra}|{digito})*
%%
{ws}		{ ;}
{id}		{return ID;}
if			{return IF;}
then		{return THEN;}
else		{return ELSE;}
{num}		{return NUM;}
"<"		{return LT;}
"<="		{return LE;}
"="		{return EQ;}
"<>"		{return NE;}
">"		{return GT;}
">="		{return GE;}
"$"		{return DOLAR;}
%%
main () {
	int i;
	while (i = yylex ()) 
		printf ("\nstring: %6s; tipo: %d;", yytext, i);
}
