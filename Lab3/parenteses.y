%%
SS 	: S '$' {printf ("Fim da analise\n"); 			    return;} ;
S 	:
		| {printf ("\nyyy");} S  '('  S  ')'
		;
%%
yylex () {
	char x; x = getchar ();
	while (x == ' ' || x == '\n' || x == '\t' || 
			x == '\r')
		x = getchar ();
	printf ("Caractere lido: %c\n", x);
	if (x == '\(' || x == ')' || x == '$') 
		return x;
	return '#';
}