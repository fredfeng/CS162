.PHONY: zip

FILES := lib/part1/part1.ml lib/lamp/eval.ml lib/part4/*.lp
ARCHIVE := submission.zip

$(ARCHIVE): $(FILES)
	zip -j $(ARCHIVE) $(FILES)

zip: $(ARCHIVE)