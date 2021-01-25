BUILD_DIR = _build
TARGET = repl.exe

BINARY = lamp

all:
	dune build $(TARGET)

.PHONY: test
test:
	dune build test.exe
	dune exec -- ./test.exe --show-errors

.PHONY: run
run: all
	dune exec -- ./$(TARGET)

.PHONY: dist
dist: all
	cp $(BUILD_DIR)/default/$(TARGET) ./$(BINARY)
	chmod 755 $(BINARY)
	strip $(BINARY)

.PHONY: clean
clean:
	dune clean
	rm -rf $(BINARY)
