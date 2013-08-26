%{
#define ACEITA  1
#define     OUTRA   2
%}
carac       [0-1]
delim       [ \t\n\r]
ws          {delim}+
aceita      
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