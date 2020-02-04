# Infer makefile
#
# targets are:
#
# all -- rebuild the project (default)
# clean -- remove all objects and executables

SOURCES = ast.ml Parser/parser.mli Parser/parser.ml Parser/lexer.ml unify.ml infer.ml repl.ml

.PHONY: all
all: Parser/parser.mli Parser/parser.ml Parser/lexer.ml infer.exe

.PHONY: clean
clean:
	rm -f infer.exe
	rm -f Parser/parser.ml Parser/parser.mli Parser/lexer.ml
	for X in . Parser; do \
	  for Y in cmo cmi output; do \
        rm -f $$X/*.$$Y; \
      done; \
    done

infer.exe: $(SOURCES)
	ocamlc -o infer.exe -g -I Parser str.cma $(SOURCES)

Parser/parser.mli Parser/parser.ml: Parser/parser.mly ast.ml
	ocamlyacc -v Parser/parser.mly

Parser/lexer.ml: Parser/lexer.mll Parser/parser.ml
	ocamllex Parser/lexer.mll
