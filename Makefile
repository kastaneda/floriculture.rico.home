JPG = $(shell find 20*/ -type f -name '*.jpg' | grep -v thumb)
JPG_THUMB = $(patsubst %.jpg,%.thumb.jpg,$(JPG))
WEBP_ALL = $(patsubst %.jpg,%.webp,$(JPG) $(JPG_THUMB))

build: img
	jekyll b

img: $(JPG_THUMB) $(WEBP_ALL)

%.thumb.jpg: %.jpg Makefile
	convert -define jpeg:size=600x600 $< \
	  -thumbnail 300x300^ -gravity center -extent 300x300 $@

%.webp: %.jpg
	cwebp $< -o $@

.PHONY: img build
