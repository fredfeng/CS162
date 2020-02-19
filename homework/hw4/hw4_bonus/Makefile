# Infer makefile
#
# targets are:
#
# all -- rebuild the project (default)
# clean -- remove all objects and executables

SOURCES = ast.ml Parser/parser.mli Parser/parser.ml Parser/lexer.ml infer.ml unify.ml repl.ml


.PHONY: all
all: Parser/parser.mli Parser/parser.ml Parser/lexer.ml repl.o

.PHONY: clean
clean:
	rm -f repl.o
	rm -f Parser/parser.ml Parser/parser.mli Parser/lexer.ml
	for X in . Parser; do \
	  for Y in cmo cmi output; do \
        rm -f $$X/*.$$Y; \
      done; \
    done

repl.o: $(SOURCES)
	ocamlc -o repl.o -g -I Parser str.cma $(SOURCES)

Parser/parser.mli Parser/parser.ml: Parser/parser.mly ast.ml
	ocamlyacc -v Parser/parser.mly

Parser/lexer.ml: Parser/lexer.mll Parser/parser.ml
	ocamllex Parser/lexer.mll
