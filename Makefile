JPG = $(shell find 20*/ -type f -name '*.jpg' | grep -v thumb | grep -v mid)
JPG_THUMB = $(patsubst %.jpg,%.thumb.jpg,$(JPG))
JPG_MID = $(patsubst %.jpg,%.mid.jpg,$(JPG))
WEBP_ALL = $(patsubst %.jpg,%.webp,$(JPG) $(JPG_THUMB) $(JPG_MID))
IMAGES_ALL = $(JPG) $(JPG_THUMB) $(JPG_MID) $(WEBP_ALL)

build: img _data/images.json
	jekyll b

img: $(IMAGES_ALL)

%.thumb.jpg: %.jpg
	convert -define jpeg:size=600x600 $< \
	  -thumbnail 300x300^ -gravity center -extent 300x300 $@

%.mid.jpg: %.jpg
	convert $< -thumbnail 1280x1280^ $@

%.webp: %.jpg
	cwebp $< -o $@

_data/images.json: $(IMAGES_ALL) Makefile
	mkdir -p _data
	echo "[" > $@
	identify -format "{ 'file': '/%d/%f', 'width': %w, 'height': %h },\n" $(IMAGES_ALL) >> $@
	echo "{ 'file': 'stub' }" >> $@
	echo "]" >> $@

.PHONY: img build
