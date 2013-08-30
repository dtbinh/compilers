%%
prod :	'C' 'O' 'M' 'P' ' ' '1' '4'	
			{printf ("Reconheco!\n"); return;}
	  ; 
%%
yylex () {
	return getchar ();
} 