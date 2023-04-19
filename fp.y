%{
	#include <stdio.h>
	#include <string.h>
	#include "fp.h"

	void yyerror(const char *message);
	struct node *root;
	int i,def_var_num=0,def_fun_num=0,fun_var_num=0,fun_id_num=0,fun_call=0,jud=1;

	struct id_map{
		int i,b;
		char* s;
	};
	struct id_map global_var[100];
	struct id_map fun_var[100];

	struct fun_map{
		char *s;
		struct node *n;
	};
	struct fun_map fun[100];
%}

%union {
	int i,b;
	char* s;
	struct node *n;
}

%token <i> number
%token <b> bool_val
%token <s> id
%token print_num print_bool
%type <n> EXP STMT PRINT-STMT PROGRAM NUM-OP MINUS DIVIDE MODULUS GREATER SMALLER EXP_LIST PLUS MUTIPLY EQUAL
%type <n> LOGICAL-OP AND-OP OR-OP NOT-OP IF-EXP TEST-EXP THEN-EXP ELSE-EXP DEF-STMT VARIABLE FUN-EXP FUN-CALL
%type <n> ID_LIST PARAM_LIST PARAM FUN-IDs FUN-BODY FUN-NAME

%%
PROGRAM		: STMT PROGRAM
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$1;
		 $$->r=$2;
		 root=$$;}
		| {$$=NULL;}
		;
STMT 		: EXP {$$=$1;}
		| PRINT-STMT {$$=$1;}
		| DEF-STMT {$$=$1;}
		;
PRINT-STMT 	: '(' print_num EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=NULL;
		 $$->type="print_num";}
		| '(' print_bool EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=NULL;
		 $$->type="print_bool";}
		;
EXP 		: bool_val 
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->b=$1;
		 $$->type="bool_val";}
		| number
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->i=$1;
		 $$->type="num";}
		| VARIABLE
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$1;
		 $$->type="match";}
		| NUM-OP {$$=$1;}
		| LOGICAL-OP {$$=$1;}
		| FUN-EXP {$$=$1;}
		| FUN-CALL {$$=$1;}
		| IF-EXP {$$=$1;}
		;
NUM-OP		: PLUS {$$=$1;}
		| MINUS {$$=$1;}
		| MUTIPLY {$$=$1;}
		| DIVIDE {$$=$1;}
		| MODULUS {$$=$1;}
		| GREATER {$$=$1;}
		| SMALLER {$$=$1;}
		| EQUAL {$$=$1;}
		;
EXP_LIST	: EXP EXP_LIST
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$1;
		 $$->r=$2;}
		| EXP
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$1;
		 $$->r=NULL;}
		;
PLUS 		: '(' '+' EXP EXP_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="+";}
		;
MINUS 		: '(' '-' EXP EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="-";}
		;
MUTIPLY 	: '(' '*' EXP EXP_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="*";}
		;
DIVIDE 		: '(' '/' EXP EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="/";}
		;
MODULUS 	: '(' '%' EXP EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="%";}
		;
GREATER 	: '(' '>' EXP EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type=">";}
		;
SMALLER 	: '(' '<' EXP EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="<";}
		;
EQUAL 		: '(' '=' EXP EXP_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="=";}
		;
LOGICAL-OP 	: AND-OP {$$=$1;}
		| OR-OP {$$=$1;}
		| NOT-OP {$$=$1;}
		;
AND-OP 		: '(' '&' EXP EXP_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="&";}
		;
OR-OP 		: '(' '|' EXP EXP_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="|";}
		;
NOT-OP 		: '(' '^' EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->type="^";}
		;
IF-EXP 		: '(' '?' TEST-EXP THEN-EXP ELSE-EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->el=$5;
		 $$->type="?";}
		;
TEST-EXP 	: EXP {$$=$1;}
		;
THEN-EXP 	: EXP {$$=$1;}
		;
ELSE-EXP 	: EXP {$$=$1;}
		;
DEF-STMT 	: '(' '#' VARIABLE EXP ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="#";}
		;
VARIABLE 	: id
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->s=$1;
		 $$->type="id";}
		;
ID_LIST		: id ID_LIST
		{$$=(struct node*)malloc(sizeof(struct node));
		 struct node *tmp=(struct node*)malloc(sizeof(struct node));
		 tmp->s=$1;
		 $$->l=tmp;
		 $$->r=$2;
		 $$->type="id_list";}
		| {$$=NULL;}
		;
		;
PARAM_LIST	: PARAM PARAM_LIST
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$1;
		 $$->r=$2;
		 $$->type="param_list";}
		| {$$=NULL;}
		;
FUN-EXP 	: '(' '~' FUN-IDs FUN-BODY ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$4;
		 $$->type="fun-exp";}
		;
FUN-IDs 	: '(' ID_LIST ')' {$$=$2;}
		;
FUN-BODY 	: EXP {$$=$1;}
		;
FUN-CALL 	: '(' FUN-EXP PARAM_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$2;
		 $$->type="call";}
		| '(' FUN-NAME PARAM_LIST ')'
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->l=$3;
		 $$->r=$2;
		 $$->type="call";}
		;
PARAM		: EXP {$$=$1;}
		;
FUN-NAME	: id
		{$$=(struct node*)malloc(sizeof(struct node));
		 $$->s=$1;
		 $$->type="funname";}
		;
%%

void yyerror (const char *message)
{
	jud=0;
        fprintf (stderr, "%s\n",message);
}

void copy(struct node *n, struct node *m){
	n->type=m->type;
	n->i=m->i;
	n->b=m->b;
	n->s=m->s;
}

void traverse(struct node *n){
	if(n->l) traverse(n->l);
	if(n->r) traverse(n->r);

	if(n->type=="print_num") printf("%d\n",n->l->i);

	else if(n->type=="print_bool"){
		if(n->l->b==1) printf("#t\n");
		else printf("#f\n");
	}

	else if(n->type=="+"){
		struct node *tmp=n;
		n->i=0;
		while(tmp->r){
			n->i+=tmp->l->i;
			tmp=tmp->r;
		}
		n->i+=tmp->l->i;
	}

	else if(n->type=="-") n->i=n->l->i-n->r->i;

	else if(n->type=="*"){
		struct node *tmp=n;
		n->i=1;
		while(tmp->r){
			n->i*=tmp->l->i;
			tmp=tmp->r;
		}
		n->i*=tmp->l->i;
	}

	else if(n->type=="/"){
		n->i=n->l->i/n->r->i;
	}

	else if(n->type=="%") n->i=n->l->i%n->r->i;

	else if(n->type==">"){
		if(n->l->i>n->r->i) n->b=1;
		else n->b=0;
	}

	else if(n->type=="<"){
		if(n->l->i<n->r->i) n->b=1;
		else n->b=0;
	}

	else if(n->type=="="){
		struct node *tmp=n;
		n->b=1;
		int tmpnum=n->l->i;
		while(tmp->r){
			tmp=tmp->r;
			if(tmp->l->i!=tmpnum){
				n->b=0;
				break;
			}
		}
	}

	else if(n->type=="&"){
		struct node *tmp=n;
		n->b=1;
		while(tmp->r){
			n->b=n->b&&tmp->l->b;
			tmp=tmp->r;
		}
		n->b=n->b&&tmp->l->b;
	}

	else if(n->type=="|"){
		struct node *tmp=n;
		n->b=0;
		while(tmp->r){
			n->b=n->b||tmp->l->b;
			tmp=tmp->r;
		}
		n->b=n->b||tmp->l->b;
	}

	else if(n->type=="^"){
		if(n->l->b==1) n->b=0;
		else n->b=1;
	}

	else if(n->type=="?"){
		if(n->l->b==1){
			copy(n,n->r);
		}
		else{
			traverse(n->el);
			copy(n,n->el);
		}
	}

	else if(n->type=="#"){
		if(n->r->type=="fun-exp"){
			fun[def_fun_num].n=n->r;
			fun[def_fun_num].s=n->l->s;
			def_fun_num++;
		}
		else{
			global_var[def_var_num].s=n->l->s;
			global_var[def_var_num].i=n->r->i;
			global_var[def_var_num].b=n->r->b;
			def_var_num++;
		}	
	}

	else if(n->type=="match"){
		n->i=1;
		if(fun_call){
			int find=0;
			n->s=n->l->s;
			for(i=0;i<fun_var_num;i++){
				if(!strcmp(fun_var[i].s,n->l->s)){
					n->i=fun_var[i].i;
					n->b=fun_var[i].b;
					find=1;
					break;
				}
			}
			if(!find){
				for(i=0;i<def_var_num;i++){
					if(!strcmp(global_var[i].s,n->l->s)){
						n->i=global_var[i].i;
						n->b=global_var[i].b;
						break;
					}
				}
			}
		}
		else{
			n->s=n->l->s;
			for(i=0;i<def_var_num;i++){
				if(!strcmp(global_var[i].s,n->l->s)){
					n->i=global_var[i].i;
					n->b=global_var[i].b;
					break;
				}
			}
		}
	}

	else if(n->type=="param_list"){
		fun_call=1;
		fun_var[fun_var_num].i=n->l->i;
		fun_var[fun_var_num].b=n->l->b;
		fun_var_num++;
	}

	else if(n->type=="id_list"){
		if(fun_call){
			fun_var[fun_id_num].s=n->l->s;
			fun_id_num++;
		}
	}

	else if(n->type=="fun-exp"){
		if(fun_call){
			n->i=n->r->i;
			n->b=n->r->b;
		}
	}

	else if(n->type=="call"){
		if(n->r->type=="funname"){
			fun_call=1;
			for(i=0;i<def_fun_num;i++){
				if(!strcmp(fun[i].s,n->r->s)){
					traverse(fun[i].n);
					n->i=fun[i].n->i;
					n->b=fun[i].n->b;
					break;
				}
			}
			fun_call=0;
			fun_var_num=0;
			fun_id_num=0;
		}
		else{
			if(fun_call==0){
				fun_call=1;
				traverse(n->r);
				
			}
			fun_call=0;
			fun_var_num=0;
			fun_id_num=0;
			n->i=n->r->i;
			n->b=n->r->b;
		}
	}
}

int main(int argc, char *argv[]) {
        yyparse();
	if(jud) traverse(root);
        return(0);
}