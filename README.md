# Mini-LISP-interpreter

This is a final project for a compiler course, implementing a interpreter for a partial LISP language. The input string will be transformed into tokens according to the predefined rule section using lex, which will then be passed to yacc to build an AST tree based on the grammar section. Finally, the AST tree will be traversed and LISP code will be implemented in C.

## How to Compile
1. bison -d -o y.tab.c fp.y
2. gcc -c -g -I.. y.tab.c
3. flex -o lex.yy.c fp.l
4. gcc -c -g -I.. lex.yy.c
5. gcc -o fp y.tab.o lex.yy.o -ll
## Run it
./fp <"your input file"

## Operation Overview

| Name     | Symbol | Example         |
| -------- | ------ | --------------- |
| Plus     | +      | (+ 1 2) => 3    |
| Minus    | -      | (- 1 2) => -1   |
| Multiply | *      | (* 2 3) => 6    |
| Divide   | /      | (/ 6 3) => 2    |
| Modulus  | mod    | (mod 8 3) => 2  |
| Greater  | >      | (> 1 2) => #f   |
| Smaller  | <      | (< 1 2) => #t   |
| Equal    | =      | (= 1 2) => #f   |
| And      | and    | (and #t #f) => #f |
| Or       | or     | (or #t #f) => #t  |
| Not      | not    | (not #t) => #f  |
| DEF-STMT | define | (define x 5)    |
| Function | fun    | (fun (x) (+ x 1)) |
| IF-STMT  | if     | (if (= 1 0) 1 2) |
