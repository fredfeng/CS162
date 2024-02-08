.PHONY: zip

FILES := lib/lamp/eval.ml lib/meta/encodings.ml lib/meta/meta.lp
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)