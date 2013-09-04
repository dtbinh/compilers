%{
#include <stdio.h>
#include <stdlib.h>
int v, w, x, y, z;
%}
%%
A	:	{w = 10; $$ = 5*w;}  B  
		{$$ = 1; v = $1; y = $2;} C
		{
			x = $3; z = $4;
		printf ("v = %d; w = %d; x = %d; y = %c; z = %c;",
				v, w, x, y, z);
			return 0; 
		}
	;
B	:	'b'
	;
C	:	'c'
	;
%%
A	:	{w = 10; $$ = 5*w;}  B  
		{$$ = 1; v = $1; y = $2;} C
		{
			x = $3; z = $4;
			printf ("- - -", v, w, x, y, z);
			return 0; 
		}
	;
B	:	'b'
	;
C	:	'c'
	; 