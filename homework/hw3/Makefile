.PHONY: zip

FILES := lamp/eval.ml
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)