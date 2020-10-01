%{
#include <stdio.h>

/* to avoid implicite function definition warning */
int yylex();
int yyerror(); 
%}

/* declare tokens, terminals */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL /* end of line */
%token OP CP /* open/closing parenthesis */

%%

calclist: /* nothing, matches at the beginning of input */
  | calclist exp EOL { printf("= %d\n", $2); }
  ;

exp: factor
  | exp ADD factor { $$ = $1 + $3; } 
  | exp SUB factor { $$ = $1 - $3; }
  ;

factor: term
  | factor MUL term { $$ = $1 * $3; }
  | factor DIV term { $$ = $1 / $3; }
  ;

term: NUMBER 
  | ABS term { $$ = $2 >= 0? $2 : -$2; }
  | OP exp CP { $$ = $2; }
  ;

%%
int main(int argc, char **argv) {
  yyparse();
}

int yyerror(char *s) {
  fprintf(stderr, "error: %s\n", s);
}