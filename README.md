# Mini-LISP-interpreter

This is a final project for a compiler course, implementing a compiler for a partial LISP language. The input string will be transformed into tokens according to the predefined rule section using lex, which will then be passed to yacc to build an AST tree based on the grammar section. Finally, the AST tree will be traversed and LISP code will be implemented in C.

- How to Compile:
  - bison -d -o y.tab.c fp.y
  - gcc -c -g -I.. y.tab.c
  - flex -o lex.yy.c fp.l
  - gcc -c -g -I.. lex.yy.c
  - gcc -o fp y.tab.o lex.yy.o -ll
- Run the program:
  - ./fp <"your input file"
