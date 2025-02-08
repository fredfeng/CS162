.PHONY: zip

FILES := lib/part1/part1.ml lib/part2/eval.ml
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)