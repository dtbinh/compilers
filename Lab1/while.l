%{
#define 	WHILE		1
%}
%%
while		{return WHILE;}
%%
main () {
	int i;
	while (i = yylex ()) 
		printf ("\nstring: %6s; tipo: %d; \n", yytext, i);
} 
