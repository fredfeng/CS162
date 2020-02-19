# Infer makefile
#
# targets are:
#
# all -- rebuild the project (default)
# clean -- remove all objects and executables

VERSION = $(shell ver=$$(ocaml --version); echo $${ver:0-6})
$(info $$VERSION is ${VERSION})
SOURCES = ast.ml Parser/parser.mli Parser/parser.ml Parser/lexer.ml Ref/$(VERSION)/infer.cmo unify.ml repl.ml

# for bytecode compiling only
# SOURCES = ast.ml Parser/parser.mli Parser/parser.ml Parser/lexer.ml Ref/$(VERSION)/infer.ml unify.ml repl.ml


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
	ocamlc -o repl.o -g -I Parser -I Ref/$(VERSION) str.cma $(SOURCES)

Parser/parser.mli Parser/parser.ml: Parser/parser.mly ast.ml
	ocamlyacc -v Parser/parser.mly

Parser/lexer.ml: Parser/lexer.mll Parser/parser.ml
	ocamllex Parser/lexer.mll
