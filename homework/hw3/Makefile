.PHONY: zip

FILES := lib/lamp/eval.ml lib/meta/encodings.txt
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)