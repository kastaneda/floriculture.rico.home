JPG = $(shell find 20*/ -type f -name '*.jpg' | grep -v thumb)
JPG_THUMB = $(patsubst %.jpg,%.thumb.jpg,$(JPG))
WEBP_ALL = $(patsubst %.jpg,%.webp,$(JPG) $(JPG_THUMB))

build: img
	jekyll b

img: $(JPG_THUMB) $(WEBP_ALL)

%.thumb.jpg: %.jpg
	convert -define jpeg:size=400x400 $< \
	  -thumbnail 200x200^ -gravity center -extent 200x200 $@

%.webp: %.jpg
	cwebp $< -o $@

.PHONY: img build
