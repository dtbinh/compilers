%{
#define 	WHILE		1
#define 	IF		2
#define 	IF11		3
#define 	FOR		4
#define 	ELSE		5
%}
%%
while		{return WHILE;}
if			{return IF;}
if11		{return IF11;}
for		{return FOR;}
else		{return ELSE;}
%%
main () {
	int i;
	while (i = yylex ()) 
		printf ("\nstring: %6s; tipo: %d; \n", yytext, i);
}