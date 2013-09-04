%token a
%token b
%token c
%token dolar
%token erro
%%
SS	:	S dolar {printf ("Fim da analise\n"); return;} ;
S	:	X C  |  A Y  ;
A	:  /* vazia */  |  A a  ;
X	:  /* vazia */  |  a X b  ;
Y	:  /* vazia */  |  b Y c  ;
C	:  /* vazia */  |  C c  ;
%%
yylex () {
char x;
	x = getchar ();
	while (x == ' ' || x == '\n' || 
			x == '\t' || x == '\r')
		x = getchar ();
	printf ("Caractere lido: %c\n", x);
	if (x == 'a') return a; 
	if (x == 'b') return b;
	if (x == 'c') return c; 
	if (x == '$') return dolar; 
	return erro;
}