.PHONY: zip

FILES := lib/lamp/typeinfer.ml lib/lamp/curry_howard.ml
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)