%{
#include "y.tab.h"
#include <stdio.h>
%}
seperator	"\t"|"\n"|"\r"|" "
letter		[a-z]
digit		[0-9]
number		0|[1-9]{digit}*|"-"[1-9]{digit}*
ID		{letter}({letter}|{digit}|"-")*
%%
{seperator}
"print-num" {return(print_num);}
"print-bool" {return(print_bool);}
"#t" {yylval.b=1; return(bool_val);}
"#f" {yylval.b=0; return(bool_val);}
"("|")"|"+"|"-"|"*"|"/"|">"|"<"|"=" {return(yytext[0]);}
"mod" {return('%');}
"and" {return('&');}
"or" {return('|');}
"not" {return('^');}
"if" {return('?');}
"define" {return('#');}
"fun" {return('~');}
{ID} {yylval.s=strdup(yytext); return(id);}
{number} {yylval.i=atoi(yytext); return(number);}
.
%%