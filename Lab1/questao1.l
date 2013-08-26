%{
#define ACEITA  1
#define     OUTRA   2
%}
delim       [ \t\n\r]
ws          {delim}+
aceita      ((12222*)|(022*)|(012222*))*
string      [^ \t\n\r]+
%%
{ws}        { ;}
{aceita}    {return ACEITA;}
{string}    {return OUTRA;}
%%
main () {
    int i;
    while (i = yylex ())
        switch (i) {
            case ACEITA:
                printf ("%-20s: Aceita\n", yytext); 
                break;
            case OUTRA:
                printf ("%-20s: Rejeitada\n", yytext); 
                break;
        }
} 