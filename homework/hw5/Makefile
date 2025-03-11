.PHONY: zip

FILES := lamp/typeinfer.ml lamp/curry_howard.ml
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)